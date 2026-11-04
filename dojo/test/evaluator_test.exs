defmodule KataEvolve.EvaluatorFixture do
  def spec, do: Process.get(:evaluator_spec)
  def prompt(item), do: (Process.get(:evaluator_prompt) || "Read the file") <> " #{item.id}"
  def proposal_instructions, do: Process.get(:proposal_rules, "")

  def outcome_contract,
    do: Process.get(:outcome_contract, ["Read accurately and preserve the project."])

  def prepare(root, _item) do
    File.write!(Path.join(root, "input.txt"), "input")
    KataEvolve.Evidence.git(root, ["init", "-q"])
    KataEvolve.Evidence.git(root, ["add", "."])

    KataEvolve.Evidence.git(root, [
      "-c",
      "user.name=Fixture",
      "-c",
      "user.email=fixture@example.invalid",
      "commit",
      "-qm",
      "Fixture"
    ])
  end

  def check(record, _item) do
    case Process.get(:evaluator_check, :normal) do
      :crash -> raise "Broken checker"
      :reject -> %{"correct" => false}
      :review -> %{"correct" => {:review, "Cannot determine the claim from this format"}}
      :normal -> %{"correct" => record["answer"] == "correct"}
    end
  end
end

defmodule KataEvolve.EvaluatorTest do
  use ExUnit.Case
  import ExUnit.CaptureIO
  alias KataEvolve.{Assessment, Evidence, Experiment, Score, Usage}
  alias KataEvolve.EvaluatorFixture, as: Fixture

  setup do
    dir = Path.join(System.tmp_dir!(), "evaluator-#{System.unique_integer([:positive])}")
    File.mkdir_p!(dir)
    source = Path.join(dir, "SKILL.md")
    checker = Path.join(dir, "checker.ex")
    preparation = Path.join(dir, "project.ex")
    File.write!(source, "---\nname: evaluator-test\ndescription: Read.\n---\nRead input.txt.\n")
    File.write!(checker, "checker v1")
    File.write!(preparation, "fixed preparation")

    items =
      for {id, split} <- [{"train", :train}, {"final-a", :final}, {"final-b", :final}],
          do: %{id: id, split: split, writable: []}

    spec = %{
      id: "evaluator-test",
      source: source,
      support: [],
      cases: items,
      inputs: [checker],
      execution_inputs: [preparation],
      checks: Map.new(items, &{&1.id, ["correct"]})
    }

    Process.put(:evaluator_spec, spec)
    Process.delete(:evaluator_check)
    Process.delete(:evaluator_prompt)
    Process.delete(:proposal_rules)
    Process.delete(:outcome_contract)

    ctx = %{
      module: Fixture,
      id: "test",
      dir: dir,
      source: File.read!(source),
      profile: %{},
      assessment: Assessment.identity(Fixture, checker),
      execute: fn _, _, _, _, _ ->
        send(self(), :call)

        {:ok,
         %{
           answer: "correct",
           answer_complete: true,
           metrics: %{
             usage: %{input_tokens: 90, output_tokens: 10, total_tokens: 100},
             tool_calls: 1,
             elapsed_ms: 10
           }
         }}
      end
    }

    on_exit(fn -> File.rm_rf!(dir) end)
    %{ctx: ctx, checker: checker, preparation: preparation, spec: spec}
  end

  test "checker repair reuses a run, keeps the original failure, and saves a new assessment",
       env do
    ctx = env.ctx
    contract = Experiment.execution_contract(Fixture)
    Process.put(:evaluator_check, :reject)

    capture_io(fn ->
      assert_raise RuntimeError, ~r/Source outcome failed/, fn ->
        Experiment.batch(ctx, ctx.source, "source-train", :train, 1)
      end

      path = Path.join(ctx.dir, "batches/test/source-train/cases/train-1.json")
      raw = File.read!(path)
      assert Evidence.read(path)["outcome_test"]["status"] == "failed"
      Process.put(:evaluator_check, :normal)
      File.write!(env.checker, "checker v2")

      fixed = %{
        ctx
        | assessment: Assessment.identity(Fixture, env.checker),
          execute: fn _, _, _, _, _ -> flunk("A checker repair must not call the model") end
      }

      assert fixed.assessment != ctx.assessment
      assert Experiment.execution_contract(Fixture) == contract
      [record] = Experiment.batch(fixed, ctx.source, "source-train", :train, 1)
      assert record["outcome_test"]["status"] == "passed"
      assert File.read!(path) == raw
      assert length(Path.wildcard(Path.join(ctx.dir, "assessments/*/*.json"))) == 2
      assert Assessment.read!(fixed, path) == record
      assert Usage.summary(ctx.dir).calls == 1
    end)

    assert_received :call
    refute_received :call
  end

  test "fixture, prompt, and support changes invalidate execution contracts", env do
    original = Experiment.execution_contract(Fixture)
    File.write!(env.preparation, "changed project")
    refute Experiment.execution_contract(Fixture) == original
    File.write!(env.preparation, "fixed preparation")
    Process.put(:evaluator_prompt, "Change the file")
    refute Experiment.execution_contract(Fixture) == original
    Process.delete(:evaluator_prompt)
    File.write!(Path.join(env.ctx.dir, "helper.txt"), "helper")
    Process.put(:evaluator_spec, %{env.spec | support: ["helper.txt"]})
    refute Experiment.execution_contract(Fixture) == original
  end

  test "full context keeps checker edits separate but changes for model and source", env do
    old = System.get_env("KATA_CODEX_PATH")
    # --version only: no model executable or API is involved.
    System.put_env("KATA_CODEX_PATH", "/usr/bin/true")
    results = Path.join(env.ctx.dir, "contexts-test")
    refute File.exists?(results)

    on_exit(fn ->
      File.rm_rf!(results)

      if old,
        do: System.put_env("KATA_CODEX_PATH", old),
        else: System.delete_env("KATA_CODEX_PATH")
    end)

    capture_io(fn ->
      first = Experiment.context(Fixture, env.checker, results: results)
      File.write!(env.checker, "checker v2")
      next = Experiment.context(Fixture, env.checker, results: results)
      assert first.id == next.id
      refute first.assessment == next.assessment

      other_model =
        Experiment.context(Fixture, env.checker, profile: "codex-sol-medium", results: results)

      refute first.id == other_model.id
      File.write!(env.spec.source, env.ctx.source <> "Read carefully.\n")
      refute first.id == Experiment.context(Fixture, env.checker, results: results).id
    end)
  end

  test "a call budget stops before dispatch and resume only fills missing slots", %{ctx: ctx} do
    limited = Map.put(ctx, :limits, %{calls: 2, tokens: 1000})

    capture_io(fn ->
      assert_raise RuntimeError, ~r/Call budget reached/, fn ->
        Experiment.batch(limited, ctx.source, "source-smoke", :all, 1)
      end

      paths = Path.wildcard(Path.join(ctx.dir, "batches/test/source-smoke/cases/*.json"))
      assert length(paths) == 2
      before = Map.new(paths, &{&1, File.read!(&1)})
      raised = %{limited | limits: %{calls: 3, tokens: 1000}}
      assert length(Experiment.batch(raised, ctx.source, "source-smoke", :all, 1)) == 3
      for {path, bytes} <- before, do: assert(File.read!(path) == bytes)
      assert %{calls: 3, total_tokens: 300, tool_calls: 3, pending: 0} = Usage.summary(ctx.dir)
    end)

    for _ <- 1..3, do: assert_received(:call)
    refute_received :call
  end

  test "token limits and unfinished calls stop new dispatch", %{ctx: ctx} do
    capture_io(fn -> Experiment.batch(ctx, ctx.source, "source-train", :train, 1) end)
    limited = Map.put(ctx, :limits, %{calls: 30, tokens: 100})

    assert_raise RuntimeError, ~r/Token budget reached/, fn ->
      Usage.start!(limited, "next", "case")
    end

    Usage.start!(ctx, "unfinished", "case")
    assert Usage.summary(ctx.dir).pending == 1

    assert_raise RuntimeError, ~r/earlier call has no result/, fn ->
      Usage.start!(ctx, "more", "case")
    end
  end

  test "explicit error retry repeats only the broken slot and keeps its cost", %{ctx: ctx} do
    Process.put(:dispatch_count, 0)
    executor = ctx.execute

    broken = %{
      ctx
      | execute: fn profile, prompt, project, runtime, writable ->
          n = Process.get(:dispatch_count) + 1
          Process.put(:dispatch_count, n)
          {:ok, out} = executor.(profile, prompt, project, runtime, writable)
          if n == 2, do: {:error, %{out | answer: "", answer_complete: false}}, else: {:ok, out}
        end
    }

    capture_io(fn ->
      assert_raise RuntimeError, ~r/execution_error/, fn ->
        Experiment.batch(broken, ctx.source, "source-smoke", :all, 1)
      end

      path = Path.join(ctx.dir, "batches/test/source-smoke/cases/final-a-1.json")
      bytes = File.read!(path)

      assert_raise RuntimeError, ~r/execution_error/, fn ->
        Experiment.batch(ctx, ctx.source, "source-smoke", :all, 1)
      end

      assert Usage.summary(ctx.dir).calls == 2
      retry = Map.put(ctx, :retry_errors, true)
      records = Experiment.batch(retry, ctx.source, "source-smoke", :all, 1)
      assert length(records) == 3
      assert File.read!(path) == bytes
      assert Usage.summary(ctx.dir).calls == 4
      assert Usage.summary(ctx.dir).total_tokens == 400

      assert Experiment.load_batch(ctx, "source-smoke").records
             |> Enum.all?(&(&1["status"] == "completed"))

      Experiment.batch(retry, ctx.source, "source-smoke", :all, 1)
      assert Usage.summary(ctx.dir).calls == 4
    end)
  end

  test "checker errors and review are unscored; proven wrong output scores zero", %{ctx: ctx} do
    capture_io(fn ->
      [reference] = Experiment.batch(ctx, ctx.source, "source-train", :train, 1)

      p = %{
        context: ctx.id,
        assessment: ctx.assessment,
        case_ids: ["train"],
        repetitions: 1,
        checks: KataEvolve.Suite.checks(Fixture) |> Map.take(["train"])
      }

      data = %{text: ctx.source, records: [reference]}

      for {mode, status, score} <- [
            {:crash, "checker_error", nil},
            {:review, "review", nil},
            {:reject, "failed", 0.0}
          ] do
        Process.put(:evaluator_check, mode)
        checked = KataEvolve.Suite.recheck(Fixture, reference)
        assert checked["outcome_test"]["status"] == status
        assert Score.calculate(%{data | records: [checked]}, data, p).score == score
      end

      crashed_run = Map.put(reference, "status", "error")
      assert Score.calculate(%{data | records: [crashed_run]}, data, p).score == nil
    end)
  end

  test "five losing rounds need no full baseline, and duplicate candidates reuse training", %{
    ctx: ctx
  } do
    Process.put(:proposal_number, 0)
    executor = ctx.execute

    execute = fn profile, prompt, project, runtime, writable ->
      if File.exists?(Path.join(project, "feedback.json")) do
        count = Process.get(:proposal_number) + 1
        Process.put(:proposal_number, count)
        feedback = Evidence.read(Path.join(project, "feedback.json"))
        assert File.read!(Path.join(project, "reference.md")) == ctx.source
        assert feedback["target"]["model"] == "gpt-6-astra"
        assert feedback["parent"]["sha256"] == Evidence.hash(ctx.source)
        assert writable == ["SKILL.md"]
        assert Enum.all?(feedback["observations"], &(&1["case_id"] == "train"))

        if count > 1 do
          assert File.read!(Path.join(project, "previous.md")) =~ "Read step #{count - 1}."
          assert List.last(feedback["history"])["decision"] == "rejected"

          assert List.last(feedback["history"])["reason"] ==
                   "Training cost did not beat the parent"

          assert List.last(feedback["history"])["cost_score"] < 50
        else
          refute File.exists?(Path.join(project, "previous.md"))
        end

        # Round five repeats round four: still pay for the proposal, not its evaluation.
        candidate = ctx.source <> "Read step #{min(count, 4)}.\n"
        File.write!(Path.join(project, "SKILL.md"), candidate)

        {:ok,
         %{
           answer: "Updated",
           answer_complete: true,
           metrics: %{
             usage: %{input_tokens: 10, output_tokens: 0, total_tokens: 10},
             tool_calls: 0,
             elapsed_ms: 1
           }
         }}
      else
        {:ok, out} = executor.(profile, prompt, project, runtime, writable)
        skill = File.read!(Path.join(project, ".agents/skills/evaluator-test/SKILL.md"))

        out =
          if skill == ctx.source,
            do: out,
            else:
              put_in(out, [:metrics, :usage], %{
                input_tokens: 190,
                output_tokens: 10,
                total_tokens: 200
              })

        {:ok, out}
      end
    end

    ctx = %{
      ctx
      | execute: execute,
        profile: KataEvolve.Profile.fetch!(KataEvolve.Profile.default())
    }

    capture_io(fn ->
      Experiment.batch(ctx, ctx.source, "source-train", :train, 1)
      selected = Experiment.tune(ctx, 5)
      refute selected.improved
      refute File.exists?(Path.join(ctx.dir, "batches/test/source-full"))
      assert %{calls: 10, proposals: 5} = Usage.summary(ctx.dir)
      assert Experiment.tune(ctx, 5) == selected
      assert Usage.summary(ctx.dir).calls == 10

      candidate =
        Path.wildcard(Path.join(ctx.dir, "skills/*.md"))
        |> Enum.find(&(File.read!(&1) != ctx.source))
        |> File.read!()

      assert_raise RuntimeError, ~r/No measured training improvement/, fn ->
        Experiment.verify(ctx, candidate)
      end

      assert Usage.summary(ctx.dir).calls == 10
      changed = %{ctx | assessment: "changed-checks"}
      assert_raise RuntimeError, ~r/Search checks changed/, fn -> Experiment.tune(changed, 5) end
      Process.put(:proposal_rules, "A different proposal rule.")
      assert_raise RuntimeError, ~r/proposal prompt/, fn -> Experiment.tune(ctx, 5) end
      Process.delete(:proposal_rules)
      Process.put(:outcome_contract, ["Changed required outcome."])
      assert_raise RuntimeError, ~r/proposal prompt/, fn -> Experiment.tune(ctx, 5) end
      assert Usage.summary(ctx.dir).calls == 10
    end)
  end

  test "unchanged proposals skip candidate calls and allow the remaining search approaches", %{
    ctx: ctx
  } do
    executor = ctx.execute

    ctx = %{
      ctx
      | profile: KataEvolve.Profile.fetch!(KataEvolve.Profile.default()),
        execute: fn profile, prompt, project, runtime, writable ->
          if File.exists?(Path.join(project, "feedback.json")) do
            send(self(), {:proposal_prompt, prompt})

            {:ok,
             %{
               answer: "No supported change.",
               answer_complete: true,
               metrics: %{
                 usage: %{input_tokens: 10, output_tokens: 0, total_tokens: 10},
                 tool_calls: 0,
                 elapsed_ms: 1
               }
             }}
          else
            executor.(profile, prompt, project, runtime, writable)
          end
        end
    }

    capture_io(fn ->
      Experiment.batch(ctx, ctx.source, "source-train", :train, 1)
      result = Experiment.tune(ctx, 5)
      refute result.improved
      refute result.full_verification_required
      assert result.stop_reason == nil
      assert File.read!(result.candidate_path) == ctx.source
      assert %{calls: 6, proposals: 5} = Usage.summary(ctx.dir)
      assert_receive {:proposal_prompt, prompt}
      for _ <- 1..4, do: assert_receive({:proposal_prompt, ^prompt})
      saved = Evidence.read(Path.join(ctx.dir, "search/test/proposal-1.json"))
      assert saved["prompt_sha256"] == Evidence.hash(prompt)
      assert saved["candidate"] == ctx.source
      assert saved["feedback"]["reference"]["sha256"] == Evidence.hash(ctx.source)
      assert Experiment.tune(ctx, 5) == result
      assert Usage.summary(ctx.dir).calls == 6
      refute_received {:proposal_prompt, _}
    end)
  end
end
