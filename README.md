# AeroIndicator

## Install

```sh
brew tap rien7/apps
brew install --cask aeroindicator
```

## Usage

Add to your `.aerospace.toml`

```toml
# Apple Silicon
after-startup-command = ["exec-and-forget /opt/homebrew/bin/aeroIndicator --restart-service"]
exec-on-workspace-change = ['/bin/bash', '-c', '/opt/homebrew/bin/aeroIndicator workspace-change $AEROSPACE_FOCUSED_WORKSPACE']
on-focus-changed = ['exec-and-forget /opt/homebrew/bin/aeroIndicator focus-change']

# Intel
after-startup-command = ["exec-and-forget /usr/local/bin/aeroIndicator --restart-service"]
exec-on-workspace-change = ['/bin/bash', '-c', '/usr/local/bin/aeroIndicator workspace-change $AEROSPACE_FOCUSED_WORKSPACE']
on-focus-changed = ['exec-and-forget /usr/local/bin/aeroIndicator focus-change']
```

## Commands

- `--start-service`: Start the AeroIndicator service
- `--stop-service`: Stop the AeroIndicator service
- `--restart-service`: Restart the AeroIndicator service
- `--help, -h`: Show this help message
- `workspace-change WORKSPACE`: Change to specified workspace
- `focus-change`: Refresh application list

Use `rm /tmp/AeroIndicator` when there are no running instances of the app, but when executing `--start-service` it shows that the program is already running.

## Config

add `config.toml` in `~/.config/aeroIndicator`.

```toml
# ~/.config/aeroIndicator/config.toml
position = "bottom-left" # available value: bottom-left, bottom-center, bottom-right, top-left, top-center, top-right, center
outerPadding = 20
innerPadding = 12
borderRadius = 12
```
