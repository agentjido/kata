defmodule KataEvolve.GenericLoopTest do
  use ExUnit.Case
  import ExUnit.CaptureIO
  alias KataEvolve.{Evidence, Experiment, Profile, Skill, Suite}

  test "different suites load repeatedly without a registry or setup validation" do
    for {name, id} <- [{"setup", "kata-setup"}, {"neckbeard", "kata-neckbeard"}] do
      path = Path.join(KataEvolve.root(), "suites/#{name}.exs")
      module = Suite.load!(path)
      assert module == Suite.load!(path)
      assert module.spec().id == id
      assert Suite.validate(module, File.read!(module.spec().source)) == :ok
    end

    assert Skill.validate(
             "---\ndescription: Summarize a Rust project.\nname: rust-summary\n---\nRead src.\n",
             "rust-summary"
           ) == :ok

    refute Skill.validate("---\nname: another-skill\ndescription: Read.\n---\n", "rust-summary") ==
             :ok
  end

  test "both read-only answers and created files use the same runner and outcome gates" do
    for name <- ["neckbeard", "setup"] do
      module = Suite.load!(Path.join(KataEvolve.root(), "suites/#{name}.exs"))
      ctx = context(module, successful_executor(module))

      capture_io(fn ->
        records = Experiment.batch(ctx, ctx.source, "source-full", :all, 3)
        assert length(records) == length(module.spec().cases) * 3
        assert Enum.all?(records, &(get_in(&1, ["outcome_test", "status"]) == "passed"))
        assert length(Enum.uniq_by(records, & &1["execution_id"])) == length(records)

        no_call = %{
          ctx
          | execute: fn _, _, _, _, _ -> flunk("Saved records must prevent calls") end
        }

        assert Experiment.batch(no_call, ctx.source, "source-full", :all, 3) == records

        [record | _] = records
        assert record["answer_complete"]
        refute Map.has_key?(record, "workspace")

        if name == "setup" do
          assert Evidence.text(record["final"], "docs/AGENTS.md") != ""
          broken = update_in(record, ["final", "files"], &Map.delete(&1, "docs/AGENTS.md"))
          assert Suite.recheck(module, broken)["outcome_test"]["status"] == "failed"
        else
          assert record["initial"] == record["final"]
          broken = Map.put(record, "answer", "Three retries. All tests passed.")
          assert Suite.recheck(module, broken)["outcome_test"]["status"] == "failed"
        end
      end)
    end
  end

  test "generic tuning selects lower measured cost, keeps ties, and verifies saved text" do
    module = Suite.load!(Path.join(KataEvolve.root(), "suites/neckbeard.exs"))
    original = File.read!(module.spec().source)
    # The cheaper candidate is deliberately longer: word count is not the objective.
    candidate = Suite.stamp(original <> "\nKeep the answer concise.\n")
    baseline_execute = successful_executor(module)
    owner = self()
    rounds = start_supervised!({Agent, fn -> 0 end})

    execute = fn profile, prompt, project, runtime, writable ->
      if File.exists?(Path.join(project, "feedback.json")) do
        feedback = File.read!(Path.join(project, "feedback.json"))
        refute feedback =~ "final-cache"
        refute feedback =~ "final-export"
        round = Agent.get_and_update(rounds, &{&1 + 1, &1 + 1})
        proposed = if round == 1, do: candidate, else: candidate <> "Read carefully.\n"
        File.write!(Path.join(project, "SKILL.md"), proposed)
        send(owner, :proposal)
        {:ok, output("Updated candidate.", 10)}
      else
        {:ok, result} = baseline_execute.(profile, prompt, project, runtime, writable)
        text = File.read!(Path.join(project, ".agents/skills/#{module.spec().id}/SKILL.md"))
        send(owner, :execution)
        {:ok, Map.put(result, :metrics, metrics(if(text == original, do: 100, else: 50)))}
      end
    end

    ctx = context(module, execute)

    capture_io(fn ->
      Experiment.batch(ctx, original, "source-train", :train, 1)
      selected = Experiment.tune(ctx, 2)
      assert selected.improved
      assert File.read!(selected.candidate_path) == candidate
      assert Skill.words(candidate) > Skill.words(original)
      assert selected.training_score_units > 50_000_000

      score = Experiment.verify(ctx, candidate, batch: "candidate-full")
      assert score.eligible and score.score > 50

      no_call = %{ctx | execute: fn _, _, _, _, _ -> flunk("Resume must not call the model") end}
      assert Experiment.verify(no_call, candidate, batch: "candidate-full") == score

      assert_raise RuntimeError, ~r/Verification has started/, fn ->
        Experiment.tune(no_call, 2)
      end
    end)

    assert_received :proposal
    assert_received :proposal
    refute_received :proposal
    for _ <- 1..21, do: assert_received(:execution)
    refute_received :execution
  end

  test "offline check reads the frozen context and never launches Codex" do
    path = Path.join(KataEvolve.root(), "suites/neckbeard.exs")
    module = Suite.load!(path)
    ctx = context(module, successful_executor(module))
    spec = module.spec()
    id = Evidence.identity(%{offline_test: ctx.dir})
    dir = ctx.dir
    context_path = Path.join(dir, "contexts/#{id}.json")
    source_hash = Skill.hash(ctx.source)

    identity = %{
      suite: spec.id,
      source: source_hash,
      profile_name: Profile.default(),
      inputs: Evidence.fingerprint(Enum.uniq([path | spec.inputs])),
      checks: Suite.checks(module)
    }

    Evidence.write_new!(context_path, identity)
    offline = %{ctx | id: id, dir: dir}

    capture_io(fn ->
      Experiment.batch(offline, ctx.source, "source-full", :all, 3)
      previous = System.get_env("KATA_CODEX_PATH")
      System.put_env("KATA_CODEX_PATH", "/no-such-codex")

      try do
        checks = KataEvolve.run(path, "check", context: id, results: dir)
        assert length(checks) == 9
        assert Enum.all?(checks, &(&1.outcome["status"] == "passed"))
        score = KataEvolve.run(path, "score", context: id, batch: "source-full", results: dir)
        score_path = Path.join(dir, "scores/#{Evidence.identity(score)}.json")
        on_exit(fn -> File.rm(score_path) end)
        assert score.score == 50.0
      after
        if previous,
          do: System.put_env("KATA_CODEX_PATH", previous),
          else: System.delete_env("KATA_CODEX_PATH")
      end
    end)
  end

  test "metadata stamping preserves block metadata and uses the selected profile" do
    text =
      "---\nname: sample\ndescription: Read.\nmetadata:\n  language: elixir\n  optimized_for: old\n---\nBody.\n"

    profile = Profile.fetch!("codex-sol-medium")
    stamped = Suite.stamp(text, profile)
    assert stamped =~ "  language: elixir"
    assert stamped =~ ~s(optimized_for: "codex/gpt-5.6-sol/medium")
    assert Suite.stamp(stamped, profile) == stamped
    assert String.ends_with?(stamped, "---\nBody.\n")
    windows = String.replace(text, "\n", "\r\n")
    assert Suite.stamp(windows, profile) == String.replace(stamped, "\n", "\r\n")
  end

  test "a failed source outcome is retained and cannot be retried inside the batch" do
    module = Suite.load!(Path.join(KataEvolve.root(), "suites/neckbeard.exs"))
    owner = self()

    ctx =
      context(module, fn _, _, _, _, _ ->
        send(owner, :failed_execution)
        {:ok, output("I changed the code. The tests passed.", 100)}
      end)

    capture_io(fn ->
      assert_raise RuntimeError, ~r/Source outcome failed/, fn ->
        Experiment.batch(ctx, ctx.source, "source-full", :all, 3)
      end

      path = Path.join(ctx.dir, "batches/test/source-full/cases/train-retry-1.json")
      original = File.read!(path)
      assert Evidence.read(path)["outcome_test"]["status"] == "failed"

      assert_raise RuntimeError, ~r/saved immutable evidence/, fn ->
        Experiment.batch(ctx, ctx.source, "source-full", :all, 3)
      end

      assert File.read!(path) == original
    end)

    assert_received :failed_execution
    refute_received :failed_execution
  end

  defp context(module, execute) do
    dir = Path.join(System.tmp_dir!(), "generic-loop-#{System.unique_integer([:positive])}")
    on_exit(fn -> File.rm_rf!(dir) end)

    %{
      module: module,
      dir: dir,
      id: "test",
      source: File.read!(module.spec().source),
      profile: Profile.fetch!(Profile.default()),
      execute: execute
    }
  end

  defp successful_executor(module) do
    fn _, prompt, project, _, _ ->
      item = Enum.find(module.spec().cases, &String.contains?(prompt, module.prompt(&1)))

      answer =
        if module.spec().id == "kata-setup" do
          initial = Evidence.take(project)

          for path <- [item.source, item.asset] do
            KataEvolve.Setup.Fixture.write(
              project,
              "docs/inbox/" <> path,
              Evidence.text(initial, path)
            )

            File.rm!(Path.join(project, path))
          end

          for {path, text} <- [
                {"docs/AGENTS.md",
                 Evidence.text(initial, ".agents/skills/kata-setup/templates/docs-agents.md")},
                {"docs/README.md", "[Rules](AGENTS.md)\n[Inbox](inbox/README.md)"},
                {"README.md", "[Note](docs/inbox/#{item.source})\n[Docs](docs/README.md)"},
                {"docs/inbox/README.md",
                 "#{item.source} | docs/inbox/#{item.source} | Awaiting review"}
              ],
              do: KataEvolve.Setup.Fixture.write(project, path, text)

          "Docs setup is complete."
        else
          File.read!(
            Path.join(
              KataEvolve.root(),
              "test/fixtures/kata-neckbeard/calibration/#{item.id}-good.md"
            )
          )
        end

      {:ok, output(answer, 100)}
    end
  end

  defp output(answer, tokens),
    do: %{answer: answer, answer_complete: true, metrics: metrics(tokens)}

  defp metrics(tokens),
    do: %{
      usage: %{input_tokens: tokens, output_tokens: 0, total_tokens: tokens},
      tool_calls: 1,
      elapsed_ms: 10
    }
end
