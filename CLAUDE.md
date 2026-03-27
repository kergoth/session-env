# session-env

Injects environment variables into desktop sessions (macOS launchd, KDE D-Bus)
so GUI apps see the same environment as terminal sessions.

## Commands

```bash
make test                     # run full test suite
uvx cram tests/discovery.t    # run a single cram test
make install                  # install to ~/.local/bin/
make setup                    # full setup (install + example + auto-start)
```

## Architecture

- `bin/session-env` — single POSIX sh script; the entire tool
- `tests/*.t` — cram literate tests (run via `uvx cram`)
- `script/` — scripts-to-rule-them-all (bootstrap, install, test, setup, uninstall)
- `share/` — template files for launchd plist and XDG .desktop (contain `@@markers@@` replaced at install time)
- `example/` — example `~/.session-env` file

## Code Style

- POSIX sh (`#!/bin/sh`), not bash — no bashisms
- `set -eu` at top of scripts
- `printf` over `echo` for portability
- Functions prefixed by domain: `cmd_*`, `keychain_*`, `lookup_cli`

## Testing

Tests use [cram](https://bitheap.org/cram/) — literate shell tests where expected output is inline.
Requires `uv`/`uvx` (no cram install needed). On failure, cram writes `.t.err` files
showing actual vs expected output (gitignored, auto-cleaned on next pass).

Override env vars for test isolation:
- `SESSION_ENV_FILE` — path to session-env file (default: `~/.session-env`)
- `SESSION_ENV_OS` — force OS detection (`darwin`, `linux`, `freebsd`)
- `SESSION_ENV_LAUNCHAGENT_DIR` / `SESSION_ENV_AUTOSTART_DIR` — redirect install paths

## Gotchas

- `discover_vars` filters out `HOME`, `USER`, `PWD`, `SHLVL`, `_` — these are never treated as session vars
- Credential resolution order: CLI tool → platform keychain → empty (exit 0, not error)
- `env -i` means the session-env file runs with almost no environment — only `HOME` and `USER` are passed through
- Template markers use `@@MARKER@@` syntax (e.g., `@@SESSION_ENV_BIN@@`, `@@HOME@@`)
- **Security trade-off:** `sync` exposes variables to every process in the session — prefer app-native auth flows or per-app config for credentials; session-env is best for `PATH` and non-secret config
