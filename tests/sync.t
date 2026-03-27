Set up path to session-env:

  $ SESSION_ENV="$TESTDIR/../bin/session-env"

sync with no backend exits 2:

  $ "$SESSION_ENV" sync
  usage: session-env sync <launchctl|dbus> (re)
  [2]

sync with unknown backend exits 2:

  $ "$SESSION_ENV" sync badbackend
  unknown backend: badbackend
  [2]

sync with empty session-env file exits 0 (nothing to inject):

  $ cat > "$CRAMTMP/.session-env" << 'EOF'
  > # empty, no exports
  > EOF

  $ SESSION_ENV_FILE="$CRAMTMP/.session-env" "$SESSION_ENV" sync launchctl
