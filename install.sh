set -euo pipefail

REPO="https://raw.githubusercontent.com/JacTech/volkey/main"
INSTALL_PATH="/usr/local/bin/volkey"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

info()    { echo -e "${GREEN}[volkey]${NC} $*"; }
warn()    { echo -e "${YELLOW}[volkey]${NC} $*"; }
error()   { echo -e "${RED}[volkey]${NC} $*" >&2; exit 1; }

# ── Checks ────────────────────────────────────────────────────────────────────

command -v python3 &>/dev/null || error "python3 is required but not found."

PY_VERSION=$(python3 -c 'import sys; print(sys.version_info.minor)')
[ "$PY_VERSION" -ge 10 ] || error "Python 3.10+ is required (found 3.$PY_VERSION)."

command -v pactl &>/dev/null || warn "pactl not found — install pipewire-pulseaudio for audio control to work."

# ── evdev ─────────────────────────────────────────────────────────────────────

info "Checking for evdev..."
if ! python3 -c "import evdev" &>/dev/null; then
    info "Installing evdev..."
    # Try pip with --break-system-packages (Fedora / newer distros)
    if python3 -m pip install --quiet --break-system-packages evdev 2>/dev/null; then
        info "evdev installed."
    elif python3 -m pip install --quiet evdev 2>/dev/null; then
        info "evdev installed."
    else
        error "Failed to install evdev. Try manually: pip install evdev"
    fi
else
    info "evdev already installed."
fi

# ── Script ────────────────────────────────────────────────────────────────────

info "Downloading volkey..."
TMP=$(mktemp)
curl -fsSL "$REPO/volkey" -o "$TMP"
chmod +x "$TMP"
sudo mv "$TMP" "$INSTALL_PATH"
info "Installed to $INSTALL_PATH."

# ── Input group ───────────────────────────────────────────────────────────────

if ! groups "$USER" | grep -q '\binput\b'; then
    info "Adding $USER to the 'input' group (needed to read keyboard events)..."
    sudo usermod -aG input "$USER"
    warn "Group change applied — you need to log out and back in for hotkeys to work."
else
    info "Already in the 'input' group."
fi

# ── Done ──────────────────────────────────────────────────────────────────────

echo
info "volkey installed successfully!"
echo
echo "  Quick start:"
echo "    volkey start          # start the background service"
echo "    volkey apps           # see apps currently playing audio"
echo "    volkey keylist        # view configured hotkeys"
echo "    volkey help           # full command reference"
echo
