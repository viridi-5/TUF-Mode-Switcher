# ASUS TUF Mode Switcher 

A Bash script to switch between **Performance** and **Power-saving** modes on ASUS TUF Gaming laptops. It supports GPU switching, CPU governor adjustment, and fan speed control for optimal system performance based on your needs.

##  Features
-  GPU switching using `prime-select` for NVIDIA and Intel GPUs.
-  CPU governor control via `auto-cpufreq` for better power management.
-  Fan speed adjustment (auto-detects single/dual-fan setups).
-  Automatic installation of missing dependencies.
-  Easy mode switch between **Performance** and **Power-saving** settings.
-  Works specifically for ASUS TUF Gaming laptops (other ASUS laptops with `asus-nb-wmi` support may also work).

##  Supported Models
- ASUS TUF Gaming F15 (Tested)
- Other ASUS laptops with `asus-nb-wmi` support (Partial Support)

##  Installation
To install the ASUS TUF Mode Switcher, follow these steps:

```bash
# Clone the repository
git clone https://github.com/yourusername/asus-tuf-mode-switcher.git

# Change to the directory
cd asus-tuf-mode-switcher

# Run the install script
sudo ./install.sh
```

This will copy the script to `/usr/local/bin/` and make it executable, so you can use it from anywhere.

##  Usage

Once installed, you can easily switch between **Performance** and **Power-saving** modes with the following commands:

```bash
# Switch to Performance mode
sudo mode_switch performance

# Switch to Power-saving mode
sudo mode_switch powersave
```

###  Additional Commands:
- If you want to **check the current mode** before switching, run:

```bash
prime-select query
cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
```

These commands will give you insight into the GPU and CPU governor currently in use.

##  Troubleshooting

If you run into any issues, here are some common problems and solutions:

### 1. **Missing Dependencies**
   - If you see an error like `command not found` for `prime-select` or `auto-cpufreq`, make sure they are installed. The script will attempt to install missing dependencies automatically, but you can manually install them if needed:

```bash
sudo apt update
sudo apt install nvidia-prime auto-cpufreq
```

### 2. **Permission Issues**
   - The script requires root privileges (`sudo`) to modify GPU settings, CPU governor, and fan speeds. If you’re getting permission errors, make sure you are running the script as root:

```bash
sudo ./mode_switch.sh performance
```

### 3. **Missing Fan Control Support**
   - If the script can't find the fan control paths, you may see a warning like:
     ```
     ⚠  Warning: Could not detect fan control paths. Fan speed adjustment will be skipped.
     ```
     This might happen if your ASUS laptop model doesn’t expose fan controls via the `asus-nb-wmi` driver. You can still use GPU and CPU mode switching, but the fan speed won’t be adjustable in such cases.

### 4. **Error While Switching Modes**
   - If the mode switching fails (e.g., if GPU or CPU modes can't be set), check that the required tools (e.g., `prime-select`, `auto-cpufreq`) are correctly installed and accessible. You can verify with:

```bash
prime-select query
cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
```

If they are missing, the script will try to install them, but sometimes a manual install might be necessary.

### 5. **System Reboot Required**
   - After switching to **Performance Mode** or **Power-Saving**, it's recommended to reboot your system for all changes to take full effect, particularly for GPU switching to apply properly. You’ll be prompted to reboot after each mode switch.

##  Customization & Advanced Use

### 1. **Custom Fan Control**
   - For advanced users, you might want to set custom fan speeds or behavior depending on the mode. You can manually control fan speed by modifying the PWM values directly in the `/sys/class/hwmon` paths.

   Example:
   ```bash
   echo 255 > /sys/class/hwmon/hwmon*/pwm1
   ```

   Be cautious with this to avoid unnecessary wear on your fans.

### **Fan Speed Disclaimer**
   - The fan speed set in the code will always **max out the fans** unless manually changed. If you do not want the fans to run at full speed, you can either **modify the script** to set a lower speed or leave it in **auto mode** by setting `pwm1_enable` to `2` and `pwm2_enable` to `2` on a **dual fan** machine
   
   ```bash
   echo 2 > /sys/class/hwmon/hwmon*/pwm1_enable
   echo 2 > /sys/class/hwmon/hwmon*/pwm2_enable
   ```

