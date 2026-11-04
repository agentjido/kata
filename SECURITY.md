# Security Policy

## Supported versions

Security fixes apply to the latest released version of Agent Jido Kata. Older
skill text can remain cached by installers or directories, so include the
source URL and observed version in a report.

## Report a vulnerability

Do not open a public issue for an undisclosed vulnerability. Email
`mike.hostetler@gmail.com` with:

- the affected skill, script, or workflow;
- the source revision or release;
- the impact and required conditions;
- safe reproduction steps; and
- any suggested mitigation.

Do not include live credentials, personal data, or another person's private
content. The maintainers will confirm receipt, assess the report, and coordinate
disclosure and a fix when the issue is valid.

## Security boundary

Skills are instructions for coding agents. An agent can receive broad access to
files, commands, networks, accounts, and external systems. Review each skill and
the agent's requested actions before use. Agent Jido Kata does not grant an
agent authority beyond the current user request and host controls.
