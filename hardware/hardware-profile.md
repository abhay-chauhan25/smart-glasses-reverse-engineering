# Hardware profile — our unit

Facts about **our** glasses. Source column says where each fact came from. Serial numbers, the Bluetooth MAC address, and the device-name suffix (derived from the MAC) are deliberately left out.

Last updated: 2026-11-26

## Identity

| Item | Value | Source |
|---|---|---|
| Retail name / model | "AI Smart Glasses", Model **E09** | Box, manual |
| Box SKU | ZXE09BK01-TK (E09, black) | Box label |
| FCC ID | **2BF3Z-E09** | Box, manual |
| Manufacturer (FCC grantee) | Shenzhen Taiyang Technology Co., Ltd, Shenzhen, China. Grant 2026-06-15 | fccid.io/2BF3Z-E09 |
| Radios (FCC) | Bluetooth 2402–2480 MHz (BLE + Classic EDR test reports); Wi-Fi 2.4 GHz 802.11b/g/n, 20 MHz, channels 1–11. **No 5 GHz** | FCC grant |
| BLE device name | `E09-XXXX` (suffix redacted; matches the end of the BT address) | Vendor app |
| Bluetooth address type | Random static (first byte's top two bits are `11`) | Vendor app, interpreted |
| Device Type (project + customer code) | **TK110301** (likely project `TK11` + customer `0301`; split is a hypothesis until read via BLE `0x64`) | Vendor app |
| Bluetooth firmware | **V2.0.7** | Vendor app |
| ISP (camera chip) firmware | **V2.3.6** | Vendor app |
| Hardware version | **V2** | Vendor app |
| Vendor app | EYEVUE for **iOS v3.3.6** | User |
| Firmware updated by the app? | ⏳ unknown | |
| Wi-Fi mode | ⏳ Hypothesis: AP mode at `192.168.169.1`, because the vendor app treats project codes containing "T" as AP units | Upstream static analysis |

### How our unit compares to the researched units

| Unit | Project/customer | BT fw | ISP fw | HW |
|---|---|---|---|---|
| **Ours** | TK11 / 0301 | 2.0.7 | 2.3.6 | 2 |
| manfred notes | TK8 / 0201 | 1.1.9 | 3.3.7 | 2 |
| sctg (protocol doc) | "T" variant, codes not published | — | — | — |
| tijo95/eyevue-ctl | name "E09-3AA1" | — | — | — |

Our unit has a **different project code and newer Bluetooth firmware** than any published unit. Every upstream finding must be re-checked on ours.

## Specifications (manufacturer claims, not measured)

| Spec | Value |
|---|---|
| Camera | 8 MP, "software stabilization" |
| Video | 1080p, max 10 minutes per clip |
| Storage | 8 GB |
| Battery | 300 mAh Li-ion polymer |
| Charging | USB-C, 5 V 0.3 A |
| Bluetooth | 5.3, range up to 10 m |
| Audio | Dual open-ear speakers (optional sound tubes), dual mic with ENC (noise cancelling) |
| Frame | TR90 |
| Operating temp | 0–35 °C |
| Auto power-off | After **3 minutes of inactivity** (matters for experiments) |

## Chips

| Part | Best guess | Confidence | Source |
|---|---|---|---|
| Bluetooth/audio SoC | JieLi AC701N | Medium (for EyeVue generally, not our unit) | CyanBridge `EyevueUfw.kt` |
| Camera / Wi-Fi SoC | Unknown | — | FCC internal photos exist but weren't viewable by our fetcher |
| Camera sensor | Unknown | — | |

## Physical layout (from manual diagram, to be confirmed on the glasses)

| Item | Location / behavior |
|---|---|
| Camera | Front corner of the frame |
| Recording light | Next to the camera. Flashes once per photo; solid while recording video/audio |
| Touch area | On the temple arm |
| Physical button | One button, underside of the frame/temple |
| Speaker grilles | One on each temple arm |
| Microphone | Temple arm |
| Status light | Temple arm. Blue flashes = powering on / pairing; red flashes = powering off; red = charging; off = fully charged |
| Charging port | USB-C on the temple arm |

## Default controls (manual)

| Interaction | Default action |
|---|---|
| Button: hold 3 s | Power on ("Power On" voice prompt) |
| Button: hold 5 s | Power off |
| Button: hold ~10 s | Force restart |
| Button: short press | Take photo (or stop an ongoing recording) |
| Button: double press | Start video recording |
| Button: triple press | Start audio recording |
| Touch: single tap | Play / pause (answer/hang up during calls) |
| Touch: double tap | Next track |
| Touch: triple tap | Previous track |
| Touch: swipe forward | Volume up |
| Touch: swipe backward | Volume down |
| Voice: "Hi, Luma" | AI assistant |
| Translation mode | Tap the touch area once or twice "as indicated in the App" |

Notes:
- The five touch gestures match the five configurable gesture commands upstream found (`0x07`–`0x11`). Button actions aren't in that list, so they're probably fixed in firmware (hypothesis).
- In translation mode the app reacts to touch-area taps. That suggests taps *can* be reported to a connected app in some mode, which matters for button events (hypothesis to test).
