defmodule KataEvolve.SetupTest do
  use ExUnit.Case

  test "saved setup outcomes can be checked without a model" do
    for path <- Path.wildcard(Path.expand("../../results/setup/**/cases/*.json", __DIR__)) do
      record = KataEvolve.Store.read(path)
      checked = KataEvolve.Store.recheck(record)
      assert checked["checks"] == record["checks"]
    end
  end

  for path <- Path.wildcard(Path.expand("../fixtures/setup/recorded/*.json", __DIR__)) do
    @tag :recorded
    test "recheck observed fixtures: #{Path.basename(path)}" do
      data = Jason.decode!(File.read!(unquote(path)))

      cases =
        KataEvolve.Fixture.cases()
        |> then(&(&1.train ++ &1.validation ++ &1.test))
        |> Map.new(&{&1.id, &1})

      for record <- data["records"] do
        initial = %{files: record["initial"]["files"], index: record["initial"]["index"]}
        snapshot = %{files: record["final"]["files"], index: record["final"]["index"]}
        result = KataEvolve.Fixture.check_snapshot(snapshot, cases[record["case_id"]], initial)
        assert result.checks == record["checks"]
        assert KataEvolve.Skill.words(record["skill"]) <= 500 == record["word_budget_pass"]
      end
    end
  end
end
