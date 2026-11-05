defmodule Kata.ConventionalCommit do
  @pattern ~r/^(build|chore|ci|docs|feat|fix|perf|refactor|revert|style|test)(\([A-Za-z0-9_.-]+\))?(!)?: .+$/

  def run([subject]) do
    if Regex.match?(@pattern, subject) do
      IO.puts("Validated conventional commit subject: #{subject}")
    else
      IO.puts(:stderr, "ERROR: commit subject does not use Conventional Commits")
      IO.puts(:stderr, "Expected an example such as: feat(skills): add a focused workflow")
      System.halt(1)
    end
  end

  def run(_args) do
    IO.puts(:stderr, "ERROR: usage: elixir scripts/validate_conventional_commit.exs SUBJECT")
    System.halt(1)
  end
end

Kata.ConventionalCommit.run(System.argv())
