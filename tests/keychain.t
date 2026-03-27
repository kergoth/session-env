Set up path to session-env:

  $ SESSION_ENV="$TESTDIR/../bin/session-env"

get with no name exits 2:

  $ "$SESSION_ENV" get
  usage: session-env get <name> (re)
  [2]

set with no name exits 2:

  $ "$SESSION_ENV" set
  usage: session-env set <name> \[value\] (re)
  [2]

delete with no name exits 2:

  $ "$SESSION_ENV" delete
  usage: session-env delete <name> (re)
  [2]

get with unknown credential and no keychain returns empty, exits 0:

  $ "$SESSION_ENV" get NONEXISTENT_CRED_12345

get GITHUB_TOKEN uses gh auth token when gh is available (skip if not):

  $ if ! command -v gh >/dev/null 2>&1 || ! gh auth status >/dev/null 2>&1; then
  >     exit 80
  > fi
  > result=$("$SESSION_ENV" get GITHUB_TOKEN)
  > [ -n "$result" ] && echo "resolved" || echo "empty"
  resolved
