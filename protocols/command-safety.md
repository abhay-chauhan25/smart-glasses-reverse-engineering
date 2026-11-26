# BLE command safety tiers

Every command is sorted by what it can do to the glasses. Command IDs and meanings come from upstream research (`protocols/research-sources.md`), not yet verified on our unit unless marked in `compatibility-matrix.md`.

Frame reminder: `AB 55 | len_hi len_lo | cmd | payload… | checksum` where `len = 1 + payload + 1` and `checksum = (cmd + sum(payload)) & 0xFF`.

## Tier 0 — Read-only (safe to send)

| Cmd | Name | Payload |
|---|---|---|
| `0x17` | GET_BATTERY | `00` |
| `0x16` | GET_CAPACITY (storage) | `00` |
| `0x55` | GET_DEVICE_INFO (BT/ISP/device versions) | none or `00` |
| `0x64` | CUSTOMER_PID_VID (project/customer code) | none |
| `0x95` | GET_SUPPORT_FUNCTION (capability bits) | none |
| `0x71` | GET_VOICE_ASSISTANT_STATUS | none |
| `0x69` | APP_RECEIVE_SOUND (read volumes) | none |
| `0x40` | APP_PULL_THUMBNAIL_COUNT | — |

`0x48` APP_GET_DEVICE_STATUS also reads back gesture settings; believed read-only, confirm before first use.

## Tier 1 — Capture / temporary state (changes nothing permanent, but takes photos, records, opens radios)

`0x22` TAKE_PHOTO, `0x23` RECORD_VIDEO, `0x24` STOP_RECORD, `0x34` RECORD_AUDIO, `0x57`/`0x56` start/stop mic stream, `0x0A` DEVICE_PHOTO_RECOGNITION (starts mic stream, no stop), `0x49`/`0x51` cancels, `0x36`/`0x37` photo pull, `0x39` OPEN_WIFI, `0x67` APP_LIVE, `0x44` with **`30 01` only** (finish, keep files), `0x30`/`0x31`/`0x33` media/call control, `0x70` volume, `0x59` set clock, `0x68` start classic-BT pairing.

## Tier 2 — Persistent settings (survive restart; record the old value first and restore after)

Gesture assignments `0x07` `0x08` `0x09` `0x10` `0x11`; `0x01` brightness, `0x02` record time, `0x03` mic setting, `0x04` wear detect, `0x06` voice command, `0x35`/`0x50`/`0x61` capture style/mode/direction, `0x62` offline language, `0x72` SET_VOICE_ASSISTANT_STATUS, `0x32` AI volume, `0x65` send ISP version (purpose unclear: treat as tier 3 until understood).

## Tier 3 — Destructive (explicit approval every single time)

| Cmd | Why |
|---|---|
| `0x14` RECOVER_FACTORY | Factory reset |
| `0x15` CLEAR_DEVICE_CONNECTION_RECORD | Forgets paired devices |
| `0x43` GESTURE_RECOVER | Wipes gesture settings |
| `0x44` with value2 `00` | **Deletes media from the glasses** |
| `0x63` WIFI_OTA | Starts a firmware update |
| anything on `AE01` | JieLi chip OTA/vendor channel, unknown |
| any HTTP POST / TCP `:5007` to the glasses | Firmware upload paths |
| any undocumented command ID | Unknown effect |
