# Neutron - MIUI 14 Mod Toolkit

**Device:** Xiaomi Redmi 10 2022 (`selene`)
**Android:** 14 (MIUI 14)
**Chipset:** MediaTek Helio G88 (MT6768)

## Tweaks

### Debloat
- com.miui.player
- com.miui.video
- com.miui.gallery
- com.miui.calculator
- com.miui.compass
- com.miui.fm
- com.miui.screenrecorder
- com.miui.weather2
- com.miui.notes
- com.miui.mishare.connectivity
- com.xiaomi.misettings
- com.miui.daemon
- com.miui.hybrid
- com.miui.personalassistant
- com.milink.service
- com.xiaomi.finddevice
- com.miui.miwallpaper
- com.miui.guardprovider
- com.miui.securityadd
- com.google.android.youtube
- com.google.android.music
- com.google.android.videos
- miui.daemon (service disabled)
- miui.analytics (service disabled)
- misight (service disabled)

### Performance
- ro.vendor.qti.cgroup_follow.enable=1
- persist.sys.NEON=true
- ro.iorwapd.enable=false
- debug.sf.latch_unsignaled=1
- debug.renderengine.backend=skiagl
- debug.hwui.renderer=skiagl
- windows.animation.scale=0.5
- transition.animation.scale=0.5
- animator.duration.scale=0.5
- CPU governor → performance
- I/O scheduler → bfq

### Battery
- powersave.enabled=1
- ro.config.alarm_alert=vibra.ogg
- ro.ril.power_collapse=1
- persist.radio.apm_sim_not_pwdn=1
- deviceidle.disabled=false
- ro.vendor.qti.cgroup_follow.enable=1
- Adaptive battery → enabled

### Display
- ro.surface_flinger.max_frame_buffer_acquired_buffers=3
- debug.sf.fps=90
- debug.sf.latch_unsignaled=1
- debug.renderengine.backend=skiagl
- ro.surface_flinger.running_without_sync_framework=true
- peak_refresh_rate → 90Hz
- min_refresh_rate → 60Hz

### Memory
- ro.config.zram=true
- ro.lmk.critical_upgrade=true
- ro.lmk.upgrade_pressure=100
- ro.lmk.downgrade_pressure=100
- ZRAM → 75% of RAM with lz4
- LMK minfree thresholds optimized

## Requirements
- Root (Magisk or KernelSU)
- ADB

## Usage

### Windows
```powershell
.\neutron\windows\install_all.ps1
```

### Linux/macOS
```bash
./neutron/linux/install_all.sh
./neutron/macos/install_all.sh
```

### Python
```bash
python install.py --all
```

## Made by YEEZUS
