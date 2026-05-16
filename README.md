# volkey

Per-application volume control with global hotkeys for Fedora / PipeWire (Wayland).
Lets you bind keys like `Ctrl+Volume Up` to raise Applications volumes independently

---

## Disclamer

This project was mostly Vibe-Coded in a matter of hours, since i just wanted a tool to change App Volumes with a hotkey, i personaly have a limited understanding of Python :).
I just thought id share it, since i didnt find any tool like it. 

---

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/JacTech/volkey/main/install.sh | bash
```

The installer will:
- Check for Python 3.10+
- Install the `evdev` dependency automatically
- Copy `volkey` to `/usr/local/bin/`
- Add your user to the `input` group (required for Wayland hotkey capture)

---

## Commands

**Service Management**
| Command | Description |
|---|---|
| `volkey start` | Start the background service |
| `volkey stop` | Stop the background service |
| `volkey status` | Show whether the service is running |
| `volkey autostart [on\|off]` | Enable/disable start on login |

**Keybindings**
| Command | Description |
|---|---|
| `volkey keylist` | Show all configured bindings |
| `volkey keyset_up <app> <keys>` | Set a volume-up binding |
| `volkey keyset_down <app> <keys>` | Set a volume-down binding |
| `volkey keyrm_up <app>` | Remove volume-up binding |
| `volkey keyrm_down <app>` | Remove volume-down binding |
| `volkey keyrm <app>` | Remove all bindings for an app |

**Audio**
| Command | Description |
|---|---|
| `volkey list` | List active audio streams |
| `volkey apps` | List app names currently playing audio |
| `volkey granularity [1-50]` | Show or set the volume step size |

---

## Configuring hotkeys

Run `volkey apps` while something is playing to find the exact app name, then set bindings:

```bash
volkey keyset_up   firefox ctrl
volkey keyset_down firefox ctrl

volkey keyset_up   discord shift
volkey keyset_down discord shift

volkey keyset_up   spotify ctrl+shift
volkey keyset_down spotify ctrl+shift
```

**Valid modifier keys:** `ctrl`, `shift`, `alt`  
**Valid action keys:** `volume_up`, `volume_down`, `volume_mute`  
**Combos:** join with `+`, e.g. `ctrl+shift`

Bindings are saved to `~/.config/volkey/config.json` and can also be edited directly.

---

## Requirements

- Python 3.10+
- `pipewire-pulseaudio` (provides `pactl`)
- `evdev` Python package (installed automatically)

---

## Tested on

- Fedora Linux 43


## Uninstall

```bash
volkey uninstall
```
