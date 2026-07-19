# Neutron - MIUI 14 Mod Toolkit

**Device:** Xiaomi Redmi 10 2022 (`selene`)
**Android:** 14 (MIUI 14)
**Chipset:** MediaTek Helio G88 (MT6768)

## Features

- **Debloat** - Remove MIUI bloatware and telemetry
- **Performance** - CPU governor, rendering, animation tweaks
- **Battery** - Doze, wake locks, power saving
- **Display** - 90Hz refresh rate, SurfaceFlinger tweaks
- **Memory** - ZRAM optimization, LMK tuning

## Requirements

- Device rooted with Magisk or KernelSU
- ADB installed on your computer
- USB debugging enabled

## Usage

### Windows (PowerShell)
```powershell
# Run individual tweaks
.\windows\debloat.ps1
.\windows\perf.ps1
.\windows\battery.ps1
.\windows\display.ps1
.\windows\memory.ps1

# Or run all at once
.\windows\install_all.ps1

# Restore vendor
.\windows\restore.ps1
```

### Linux
```bash
chmod +x linux/*.sh

# Run individual tweaks
./linux/debloat.sh
./linux/perf.sh
./linux/battery.sh
./linux/display.sh
./linux/memory.sh

# Or run all at once
./linux/install_all.sh

# Restore vendor
./linux/restore.sh
```

### macOS
```bash
chmod +x macos/*.sh

# Same as Linux
./macos/install_all.sh
```

### Python (Cross-platform)
```bash
# Interactive menu
python install.py

# Apply all tweaks
python install.py --all

# Generate scripts for specific platform
python install.py --generate windows
python install.py --generate linux
python install.py --generate macos
```

## Backup

Always backup your vendor partition before applying tweaks:
```bash
.\windows\backup.ps1    # Windows
./linux/backup.sh       # Linux
```

## Restore

If something goes wrong:
```bash
.\windows\restore.ps1   # Windows
./linux/restore.sh      # Linux
```

## What Gets Modified

| Tweak | File | Changes |
|-------|------|---------|
| Debloat | System apps | Removes bloatware packages |
| Performance | vendor/build.prop | CPU, GPU, rendering settings |
| Battery | vendor/build.prop | Power saving, Doze config |
| Display | vendor/build.prop | 90Hz, SurfaceFlinger |
| Memory | vendor/build.prop | ZRAM, LMK thresholds |

## Reverting

To restore original vendor partition:
1. Use SP Flash Tool with stock firmware
2. Flash only the vendor partition
3. Or use the restore script if you have a backup

## License

MIT License - Use at your own risk.
