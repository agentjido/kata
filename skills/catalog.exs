Mix.install([
  {:phoenix_playground, "~> 0.1.8"},
  {:yaml_elixir, "~> 2.12"}
])

defmodule Kata.Catalog do
  @required_metadata ~w(schema subject practice object profile authority consumes produces)

  def load!(root \\ Path.expand("..", __DIR__)) do
    skills =
      root
      |> Path.join("skills/*/SKILL.md")
      |> Path.wildcard()
      |> Enum.map(&load_skill!(&1, root))
      |> Enum.sort_by(& &1.name)

    validate!(skills)
    skills
  end

  def filter(skills, query, subject, authority) do
    query = query |> String.trim() |> String.downcase()

    Enum.filter(skills, fn skill ->
      matches_query?(skill, query) and
        (subject == "all" or skill.subject == subject) and
        (authority == "all" or skill.authority == authority)
    end)
  end

  def stats(skills) do
    %{
      packages: length(skills),
      subjects: skills |> Enum.map(& &1.subject) |> Enum.uniq() |> length(),
      writable: Enum.count(skills, &(&1.authority == "local-write")),
      elixir: Enum.count(skills, &(&1.language == "elixir"))
    }
  end

  def validate!(skills) do
    duplicate_names =
      skills
      |> Enum.frequencies_by(& &1.name)
      |> Enum.filter(fn {_name, count} -> count > 1 end)
      |> Enum.map_join(", ", &elem(&1, 0))

    if skills == [], do: raise("catalog found no skill packages")
    if duplicate_names != "", do: raise("duplicate skill names: #{duplicate_names}")

    Enum.each(skills, fn skill ->
      if skill.name != skill.directory do
        raise "#{skill.path}: name #{inspect(skill.name)} does not match directory #{inspect(skill.directory)}"
      end

      if skill.schema != "kata.skill/v1" do
        raise "#{skill.path}: expected metadata.schema kata.skill/v1"
      end
    end)

    :ok
  end

  defp load_skill!(path, root) do
    frontmatter =
      path
      |> File.read!()
      |> frontmatter!(path)
      |> YamlElixir.read_from_string!()

    metadata = Map.fetch!(frontmatter, "metadata")

    missing = Enum.reject(@required_metadata, &Map.has_key?(metadata, &1))

    if missing != [] do
      raise "#{Path.relative_to(path, root)}: missing metadata #{Enum.join(missing, ", ")}"
    end

    directory = path |> Path.dirname() |> Path.basename()

    %{
      name: Map.fetch!(frontmatter, "name"),
      description: Map.fetch!(frontmatter, "description"),
      directory: directory,
      path: Path.relative_to(path, root),
      support_files: support_file_count(path),
      schema: Map.fetch!(metadata, "schema"),
      subject: Map.fetch!(metadata, "subject"),
      practice: Map.fetch!(metadata, "practice"),
      object: Map.fetch!(metadata, "object"),
      profile: Map.fetch!(metadata, "profile"),
      authority: Map.fetch!(metadata, "authority"),
      language: Map.get(metadata, "language"),
      consumes: facet_list!(metadata, "consumes", path),
      produces: facet_list!(metadata, "produces", path)
    }
  end

  defp facet_list!(metadata, key, path) do
    value = Map.fetch!(metadata, key)

    unless is_binary(value) do
      raise "#{path}: metadata.#{key} must be a comma-separated string"
    end

    values = value |> String.split(",") |> Enum.map(&String.trim/1)

    if values == [] or Enum.any?(values, &(&1 == "")) do
      raise "#{path}: metadata.#{key} must contain non-empty identifiers"
    end

    values
  end

  defp frontmatter!("---\n" <> rest, path) do
    case String.split(rest, "\n---\n", parts: 2) do
      [frontmatter, _body] -> frontmatter
      _ -> raise "#{path}: invalid frontmatter boundary"
    end
  end

  defp frontmatter!(_contents, path), do: raise("#{path}: missing frontmatter")

  defp support_file_count(skill_path) do
    skill_path
    |> Path.dirname()
    |> Path.join("**/*")
    |> Path.wildcard(match_dot: true)
    |> Enum.count(&(File.regular?(&1) and &1 != skill_path))
  end

  defp matches_query?(_skill, ""), do: true

  defp matches_query?(skill, query) do
    [
      skill.name,
      skill.description,
      skill.subject,
      skill.practice,
      skill.object,
      skill.profile,
      skill.authority,
      skill.language,
      skill.consumes,
      skill.produces
    ]
    |> List.flatten()
    |> Enum.reject(&is_nil/1)
    |> Enum.join(" ")
    |> String.downcase()
    |> String.contains?(query)
  end
