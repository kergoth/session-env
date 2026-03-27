# Contributing to session-env

Thank you for considering contributing to session-env!

This project follows the [Contributor Covenant Code of Conduct](CODE_OF_CONDUCT.md).
By participating, you are expected to uphold this code.

## Getting started

```bash
git clone https://github.com/kergoth/session-env
cd session-env
script/bootstrap    # check prerequisites
make test           # run the test suite
```

## Running tests

Tests use [cram](https://bitheap.org/cram/) and run via `uvx` (no install needed):

```bash
make test                   # run all tests
uvx cram tests/dispatch.t   # run a single test file
uvx cram -i tests/foo.t     # interactive mode: merge actual output into test
```

When a test fails, cram writes a `.t.err` file alongside the test showing
actual output. These are gitignored and auto-removed on the next passing run.

## Project layout

```
bin/session-env         # the tool
tests/*.t               # cram test files
script/                 # scripts-to-rule-them-all
example/                # example ~/.session-env
```

## Submitting changes

1. Fork and create a feature branch
2. Write or update cram tests for your change
3. Ensure `make test` passes
4. Open a pull request with a clear description of what and why

## Reporting issues

Open an issue at https://github.com/kergoth/session-env/issues.
