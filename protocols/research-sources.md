# Research sources

Upstream work we build on. Pinned commits are the versions reviewed; record a new hash if we re-review. Clones live outside this repo.

## Primary (EYEVUE E09)

| Source | What it is | Commit reviewed | License | Notes |
|---|---|---|---|---|
| [sctg-development/ai-smart-glasses-e09](https://github.com/sctg-development/ai-smart-glasses-e09) | Protocol doc (`REVERSE_ENGINEERING_EYEVUE_BLE_PROTOCOL.md` v2.1) + decompiled vendor app (v1.0.65-gp) | `c32e065ebbea769184df5abda9e43774631e1eca` | README says MIT, **no LICENSE file** | Decompiled vendor code and secrets: reference only, never copy. 0 GitHub issues |
| [sctg-development/ai-smart-glasses-e09-reverse](https://github.com/sctg-development/ai-smart-glasses-e09-reverse) | Swift CLI `e09_reverse`: BLE tests + Mistral voice demo | `863467cd0f52b77e653fe9307f256c8d9e20511f` | MIT (LICENSE present) | Reusable with attribution. See safety warning in `notes/audit-2026-11-26.md` |
| [sctg-development/ai-smart-glasses-e09-firmware-downloader](https://github.com/sctg-development/ai-smart-glasses-e09-firmware-downloader) | Rust tool querying the vendor's OTA catalog (no auth) | `8667ea4e` (per manfred) | Cargo.toml MIT, no LICENSE file | Contacts vendor servers: ask before using |
| [sctg-development/ai-smart-glasses-e09-flutter](https://github.com/sctg-development/ai-smart-glasses-e09-flutter) | Flutter client (macOS) | not pinned | README says "all rights reserved" | Reference only |

## Independent E09 work (found during audit)

| Source | Why it matters | License |
|---|---|---|
| [FerSaiyan/Alternative-HeyCyan-App-and-SDK](https://github.com/FerSaiyan/Alternative-HeyCyan-App-and-SDK) (CyanBridge) | Android app supporting EyeVue; `EyevueUfw.kt` names the BT chip **JieLi AC701N** and parses the scrambled `.ufw` firmware format | Apache-2.0 |
| [thetopham/manfred](https://github.com/thetopham/manfred) `docs/hardware/eyevue-e09.md` | Careful field notes on a TK8/0201 unit (BT 1.1.9, ISP 3.3.7); OTA route correction; photo timing | — |
| [tijo95/eyevue-ctl](https://github.com/tijo95/eyevue-ctl) | From-scratch Android client; notes the vendor app logs BLE frames to logcat | — |

## Comparative only (different hardware)

| Source | Hardware |
|---|---|
| [Embarcadero Labs: cheap camera glasses](https://www.embarcaderolabs.com/blog/cheap-camera-glasses-hidden-sdk) | DPVR G6 (FCC 2A9JD-Q6), HeyCyan/oudmon platform, Allwinner V821. Good methodology reference |
| [pepebot-space/nisaetus](https://github.com/pepebot-space/nisaetus) | HeyCyan M02S/A02S |
| [Iam5tillLearning/OpenSource-Ai-Glasses](https://github.com/Iam5tillLearning/OpenSource-Ai-Glasses) | Rockchip RV1106B open hardware (Apache-2.0) |

## Tools

- LightBlue: free on the Mac App Store (macOS 13.3+), useful for manual BLE inspection.
