#!/usr/bin/env bash
# ASUS TUF Mode Switcher - A script to switch between Performance and Power-saving modes
# Supports NVIDIA Optimus switching, CPU governor adjustment, and fan speed control

set -e  # Exit on error

# Function to display usage
usage() {
    echo "Usage: sudo $0 <performance|powersave>"
    exit 1
}

# Ensure script runs as root
if [ "$EUID" -ne 0 ]; then
    echo "❌ Please run as root (sudo)."
    exit 1
fi

# Convert input to lowercase
MODE="${1,,}"

# Validate input
if [[ "$MODE" != "performance" && "$MODE" != "powersave" ]]; then
    echo "❌ Invalid mode: $MODE"
    usage
fi

# Check if the laptop is an ASUS model
is_asus_laptop() {
    grep -qi "asus" /sys/class/dmi/id/sys_vendor 2>/dev/null
}
if ! is_asus_laptop; then
    echo "⚠️  Not an ASUS laptop. Exiting..."
    exit 1
fi

# Function to check dependencies and install if missing
dep_check() {
    if ! command -v "$1" &>/dev/null; then
        echo "🔧 Installing $1..."
        apt update && apt install -y "$2"
    fi
}

dep_check prime-select nvidia-prime
dep_check auto-cpufreq auto-cpufreq

# Get current GPU mode and CPU governor
current_gpu=$(prime-select query 2>/dev/null)
current_cpu=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor 2>/dev/null)

# Function to find the hwmon path for fan control
find_fan_control_path() {
    for hwmon in /sys/devices/platform/asus-nb-wmi/hwmon/hwmon*; do
        if [[ -e "$hwmon/pwm1_enable" ]]; then
            echo "$hwmon"
            return
        fi
    done
    echo ""
}

FAN_PATH=$(find_fan_control_path)
PWM1_ENABLE="$FAN_PATH/pwm1_enable"
PWM2_ENABLE="$FAN_PATH/pwm2_enable"

if [ -z "$FAN_PATH" ]; then
    echo "⚠️  Warning: Could not detect fan control paths. Fan speed adjustment will be skipped."
fi

# Define mode settings
if [ "$MODE" == "performance" ]; then
    desired_gpu="nvidia"
    desired_cpu="performance"
    desired_fan_mode=0  # Max fan speed
else
    desired_gpu="intel"
    desired_cpu="powersave"
    desired_fan_mode=2  # Auto fan control
fi

# Check if already in desired mode
if [ "$current_gpu" == "$desired_gpu" ] && [ "$current_cpu" == "$desired_cpu" ]; then
    if [ -n "$FAN_PATH" ] && [ "$(cat "$PWM1_ENABLE" 2>/dev/null)" == "$desired_fan_mode" ]; then
        if [[ -e "$PWM2_ENABLE" ]] && [ "$(cat "$PWM2_ENABLE" 2>/dev/null)" == "$desired_fan_mode" ]]; then
            echo "✅ Already in $MODE mode (GPU: $current_gpu, CPU: $current_cpu, Fans: $desired_fan_mode). No changes needed."
            exit 0
        fi
    fi
fi

echo "🔧 Switching to $MODE mode..."

# Apply mode changes
prime-select "$desired_gpu"
echo "✅ GPU switched to: $desired_gpu"

auto-cpufreq --force="$desired_cpu"
echo "✅ CPU governor set to: $desired_cpu"

# Adjust fan speed if supported
if [ -n "$FAN_PATH" ]; then
    echo "$desired_fan_mode" > "$PWM1_ENABLE"
    echo "✅ Fan 1 control set to: $desired_fan_mode"
    if [[ -e "$PWM2_ENABLE" ]]; then
        echo "$desired_fan_mode" > "$PWM2_ENABLE"
        echo "✅ Fan 2 control set to: $desired_fan_mode"
    fi
else
    echo "⚠️  Skipping fan control due to missing support."
fi

# Ask for reboot
read -p "Would you like to reboot now? (y/N): " reboot_choice
if [[ "${reboot_choice,,}" == "y" ]]; then
    echo "🔄 Rebooting system..."
    reboot
else
    echo "🔄 Please reboot later for full effect."
fi

exit 0
