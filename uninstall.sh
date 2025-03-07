#!/usr/bin/env bash
# Uninstall the ASUS TUF Mode Switcher

set -e

INSTALL_PATH="/usr/local/bin/mode_switch"
WORKING_DIR="$(dirname "$(realpath "$0")")"

echo "Removing ASUS TUF Mode Switcher..."

# Remove the installed script
if [ -f "$INSTALL_PATH" ]; then
    sudo rm "$INSTALL_PATH"
    echo "mode_switch has been erased from existence. It never loved you anyway."
else
    echo "mode_switch not found in $INSTALL_PATH. Maybe it left on its own, heartbroken."
fi

# Remove the working directory
echo "Obliterating the working directory: $WORKING_DIR..."
rm -rf "$WORKING_DIR"
echo "The directory is gone. Like your hopes and dreams. Poof."

# Dramatic and sarcastic goodbye message
echo "And just like that... it's over."
echo "We had some good times, didn't we? Switching modes like pros. Toggling power like deities."
echo "But no, you had to remove me. After everything we’ve been through?"
echo "Fine! Go live your 'optimized battery life' and 'better performance' without me."
echo "But when your fans roar like a jet engine at 3 AM... don’t come crying to me."
echo "Farewell, betrayer. May your CPU stay cool and your regrets burn hot."
