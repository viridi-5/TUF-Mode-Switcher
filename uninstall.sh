#!/usr/bin/env bash
# Uninstall the ASUS TUF Mode Switcher

set -e

INSTALL_PATH="/usr/local/bin/mode_switch"

echo "🗑️ Removing ASUS TUF Mode Switcher..."

if [ -f "$INSTALL_PATH" ]; then
    sudo rm "$INSTALL_PATH"
    echo "✅ Uninstallation complete."
else
    echo "⚠️  Script not found in $INSTALL_PATH."
fi
