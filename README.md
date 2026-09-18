# omarchy-sudo-timer

Passwordless `sudo` for a length of time you pick — 5 minutes, an hour, 24 hours,
or until you switch it off — instead of the usual all-or-nothing choice.

Built for [Omarchy](https://omarchy.org/), but the command itself only needs
bash, sudo and systemd.

```
sudo-timer            # pick a duration from a menu
sudo-timer 15m        # or 5m, 30m, 1h, 6h, 12h, 24h
sudo-timer forever    # until you turn it off
sudo-timer status     # current mode and time left
sudo-timer off        # revoke now
```

A bare number means minutes (`sudo-timer 90`). `-y` skips the confirmation for
scripted use.

## How it works

A drop-in in `/etc/sudoers.d` grants `NOPASSWD: ALL`, and three independent
things remove it again:

1. a systemd timer when the window expires,
2. `sudo-timer off`,
3. a boot-time cleanup unit.

The third one matters more than it looks. Transient systemd timers do not
survive a reboot, but the sudoers file does — so without it, rebooting in the
middle of a 24-hour window would leave passwordless sudo on indefinitely.
`forever` uses a separate filename that the cleanup deliberately spares.

Three other details worth knowing:

- **The rule is syntax-checked with `visudo -cf` before it is installed.** A
  malformed file in `/etc/sudoers.d` locks you out of sudo entirely.
- **The timer is `OnCalendar`, not `--on-active`.** Monotonic timers do not
  count time spent suspended, so on a laptop an `--on-active` window would
  silently stretch by however long the lid was closed.
- **If scheduling the expiry fails, the rule is removed again** rather than
  left in place with no expiry.

`status` never prompts for a password: if `sudo -n` fails there is no
passwordless rule to report on.

## Install

```bash
git clone https://github.com/hhammarstrand/omarchy-sudo-timer.git
cd omarchy-sudo-timer && ./install.sh
```

That installs the command to `~/.local/bin`. For the Omarchy menu entry and a
keybinding, see [`integration/`](integration/) — `menu.jsonc` goes in
`~/.config/omarchy/extensions/omarchy-menu.jsonc` (it overrides Omarchy's own
`setup.security.passwordless-sudo` entry, turning it into a submenu of
durations) and `bindings.lua` in `~/.config/hypr/bindings.lua`.

## A word on what this is

Passwordless sudo means every process running as you can become root without
asking. That includes scripts and coding agents you started. A time limit makes
that tolerable for a stretch of work; it does not make it safe. `forever` exists
because it is sometimes the honest answer, not because it is a good default.

## License

MIT
