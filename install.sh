#!/usr/bin/env bash
# Install the ASUS TUF Mode Switcher script

set -e

SCRIPT_NAME="mode_switch.sh"
INSTALL_PATH="/usr/local/bin/mode_switch"

echo "📂 Installing ASUS TUF Mode Switcher..."

# Copy script and set permissions
sudo cp "$SCRIPT_NAME" "$INSTALL_PATH"
sudo chmod +x "$INSTALL_PATH"

echo "✅ Installation complete! Run with: sudo mode_switch performance | powersave"
