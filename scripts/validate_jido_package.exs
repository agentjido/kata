defmodule Jido.PackageValidator do
  @root Path.expand("..", __DIR__)
  @jido Path.join(@root, "skills/jido")
  @tutor Path.join(@root, "skills/tutor")

  @katas %{
    "understand" => ~w(kata-understand kata-debug kata-sitrep),
    "shape" => ~w(kata-idea kata-roadmap kata-scope kata-plan),
    "lead" => ~w(kata-delegate),
    "work" => ~w(kata-work kata-debug kata-docs kata-routine kata-showme kata-technical-writing),
    "verify" => ~w(kata-verify kata-security),
    "improve" => ~w(kata-maintain-skill kata-write-skill),
    "ship" => ~w(kata-shipit),
    "dojo" => ~w(kata-dojo)
  }

  @plain_verbs %{
    "understand" => "investigate",
    "shape" => "plan",
    "lead" => "delegate",
    "work" => "produce",
    "verify" => "check",
    "improve" => "improve",
    "ship" => "deliver",
    "dojo" => "evaluate"
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
        IO.puts("validated Jido, Tutor, eight internal Katas, and 19 detailed methods")

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
    expected = [Path.join(@jido, "SKILL.md"), Path.join(@tutor, "SKILL.md")]

    errors
    |> require(public == expected, "Jido and Tutor must be the two public skills")
    |> require(
      all_skill_files == expected,
      "internal methods and commands must not use the SKILL.md name"
    )
    |> require(length(methods) == 19, "Jido must retain exactly 19 detailed general methods")
    |> validate_tutor_contract()
  end

  defp validate_tutor_contract(errors) do
    text = read!("skills/tutor/SKILL.md")
    commands = read!("skills/tutor/references/commands.md")
    cases = read!("skills/tutor/references/routing-cases.md")
    curriculum = read!("skills/tutor/references/curriculum.md")
    catalog = read!("skills/tutor/references/catalog.md")
    learning_map = read!("skills/tutor/references/learning/map.md")
    command_names = ~w(how why practice feedback resources)

    topic_ids =
      ~w(define-work direct-agents use-jido verify-work improve-work agentic-engineering)

    errors
    |> require(
      String.contains?(text, "clear learning request") and
        String.contains?(text, "Do not select Tutor for ordinary task execution") and
        String.contains?(cases, "learning intent is clear") and
        String.contains?(cases, "This is ordinary work execution"),
      "Tutor must support clear learning intent without taking over ordinary work"
    )
    |> require(
      String.contains?(text, "read-only authority"),
      "Tutor must keep read-only authority"
    )
    |> require(
      Enum.all?(command_names, &String.contains?(commands, "`#{&1}`")),
      "Tutor command registry is incomplete"
    )
    |> require(
      String.contains?(text, "`$jido` brief") and
        String.contains?(text, "does not invoke Jido"),
      "Tutor must keep the explicit Jido handoff boundary"
    )
    |> require(
      Enum.all?(topic_ids, &String.contains?(curriculum, "`#{&1}`")),
      "Tutor curriculum topic registry is incomplete"
    )
    |> require(
      Enum.all?(topic_ids, fn topic_id ->
        topic_path = Path.join(@tutor, "references/topics/#{topic_id}.md")

        File.regular?(topic_path) and
          String.contains?(File.read!(topic_path), "id: #{topic_id}") and
          String.contains?(File.read!(topic_path), "related:") and
          String.contains?(File.read!(topic_path), "jido-katas:") and
          String.contains?(learning_map, "topics/#{topic_id}.md")
      end),
      "Tutor topic web is incomplete"
    )
    |> require(
      String.contains?(curriculum, "worktutor-topics") and
        String.contains?(curriculum, "Do not scan the file system"),
      "Tutor must keep the local skill source boundary"
    )
    |> require(
      String.contains?(catalog, "worktutor.catalog/v1") and
        String.contains?(catalog, "worktutor.topics/v1"),
      "Tutor catalog contract is incomplete"
    )
    |> require(
      Enum.all?(command_names, fn command ->
        File.regular?(Path.join(@tutor, "references/commands/#{command}.md"))
      end),
      "Tutor command file is missing"
    )
    |> require(
      String.contains?(text, "bare `$tutor`") and String.contains?(cases, "| `$tutor` |"),
      "Tutor must define the bare start"
    )
    |> require(
      not String.contains?(catalog, "localhost"),
      "Tutor catalog must not name a local development source"
    )
  end

  defp validate_jido_contract(errors) do
    text = read!("skills/jido/SKILL.md")
    registry = read!("skills/jido/references/commands.md")
    cases = read!("skills/jido/references/routing-cases.md")
    readme = read!("README.md")
    route_contract = Enum.join([text, registry, cases], "\n")

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
      not File.exists?(Path.join(@jido, "references/loops.md")),
      "Jido must keep one routing source in commands.md"
    )
    |> require(
      not Regex.match?(~r/^\|[^|]*\|\s*(?:deliver|support)\s*\|/m, cases) and
        not Regex.match?(~r/^(?:deliver|support):/m, route_contract),
      "Jido route contracts contain a route label"
    )
    |> require(
      String.contains?(text, "`self-checked`"),
      "Jido must label a verdict that has no separate verifier"
    )
    |> require(
      String.contains?(
        text,
        "worktutor-topics: \"define-work, direct-agents, use-jido, verify-work, improve-work, agentic-engineering\""
      ),
      "Jido must declare its explicit WorkTutor topic mapping"
    )
    |> require(
      String.contains?(text, "requires authority for that action"),
      "Jido must keep the authority boundary inline"
    )
    |> require(
      Enum.all?(Map.keys(@katas), &String.contains?(cases, "`#{&1}`")),
      "routing acceptance cases must cover every internal Kata"
    )
    |> require(
      String.contains?(text, "recommend one explicit `$tutor") and
        String.contains?(text, "Do not invoke Tutor automatically"),
      "Jido must keep the explicit Tutor handoff boundary"
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
          String.contains?(commands, "| `#{kata}` | #{Map.fetch!(@plain_verbs, kata)} |"),
          "registry has no plain verb for #{kata}"
        )
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
