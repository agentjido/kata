defmodule Jido.PackageValidator do
  @root Path.expand("..", __DIR__)
  @jido Path.join(@root, "skills/jido")

  @katas %{
    "understand" => ~w(kata-understand kata-debug kata-sitrep),
    "shape" => ~w(kata-idea kata-roadmap kata-scope kata-plan),
    "lead" => ~w(kata-tutor kata-delegate),
    "work" => ~w(kata-work kata-debug kata-docs kata-routine kata-showme kata-technical-writing),
    "verify" => ~w(kata-verify kata-security),
    "improve" => ~w(kata-maintain-skill kata-write-skill),
    "ship" => ~w(kata-shipit),
    "dojo" => ~w(kata-dojo)
  }

  @removed_elixir ~w(kata-build-jido kata-ex-design-review kata-ex-quality)

  def run do
    errors =
      []
      |> validate_public_surface()
      |> validate_jido_contract()
      |> validate_katas()
      |> validate_removed_elixir()

    case errors do
      [] ->
        IO.puts("validated one Jido skill, eight internal Katas, and 20 detailed methods")

      errors ->
        errors
        |> Enum.reverse()
        |> Enum.each(&IO.puts(:stderr, "ERROR: #{&1}"))

        System.halt(1)
    end
  end

  defp validate_public_surface(errors) do
    public = @root |> Path.join("skills/*/SKILL.md") |> Path.wildcard() |> Enum.sort()
    all_skill_files = @root |> Path.join("skills/**/SKILL.md") |> Path.wildcard() |> Enum.sort()
    methods = @jido |> Path.join("references/methods/*/method.md") |> Path.wildcard()
    expected = [Path.join(@jido, "SKILL.md")]

    errors
    |> require(public == expected, "skills/jido/SKILL.md must be the only public skill")
    |> require(all_skill_files == expected, "internal methods must not use the SKILL.md name")
    |> require(length(methods) == 20, "Jido must retain exactly 20 detailed general methods")
  end

  defp validate_jido_contract(errors) do
    text = read!("skills/jido/SKILL.md")
    loops = read!("skills/jido/references/loops.md")
    cases = read!("skills/jido/references/routing-cases.md")
    readme = read!("README.md")
    route_contract = Enum.join([text, loops, cases], "\n")

    errors
    |> require(
      String.contains?(text, "standing user or workspace instruction"),
      "Jido must support a standing selection preference"
    )
    |> require(
      String.contains?(text, "Do not add a separate statement"),
      "Jido must suppress a separate startup announcement"
    )
    |> require(
      String.contains?(text, "Do not repeat") and
        String.contains?(text, "in the final answer"),
      "Jido must not repeat an unchanged route"
    )
    |> require(
      String.contains?(readme, "~/.codex/AGENTS.md") and
        String.contains?(readme, "Prefer $jido for substantial or ambiguous work"),
      "README must offer the optional global Codex preference"
    )
    |> require(
      not Regex.match?(
        ~r/^(?:Route:\s*(?:deliver-value|learn-leadership|improve-method)|.*->\s*accept(?:ance)?\s*$|Procedure:)/m,
        route_contract
      ),
      "Jido route contracts contain an older output term"
    )
    |> require(String.contains?(text, "Dojo is isolated"), "Jido must keep the Dojo gate inline")
    |> require(
      String.contains?(text, "requires authority for that action"),
      "Jido must keep the authority boundary inline"
    )
    |> require(
      Enum.all?(Map.keys(@katas), &String.contains?(cases, "`#{&1}`")),
      "routing acceptance cases must cover every internal Kata"
    )
    |> require(
      cases |> String.split("\n") |> Enum.count(&String.starts_with?(&1, "|")) >= 16,
      "routing acceptance cases are incomplete"
    )
  end

  defp validate_katas(errors) do
    commands = read!("skills/jido/references/commands.md")

    Enum.reduce(@katas, errors, fn {kata, methods}, acc ->
      relative = "skills/jido/references/katas/#{kata}.md"
      text = read!(relative)

      acc =
        acc
        |> require(String.contains?(commands, "`#{kata}`"), "registry is missing #{kata}")
        |> require(
          String.contains?(commands, "references/katas/#{kata}.md"),
          "registry path is missing #{kata}"
        )
        |> require(String.contains?(text, "**Result:**"), "#{kata} has no result contract")
        |> require(String.contains?(text, "**Done:**"), "#{kata} has no done contract")

      Enum.reduce(methods, acc, fn method, method_acc ->
        method_path = Path.join(@jido, "references/methods/#{method}/method.md")

        method_acc
        |> require(File.regular?(method_path), "#{kata} method is missing: #{method}")
        |> require(
          String.contains?(text, "methods/#{method}/method.md"),
          "#{kata} does not route to #{method}"
        )
      end)
    end)
  end

  defp validate_removed_elixir(errors) do
    errors =
      Enum.reduce(@removed_elixir, errors, fn name, acc ->
        require(
          acc,
          not File.exists?(Path.join(@root, "skills/#{name}")),
          "Elixir package remains: #{name}"
        )
      end)

    require(
      errors,
      not File.exists?(
        Path.join(
          @jido,
          "references/methods/kata-technical-writing/references/elixir-library-docs.md"
        )
      ),
      "Elixir documentation method remains in Jido"
    )
  end

  defp read!(relative), do: File.read!(Path.join(@root, relative))

  defp require(errors, true, _message), do: errors
  defp require(errors, false, message), do: [message | errors]
end

Jido.PackageValidator.run()
