Set up path to session-env:

  $ SESSION_ENV="$TESTDIR/../bin/session-env"

Create a session-env file with two exported variables:

  $ cat > "$CRAMTMP/.session-env" << 'EOF'
  > export TEST_VAR_ONE="hello"
  > export TEST_VAR_TWO="world"
  > EOF

vars lists discovered variables (sorted for determinism):

  $ SESSION_ENV_FILE="$CRAMTMP/.session-env" "$SESSION_ENV" vars
  TEST_VAR_ONE
  TEST_VAR_TWO

export emits valid shell export statements (sorted for determinism):

  $ SESSION_ENV_FILE="$CRAMTMP/.session-env" "$SESSION_ENV" export
  export TEST_VAR_ONE="hello"
  export TEST_VAR_TWO="world"

Non-exported variables should not appear:

  $ cat > "$CRAMTMP/.session-env" << 'EOF'
  > export EXPORTED_VAR="visible"
  > NOT_EXPORTED="invisible"
  > EOF

  $ SESSION_ENV_FILE="$CRAMTMP/.session-env" "$SESSION_ENV" vars
  EXPORTED_VAR

Missing session-env file produces no output and exits 0:

  $ SESSION_ENV_FILE="$CRAMTMP/nonexistent" "$SESSION_ENV" vars

Conditional exports work (shell logic in session-env file):

  $ cat > "$CRAMTMP/.session-env" << 'EOF'
  > if true; then
  >     export COND_YES="included"
  > fi
  > if false; then
  >     export COND_NO="excluded"
  > fi
  > EOF

  $ SESSION_ENV_FILE="$CRAMTMP/.session-env" "$SESSION_ENV" vars
  COND_YES
