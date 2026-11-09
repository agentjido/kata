# Jido repository routines

These files define repeatable local work for this repository. Jido reads them
through its internal `kata-routine` method. They are project configuration, not
public Agent Skills.

## Available routines

- [Jido package](jido-package.md): check the single-command package and its
  internal registry.
- [Documentation](documentation.md): check the current documentation index,
  intake state, and supported claims.
- [Release gates](release-gates.md): run the local CI gates outside the Jido
  package-specific check.
- [Repository health](repository-health.md): run the three routines above as
  one ordered group.

Use `$jido routine` to inspect routine state. Use `$jido run <name> routine` for
one routine or `$jido run all routines` for every active routine. Jido validates
references and runs each routine at most once.

A routine's authority is a ceiling. The active request must still grant each
local or external effect. No task system, scheduler, notification service, or
result log is configured by this directory. Without an authorized extension,
Jido returns findings in the current conversation.
