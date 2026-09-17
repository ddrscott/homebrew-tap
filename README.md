# ddrscott/tap

Homebrew formulae and casks for Scott Pierce's tools.

```sh
brew tap ddrscott/tap
brew install relay-tty                 # terminal sessions that outlive the terminal
brew install --cask max-pane           # the fullscreen strip of terminals and pages; pulls in relay-tty
```

`Formula/relay-tty.rb` installs the npm package and the matching pre-built
`relay-pty-host` from the GitHub release, so nothing downloads at install time
beyond what Homebrew fetches itself. `Casks/max-pane.rb` is written by
max-pane's `scripts/release.sh` from the DMG that shipped.
