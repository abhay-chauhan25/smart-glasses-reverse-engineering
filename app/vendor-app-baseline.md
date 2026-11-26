# Vendor app baseline

The official EYEVUE app, used as intended, before we replace it.

## Setup

| Item | Value |
|---|---|
| Phone | iPhone |
| App | EYEVUE for iOS, v3.3.6 (note: the Android app studied upstream used a different version line, 1.0.65-gp) |
| Account | Registration is optional per the manual (phone number). ⏳ whether one was created |
| Pairing | App → add device → select `E09-XXXX` → accept iOS pairing prompt → "Binding Successful". The glasses are now bonded to the iPhone |
| Switching phones (manual) | Forget the glasses in iOS Bluetooth settings, and "Unpair Device" in the app settings |

## Features tried (2026-11-26, by the user)

| Feature | Result |
|---|---|
| All app features except the Luma AI assistant | Work |
| Luma AI assistant | Not tried yet |

⏳ To fill in per feature when we benchmark: photo, video, audio recording, media sync to phone, translation modes, AI photo recognition, live preview (if the app offers it), settings available (gestures, wake word, volume, firmware update page).

## App permissions requested (manual)

Microphone, camera, photos, notifications, calendar, Bluetooth, (location for Wi-Fi joins on iOS: ⏳ confirm).

## Things to watch

- Any firmware update prompt: **decline** for now (see `CLAUDE.md`).
- The manual says AI features need the phone online, consistent with upstream's finding that the AI runs in the vendor cloud.
