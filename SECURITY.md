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

Skills are instructions for agents. An agent can receive broad access to
files, commands, networks, accounts, and external systems. Review each skill and
the agent's requested actions before use. Agent Jido Kata does not grant an
agent authority beyond the current user request and host controls.

Treat a skill and every bundled reference, script, validator, asset, and fetched
source as part of the trust boundary. Review the exact release or source
revision before team deployment. Do not assume that a public repository,
installer listing, or compatible manifest makes a skill safe.

Kata has no hosted service or required telemetry. The selected agent host,
model provider, installer, external tool, and optional skill can have separate
data, network, and retention behavior. Review their policies and permissions.
