Set up path to session-env:

  $ SESSION_ENV="$TESTDIR/../bin/session-env"

Skip this file on non-macOS (macOS-specific install tests):

  $ if [ "$(uname -s)" != "Darwin" ]; then exit 80; fi

install creates a LaunchAgent plist:

  $ install_dir="$CRAMTMP/launchagents"
  > mkdir -p "$install_dir"
  > SESSION_ENV_LAUNCHAGENT_DIR="$install_dir" "$SESSION_ENV" install 2>&1
  Installed */com.session-env.plist (glob)
  Run "launchctl load *" to activate now, or it will start at next login. (glob)

  $ [ -f "$CRAMTMP/launchagents/com.session-env.plist" ] && echo "exists"
  exists

uninstall removes the plist:

  $ SESSION_ENV_LAUNCHAGENT_DIR="$CRAMTMP/launchagents" "$SESSION_ENV" uninstall 2>&1
  Removed */com.session-env.plist (glob)

  $ [ ! -f "$CRAMTMP/launchagents/com.session-env.plist" ] && echo "removed"
  removed

uninstall when nothing is installed:

  $ SESSION_ENV_LAUNCHAGENT_DIR="$CRAMTMP/empty" "$SESSION_ENV" uninstall 2>&1
  No LaunchAgent installed.
