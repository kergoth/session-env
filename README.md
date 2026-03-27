# session-env

[![CI](https://github.com/kergoth/session-env/actions/workflows/test.yml/badge.svg)](https://github.com/kergoth/session-env/actions/workflows/test.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Contributor Covenant](https://img.shields.io/badge/Contributor%20Covenant-2.1-4baaaa.svg)](CODE_OF_CONDUCT.md)

Inject environment variables — PATH, credentials, and other session state — into
desktop environments (macOS launchd, KDE Plasma D-Bus) so GUI apps see the same
environment as your terminal.

## The problem

CLI sessions inherit `PATH` and credentials from shell configuration, but GUI
apps launched from the Dock or KDE panel get a minimal environment from
`launchd` or `systemd`. Tools like Claude Code Desktop, VS Code, and other
desktop apps can't find `gh`, `git`, or credential env vars unless you manually
configure `launchctl setenv` or `dbus-update-activation-environment` for each
variable.

## How it works

1. You write `~/.session-env` — a shell file that exports variables.
2. `session-env sync` sources it in a clean subprocess, discovers every
   exported variable, and injects them into your desktop session.
3. `session-env install` sets up auto-start so this happens at every login.

No framework required. No config language. Just `export` statements and POSIX
shell.

## Quickstart

```bash
# Clone (path is just a suggestion — anywhere works)
git clone https://github.com/kergoth/session-env ~/.local/share/session-env
cd ~/.local/share/session-env

# Full setup: install script, create ~/.session-env from example, enable auto-start
make setup

# Or step by step:
make install                              # copy to ~/.local/bin/
cp example/session-env.example ~/.session-env
$EDITOR ~/.session-env                    # add your PATH, credentials, etc.
session-env install                       # enable desktop injection at login
```

```bash
# Store a keychain-only credential
session-env set CLAUDE_CODE_OAUTH_TOKEN "paste-token-here"

# Verify
session-env vars         # list discovered variables
session-env get GITHUB_TOKEN   # resolve a single credential

# Inject now (without waiting for next login)
session-env sync launchctl   # macOS
session-env sync dbus        # KDE Plasma
```

## Shell integration (SSH / headless / Linux console)

GUI terminals on macOS and KDE inherit session vars automatically after
`session-env install` — no shell integration needed there.

For SSH sessions, Linux console, or any context without desktop injection, add
to your `~/.zshenv`, `~/.bashrc`, or equivalent:

```bash
. ~/.session-env
```

## Commands

| Command | Description |
|---------|-------------|
| `session-env sync <launchctl\|dbus>` | Inject session vars into desktop environment |
| `session-env get <name>` | Resolve a credential (CLI tool → keychain → empty) |
| `session-env set <name> [value]` | Store a credential in the platform keychain |
| `session-env delete <name>` | Remove a credential from the platform keychain |
| `session-env vars` | List discovered session variable names |
| `session-env export` | Emit `export` statements for shell eval |
| `session-env install` | Install desktop session auto-start |
| `session-env uninstall` | Remove desktop session auto-start |

## Credential resolution

`session-env get` resolves credentials in order:

1. **CLI tool** — for credentials with a native auth mechanism (e.g.,
   `gh auth token` for `GITHUB_TOKEN`). No keychain entry needed.
2. **Platform keychain** — macOS Keychain (`security`) or Linux/FreeBSD
   Secret Service (`secret-tool`).
3. **Empty** — returns nothing (exit 0). Tools operate in degraded mode.

### Adding CLI sources

Edit the `lookup_cli()` function in `bin/session-env` to add new CLI-sourced
credentials. Keychain-only credentials need no script changes — just store them
with `session-env set`.

## Supported platforms

- **macOS** — Keychain via `security`, injection via `launchctl setenv`
- **Linux (KDE Plasma)** — Secret Service via `secret-tool`, injection via
  `dbus-update-activation-environment`
- **FreeBSD (KDE Plasma)** — same as Linux

## Running tests

Tests use [cram](https://bitheap.org/cram/), run via [uv](https://docs.astral.sh/uv/):

```bash
make test           # or: script/test
uvx cram tests/     # directly, if you prefer
```

## Design

Variable discovery uses `env -i` subprocess diffing: `~/.session-env` is
sourced in a clean environment, and every variable it exports (beyond `HOME`,
`USER`, and shell internals) is a session variable. No explicit variable list to
maintain.

Credentials in `~/.session-env` use the `${VAR:-fallback}` pattern so that
desktop-inherited values are reused in nested shells without re-querying the
keychain.

## Security considerations

Session-env injects variables into the desktop session via `launchctl setenv` or
`dbus-update-activation-environment`. These variables become visible to **every
process** in the session — not just the app you intended. Any application
(including compromised or malicious ones) can read them, and they may surface in
crash reports, process listings (`/proc/*/environ` on Linux), or log output.

**Prefer narrower alternatives when available:**

- **App-native auth flows** — many tools manage their own credentials (e.g.,
  `gh auth login`, `gcloud auth login`). These keep tokens out of the
  environment entirely and are the safest option.
- **Per-app configuration** — some apps accept credentials in their own config
  files (e.g., `env` in Claude Code's `settings.json`). This limits exposure to
  a single file on disk rather than the entire session, though the file itself
  must be protected.
- **CLI-sourced credentials** — `session-env get` resolves credentials on demand
  via CLI tools or the platform keychain, without injecting them into the
  environment. Use this in scripts and shell sessions where you can call
  `session-env get` at the point of use.

Session-env is most useful for variables like `PATH` and non-secret
configuration, and as a fallback for apps that have no native credential
support and only read from the environment.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for how to get started. This project
follows the [Contributor Covenant](CODE_OF_CONDUCT.md) code of conduct.

## Uninstall

```bash
session-env uninstall                                   # remove auto-start
cd ~/.local/share/session-env && make uninstall          # remove the script
```
