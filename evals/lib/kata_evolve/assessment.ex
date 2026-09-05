defmodule KataEvolve.Assessment do
  @moduledoc "Versioned checks of immutable execution evidence. No model calls."
  alias KataEvolve.{Evidence, Score, Suite}

  def identity(module, suite_path) do
    inputs =
      [suite_path | module.spec().inputs] ++
        Enum.map(~w(suite.ex assessment.ex score.ex), &Path.join(__DIR__, &1))

    Evidence.identity(%{
      suite: module.spec().id,
      checks: Suite.checks(module),
      inputs: Evidence.portable_fingerprint(inputs, Path.dirname(KataEvolve.root())),
      score: Score.version()
    })
  end

  def read!(ctx, path) do
    record = Evidence.read(path)
    checked = Suite.recheck(ctx.module, record)
    revision = Map.get(ctx, :assessment, "test")
    raw_hash = Evidence.hash(File.read!(path))

    assessment = %{
      "revision" => revision,
      "record_sha256" => raw_hash,
      "execution_id" => record["execution_id"],
      "context" => record["context"],
      "checks" => checked["checks"],
      "outcome_test" => checked["outcome_test"]
    }

    dest = Path.join(ctx.dir, "assessments/#{revision}/#{raw_hash}.json")

    if File.exists?(dest) do
      unless Evidence.read(dest) == assessment,
        do: raise("Checker returned a different result for the same saved input and revision")
    else
      Evidence.write_new!(dest, assessment)
    end

    checked
    |> Map.put("assessment", revision)
    |> Map.put("record_sha256", raw_hash)
  end
end