end

defmodule Kata.CatalogLive do
  use Phoenix.LiveView

  alias Kata.Catalog

  def mount(_params, _session, socket) do
    {:ok, load(socket, %{query: "", subject: "all", authority: "all"})}
  end

  def handle_event("filter", params, socket) do
    filters = %{
      query: Map.get(params, "query", ""),
      subject: Map.get(params, "subject", "all"),
      authority: Map.get(params, "authority", "all")
    }

    {:noreply, assign_visible(socket, filters)}
  end

  def handle_event("reload", _params, socket) do
    filters = Map.take(socket.assigns, [:query, :subject, :authority])
    {:noreply, load(socket, filters)}
  end

  def render(assigns) do
    ~H"""
    <style>
      :root {
        color-scheme: dark;
        --paper: #101116;
        --panel: #191b22;
        --line: #30333d;
        --ink: #f4f0e8;
        --muted: #aaa9a4;
        --orange: #ff784f;
        --gold: #f4c95d;
        --mint: #5bd6b2;
        --blue: #6ea8fe;
      }

      * { box-sizing: border-box; }
      body {
        margin: 0;
        color: var(--ink);
        background: radial-gradient(circle at 80% 0, #1d2536 0, var(--paper) 34rem);
        font-family: Inter, ui-sans-serif, system-ui, sans-serif;
      }

      main { width: min(1120px, calc(100% - 32px)); margin: auto; padding: 64px 0; }
      h1 { margin: 0; font: 400 clamp(48px, 8vw, 86px)/.95 Georgia, serif; letter-spacing: -.05em; }
      .intro { max-width: 650px; margin: 22px 0 36px; color: #c7c5bf; font-size: 18px; }
      .eyebrow { color: var(--orange); font: 700 12px/1 monospace; letter-spacing: .14em; text-transform: uppercase; }
      .stats { display: grid; grid-template-columns: repeat(4, 1fr); margin: 42px 0; border-block: 1px solid var(--line); }
      .stat { padding: 24px 18px; border-right: 1px solid var(--line); }
      .stat:last-child { border: 0; }
      .stat strong { display: block; font: 36px/1 Georgia, serif; }
      .stat span { color: var(--muted); font-size: 13px; }
      form { display: grid; grid-template-columns: 2fr 1fr 1fr auto; gap: 10px; margin-bottom: 18px; }
      input, select, button {
        min-height: 44px;
        padding: 0 13px;
        border: 1px solid var(--line);
        border-radius: 10px;
        color: var(--ink);
        background: var(--panel);
        font: inherit;
      }
      button { border-color: var(--orange); cursor: pointer; }
      .result { margin: 0 0 18px; color: var(--muted); font: 12px/1 monospace; }
      .grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 14px; }
      article { display: flex; min-height: 260px; flex-direction: column; padding: 20px; border: 1px solid var(--line); border-radius: 16px; background: var(--panel); }
      article h2 { margin: 12px 0; font: 400 24px/1.05 Georgia, serif; overflow-wrap: anywhere; }
      article p { margin: 0 0 20px; color: #c4c2bc; font-size: 13px; }
      .meta, .types { display: flex; flex-wrap: wrap; gap: 6px; }
      .meta { margin-bottom: 18px; }
      .badge { padding: 5px 7px; border: 1px solid var(--line); border-radius: 6px; color: var(--muted); font: 10px/1 monospace; }
      .subject { color: var(--orange); }
      .authority { color: var(--mint); }
      details { margin-top: auto; color: var(--muted); font-size: 12px; }
      summary { cursor: pointer; color: var(--gold); }
      .types { margin-top: 10px; }
      .path { margin-top: 16px; color: var(--blue); font: 11px/1.4 monospace; overflow-wrap: anywhere; }
      .empty { grid-column: 1 / -1; padding: 50px; color: var(--muted); text-align: center; }

      @media (max-width: 820px) {
        form { grid-template-columns: 1fr 1fr; }
        .grid { grid-template-columns: repeat(2, 1fr); }
      }

      @media (max-width: 560px) {
        main { padding-top: 42px; }
        .stats, .grid, form { grid-template-columns: 1fr; }
        .stat { border-right: 0; border-bottom: 1px solid var(--line); }
      }
    </style>

    <main>
      <p class="eyebrow">Live repository view</p>
      <h1>Kata skill catalog</h1>
      <p class="intro">
        This page reads the canonical frontmatter from every active skill package.
        Reload after a file change to see the current library.
      </p>

      <section class="stats" aria-label="Catalog totals">
        <div class="stat"><strong>{@stats.packages}</strong><span>packages</span></div>
        <div class="stat"><strong>{@stats.subjects}</strong><span>subjects</span></div>
        <div class="stat"><strong>{@stats.writable}</strong><span>local-write</span></div>
        <div class="stat"><strong>{@stats.elixir}</strong><span>Elixir</span></div>
      </section>

      <form phx-change="filter">
        <input
          type="search"
          name="query"
          value={@query}
          placeholder="Search names, jobs, facets, inputs, or outputs"
          phx-debounce="150"
        />
        <select name="subject" aria-label="Subject">
          <option value="all" selected={@subject == "all"}>All subjects</option>
          <option :for={subject <- @subjects} value={subject} selected={@subject == subject}>
            {subject}
          </option>
        </select>
        <select name="authority" aria-label="Authority">
          <option value="all" selected={@authority == "all"}>All authority</option>
          <option :for={authority <- @authorities} value={authority} selected={@authority == authority}>
            {authority}
          </option>
        </select>
        <button type="button" phx-click="reload">Reload source</button>
      </form>

      <p class="result">{length(@visible)} of {length(@skills)} skills</p>

      <section class="grid" aria-label="Skill packages">
        <article :for={skill <- @visible}>
          <div class="meta">
            <span class="badge subject">{skill.subject}</span>
            <span class="badge">{skill.practice}</span>
            <span class="badge authority">{skill.authority}</span>
          </div>
          <h2>{skill.name}</h2>
          <p>{skill.description}</p>
          <details>
            <summary>Contract and files</summary>
            <div class="types">
              <span class="badge">object: {skill.object}</span>
              <span class="badge">profile: {skill.profile}</span>
              <span :if={skill.language} class="badge">language: {skill.language}</span>
              <span class="badge">support: {skill.support_files}</span>
              <span :for={input <- skill.consumes} class="badge">in: {input}</span>
              <span :for={output <- skill.produces} class="badge">out: {output}</span>
            </div>
          </details>
          <code class="path">{skill.path}</code>
        </article>

        <p :if={@visible == []} class="empty">No skill matches these filters.</p>
      </section>
    </main>
    """
  end

  defp load(socket, filters) do
    skills = Catalog.load!()

    socket
    |> assign(:skills, skills)
    |> assign(:stats, Catalog.stats(skills))
    |> assign(:subjects, values(skills, :subject))
    |> assign(:authorities, values(skills, :authority))
    |> assign_visible(filters)
  end

  defp assign_visible(socket, filters) do
    visible =
      Catalog.filter(socket.assigns.skills, filters.query, filters.subject, filters.authority)

    socket
    |> assign(filters)
    |> assign(:visible, visible)
  end

  defp values(skills, field) do
    skills |> Enum.map(&Map.fetch!(&1, field)) |> Enum.uniq() |> Enum.sort()
  end
end

case System.argv() do
  ["--check"] ->
    skills = Kata.Catalog.load!()
    IO.puts("catalog check passed: #{length(skills)} skill packages")

  [] ->
    port = System.get_env("KATA_CATALOG_PORT", "4000") |> String.to_integer()
    open_browser = System.get_env("KATA_CATALOG_OPEN_BROWSER", "true") not in ["0", "false"]
    PhoenixPlayground.start(live: Kata.CatalogLive, port: port, open_browser: open_browser)

  _args ->
    IO.puts(:stderr, "usage: iex skills/catalog.exs | elixir skills/catalog.exs --check")
    System.halt(2)
end
