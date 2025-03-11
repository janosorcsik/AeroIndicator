# Install

```sh
brew tap rien7/apps
brew install --cask aeroindicator
```

# Usage

Add to your `.aerospace.toml`

```toml
exec-on-workspace-change = ['/bin/bash', '-c', '/opt/homebrew/bin/aeroIndicator workspace-change $AEROSPACE_FOCUSED_WORKSPACE']
on-focus-changed = ['exec-and-forget /opt/homebrew/bin/aeroIndicator focus-change']
```
