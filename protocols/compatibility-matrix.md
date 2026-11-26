# Compatibility matrix

Upstream claims vs. our unit. Update the "Our unit" column only from our own experiments (link the `EXP-NNN`).

Status values: ✅ works on our unit · ❌ fails · ⚠️ differs · ⏳ not tested yet

| Feature | Upstream status | Our unit | Experiment | Notes |
|---|---|---|---|---|
| BLE services AA12–AA15 present | HW ×2 | ⏳ | | |
| Battery `0x17` | HW | ⏳ | | |
| Versions `0x55` | HW | ⏳ | | |
| Project/customer code `0x64` | HW | ⏳ | | Identifies the hardware variant |
| Capability bits `0x95` | HW | ⏳ | | Check wake-word + live bits |
| Take photo `0x22 [30]` | HW | ⏳ | | Saves full photo on glasses |
| BLE preview `0x22 [31]` + AA15 | HW ×2 (320×180, ~3.5 s) | ⏳ | | |
| Wi-Fi hotspot `0x39` + file list | HW ×2 | ⏳ | | AP vs P2P variant? |
| Full-res download | HW ×2 (3200×2400) | ⏳ | | |
| Video record/stop `0x23`/`0x24` | static | ⏳ | | |
| Video download | not observed | ⏳ | | |
| Mic stream `0x57`/`0x56` | HW | ⏳ | | Opus, ~40 pkt/s |
| "Hi Luma" wake → stream | HW | ⏳ | | |
| Glasses as Mac Bluetooth speaker | untested anywhere | ⏳ | | |
| Mic + speaker at once | untested | ⏳ | | |
| Gesture config read `0x48` | HW | ⏳ | | |
| Gesture side effects on BLE | HW, not isolated | ⏳ | | Map one gesture at a time |
| RTSP live video | claimed once, not reproduced | ⏳ | | |
| Works with no vendor cloud | HW (tool never uses it) | ⏳ | | |
