defmodule KataEvolve.Suite do
  @moduledoc "Small suite adapter: no registration or setup-specific rules."
  alias KataEvolve.{Evidence, Skill}
  @common ~w(answer_capture allowed_changes)
  def common_checks, do: @common

  @callback spec() :: map()
  @callback prepare(String.t(), map()) :: term()
  @callback prompt(map()) :: String.t()
  @callback check(map(), map()) :: %{String.t() => boolean() | {:review, String.t()}}
  @callback validate(String.t()) :: :ok | {:error, String.t()}
  @callback proposal_instructions() :: String.t()
  @callback outcome_contract() :: [String.t()]
  @optional_callbacks validate: 1, proposal_instructions: 0, outcome_contract: 0

  def outcome_contract(module) do
    requirements =
      if function_exported?(module, :outcome_contract, 0),
        do: module.outcome_contract(),
        else: ["Preserve the source skill's task scope, required behavior, and safeguards."]

    unless is_list(requirements) and requirements != [] and
             Enum.all?(requirements, &(is_binary(&1) and String.trim(&1) != "")),
           do: raise(ArgumentError, "Outcome contract must be a non-empty list of requirements")

    %{requirements: requirements, sha256: Evidence.identity(requirements)}
  end

  def load!(path) do
    path = Path.expand(path)
    loaded = Code.require_file(path)

    modules =
      if loaded do
        Enum.map(loaded, &elem(&1, 0))
      else
        for {module, _} <- :code.all_loaded(),
            function_exported?(module, :module_info, 1),
            to_string(module.module_info(:compile)[:source] || "") == path,
            do: module
      end

    case Enum.filter(modules, &function_exported?(&1, :spec, 0)) do
      [module] ->
        validate_spec!(module)
        module

      _ ->
        raise ArgumentError, "Suite file must define exactly one module with spec/0"
    end
  end

  def validate_spec!(module) do
    for {name, arity} <- [spec: 0, prepare: 2, prompt: 1, check: 2] do
      unless function_exported?(module, name, arity),
        do: raise(ArgumentError, "Suite requires #{name}/#{arity}")
    end

    spec = module.spec()

    unless is_binary(spec.id) and Regex.match?(~r/\A[a-z0-9]+(?:-[a-z0-9]+)*\z/, spec.id),
      do: raise(ArgumentError, "Suite id must be a skill name")

    unless File.regular?(spec.source) and is_list(spec.inputs) and is_list(spec.support) and
             is_list(spec.cases) and spec.cases != [],
           do: raise(ArgumentError, "Suite requires a source file, inputs, support, and cases")

    ids = Enum.map(spec.cases, & &1.id)

    unless length(ids) == length(Enum.uniq(ids)) and
             Enum.sort(Map.keys(spec.checks)) == Enum.sort(ids),
           do: raise(ArgumentError, "Use unique case ids and a check list for every case")

    for item <- spec.cases do
      names = Map.fetch!(spec.checks, item.id)

      unless is_binary(item.id) and Regex.match?(~r/\A[a-zA-Z0-9_-]+\z/, item.id) and
               item.split in [:train, :final] and is_list(item.writable) and
               is_list(names) and names != [] and Enum.all?(names, &is_binary/1) and
               length(Enum.uniq(names ++ @common)) == length(names ++ @common),
             do: raise(ArgumentError, "Invalid case or duplicate/reserved outcome checks")

      Enum.each(item.writable, &validate_path!/1)
    end

    Enum.each(spec.support, &validate_path!/1)
    :ok
  end

  defp validate_path!(path) do
    unless is_binary(path) and Path.type(path) == :relative and
             not Enum.any?(Path.split(path), &(&1 in [".", "..", ".git", ".agents"])) and
             path != "",
           do: raise(ArgumentError, "Use project-relative paths outside Git and skill files")
  end

  def validate(module, text) do
    with :ok <- Skill.validate(text, module.spec().id) do
      if function_exported?(module, :validate, 1), do: module.validate(text), else: :ok
    end
  end

  def stamp(text, profile \\ KataEvolve.Profile.fetch!(KataEvolve.Profile.default())),
    do: Skill.mark_optimized(text, profile)

  def checks(module),
    do: Map.new(module.spec().checks, fn {id, names} -> {id, names ++ @common} end)

  def recheck(module, record) do
    item = Enum.find(module.spec().cases, &(&1.id == record["case_id"])) || raise "Unknown case"
    expected = Map.fetch!(checks(module), item.id)

    common = %{
      "answer_capture" =>
        record["answer_complete"] == true and String.trim(record["answer"] || "") != "",
      "allowed_changes" => Evidence.preserved?(record["initial"], record["final"], item.writable)
    }

    try do
      actual = Map.merge(module.check(record, item), common)

      unless Enum.sort(Map.keys(actual)) == Enum.sort(expected), do: raise("Wrong check set")

      for {name, value} <- actual do
        unless is_boolean(value) or match?({:review, reason} when is_binary(reason), value),
          do: raise("Invalid outcome for #{name}")
      end

      pending = for {name, {:review, reason}} <- actual, into: %{}, do: {name, reason}
      failed = for {name, false} <- actual, do: name

      status =
        cond do
          record["status"] == "error" -> "execution_error"
          not common["answer_capture"] -> "capture_error"
          failed != [] -> "failed"
          map_size(pending) > 0 -> "review"
          true -> "passed"
        end

      failure =
        try do
          for name <- expected,
              do: ExUnit.Assertions.assert(actual[name] == true, "Outcome not passed: #{name}")

          nil
        rescue
          error in ExUnit.AssertionError -> Exception.message(error)
        end

      actual = Map.new(actual, fn {k, v} -> {k, if(is_tuple(v), do: "review", else: v)} end)
      outcome(record, item, actual, status, failure, pending)
    rescue
      error -> outcome(record, item, common, "checker_error", Exception.message(error), %{})
    end
  end

  defp outcome(record, item, checks, status, failure, pending) do
    Map.merge(record, %{
      "checks" => checks,
      "outcome_test" => %{
        "framework" => "ExUnit",
        "case_id" => item.id,
        "status" => status,
        "failure" => failure,
        "review" => pending
      }
    })
  end

  def package!(module, root, text) do
    spec = module.spec()
    base = Path.join(root, ".agents/skills/#{spec.id}")
    File.mkdir_p!(base)
    File.write!(Path.join(base, "SKILL.md"), text)

    for path <- spec.support do
      dest = Path.join(base, path)
      File.mkdir_p!(Path.dirname(dest))
      File.cp_r!(Path.join(Path.dirname(spec.source), path), dest)
    end

    base
  end

  def hash(text), do: Skill.hash(text)
end
