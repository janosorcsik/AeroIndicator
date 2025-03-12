# Install

```sh
brew tap rien7/apps
brew install --cask aeroindicator
```

# Usage

Add to your `.aerospace.toml`

```toml
# Apple Silicon
exec-on-workspace-change = ['/bin/bash', '-c', '/opt/homebrew/bin/aeroIndicator workspace-change $AEROSPACE_FOCUSED_WORKSPACE']
on-focus-changed = ['exec-and-forget /opt/homebrew/bin/aeroIndicator focus-change']

# Intel
exec-on-workspace-change = ['/bin/bash', '-c', '/usr/local/bin/aeroIndicator workspace-change $AEROSPACE_FOCUSED_WORKSPACE']
on-focus-changed = ['exec-and-forget /usr/local/bin/aeroIndicator focus-change']
```
