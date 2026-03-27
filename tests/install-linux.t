Set up path to session-env:

  $ SESSION_ENV="$TESTDIR/../bin/session-env"

Skip this file on non-Linux (Linux-specific install tests):

  $ if [ "$(uname -s)" != "Linux" ]; then exit 80; fi

install creates an autostart .desktop file:

  $ install_dir="$CRAMTMP/autostart"
  > mkdir -p "$install_dir"
  > SESSION_ENV_AUTOSTART_DIR="$install_dir" "$SESSION_ENV" install 2>&1
  Installed */session-env.desktop (glob)
  Will activate at next login.

  $ [ -f "$CRAMTMP/autostart/session-env.desktop" ] && echo "exists"
  exists

uninstall removes the .desktop file:

  $ SESSION_ENV_AUTOSTART_DIR="$CRAMTMP/autostart" "$SESSION_ENV" uninstall 2>&1
  Removed */session-env.desktop (glob)

  $ [ ! -f "$CRAMTMP/autostart/session-env.desktop" ] && echo "removed"
  removed
