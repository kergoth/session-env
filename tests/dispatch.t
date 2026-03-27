Set up path to session-env:

  $ SESSION_ENV="$TESTDIR/../bin/session-env"

No arguments prints usage to stderr and exits 2:

  $ "$SESSION_ENV"
  usage: session-env <command> [args]
  
  Commands:
      sync <launchctl|dbus>   Inject session vars into desktop environment
      get <name>              Resolve a credential from CLI tool or keychain
      set <name> [value]      Store a credential in the platform keychain
      delete <name>           Remove a credential from the platform keychain
      vars                    List discovered session variable names
      export                  Emit export statements for shell eval
      install                 Install desktop session auto-start
      uninstall               Remove desktop session auto-start
      help                    Show this help
  [2]


Unknown subcommand exits 2:

  $ "$SESSION_ENV" badcmd
  usage: session-env <command> [args]
  
  Commands:
      sync <launchctl|dbus>   Inject session vars into desktop environment
      get <name>              Resolve a credential from CLI tool or keychain
      set <name> [value]      Store a credential in the platform keychain
      delete <name>           Remove a credential from the platform keychain
      vars                    List discovered session variable names
      export                  Emit export statements for shell eval
      install                 Install desktop session auto-start
      uninstall               Remove desktop session auto-start
      help                    Show this help
  [2]


Help exits 0 and shows usage on stdout:

  $ "$SESSION_ENV" help
  usage: session-env <command> [args]
  
  Commands:
      sync <launchctl|dbus>   Inject session vars into desktop environment
      get <name>              Resolve a credential from CLI tool or keychain
      set <name> [value]      Store a credential in the platform keychain
      delete <name>           Remove a credential from the platform keychain
      vars                    List discovered session variable names
      export                  Emit export statements for shell eval
      install                 Install desktop session auto-start
      uninstall               Remove desktop session auto-start
      help                    Show this help

