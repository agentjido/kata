# Install Kata

Status: Current

Last reviewed: 2026-11-05

## 1. Install the skills

Use a terminal with Node.js and npm available. Open the workspace where you
want to use Kata, then run:

```sh
npx skills add agentjido/kata
```

Select your agent host when prompted. Install `jido` and the Kata skills you
want it to use. This is the main install path.

## Review the trust boundary

Skills are agent instructions and can include scripts or supporting files.
Treat an installed skill pack like installed software:

1. Review the selected `SKILL.md` files and their support files.
2. Use a reviewed release or source revision for team deployment.
3. Confirm the requested file, command, network, and account access before use.
4. Require explicit approval for writes, publication, deletion, purchases, or
   other high-impact actions.
5. Review each private or third-party skill before you install or enable it.
   Kata does not validate skills supplied outside this package.

Kata has no hosted service, MCP server, or required network connection. A host,
model provider, installer, or tool can have its own data and network behavior.
Review those systems separately.

Jido uses the skills that the host exposes for the current session. Install a
private or team skill through the host's normal user or project skill location.
Jido does not keep a separate skill registry or scan the filesystem for skills.

## 2. Start an agent session

Start a new session if your host requires it. Ask the agent to confirm that
`jido` is available. Skill invocation syntax depends on the host.

## 3. Give Jido a goal

Provide the source material and the result you need. For example:

```text
$jido turn these source notes into a decision brief and check its claims
```

You can also use an individual skill. See the
[skill list](../../skills/README.md#skill-list) to choose one.

## Other install options

To select a host in the command:

```sh
npx skills add agentjido/kata --agent codex
```

Use `--agent claude-code` or `--agent cursor` for those hosts.

To install from a local checkout, replace `/path/to/kata` with its path:

```sh
npx skills add /path/to/kata
```

See [host compatibility](../reference/host-compatibility.md) for alternative
host instructions, package structure, and known verification limits. Included
plugin manifests do not establish tested runtime support for each host.
