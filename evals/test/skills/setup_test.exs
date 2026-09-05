defmodule KataEvolve.SetupTest do
  use ExUnit.Case

  test "saved setup outcomes can be checked without a model" do
    for path <- Path.wildcard(Path.expand("../../results/setup/**/cases/*.json", __DIR__)) do
      record = KataEvolve.Setup.Store.read(path)
      checked = KataEvolve.Setup.Store.recheck(record)
      # Preserve the original check results while adding new output assertions.
      assert Map.take(checked["checks"], Map.keys(record["checks"])) == record["checks"]

      assert checked["outcome_test"]["status"] == "passed" ==
               Enum.all?(checked["checks"], &elem(&1, 1))
    end
  end

  for path <- Path.wildcard(Path.expand("../fixtures/setup/recorded/*.json", __DIR__)) do
    @tag :recorded
    test "recheck observed fixtures: #{Path.basename(path)}" do
      data = Jason.decode!(File.read!(unquote(path)))

      cases =
        KataEvolve.Setup.Fixture.cases()
        |> then(&(&1.train ++ &1.validation ++ &1.test))
        |> Map.new(&{&1.id, &1})

      for record <- data["records"] do
        initial = %{files: record["initial"]["files"], index: record["initial"]["index"]}
        snapshot = %{files: record["final"]["files"], index: record["final"]["index"]}

        result =
          KataEvolve.Setup.Fixture.check_snapshot(snapshot, cases[record["case_id"]], initial)

        assert Map.take(result.checks, Map.keys(record["checks"])) == record["checks"]
        assert KataEvolve.Setup.Skill.words(record["skill"]) <= 500 == record["word_budget_pass"]
      end
    end
  end
end
