# Roadmap

Last updated: 2026-11-26

## Goal in one line

Control everything the E09 glasses can do from my MacBook with our own code; then plug that into OMNIS so I can talk to OMNIS through the glasses and send it photos/videos.

## How the glasses talk (from upstream research, not yet checked on our unit)

| Channel | Used for |
|---|---|
| **BLE** (Bluetooth Low Energy) | Commands, battery/info, take photo, tiny 320×180 preview photo, microphone audio stream, gesture settings, turning Wi-Fi on |
| **Classic Bluetooth** (like normal earbuds) | Sound coming *out* of the glasses' speakers, play/pause buttons |
| **Wi-Fi hotspot** on the glasses | Full-size photos (3200×2400), videos, voice memos, maybe live video (RTSP) |
| Vendor cloud | The "Hi Luma" AI. We replace this, we don't need it |

## Phases

| # | Phase | What "done" means | Status |
|---|---|---|---|
| 0 | Audit existing research | Know what's proven vs. guessed | **Done** 2026-11-26 (`notes/audit-2026-11-26.md`) |
| 1 | Know our unit | Versions, IDs, physical layout, vendor-app baseline recorded in `hardware/hardware-profile.md` | **In progress**: glasses charged, app installed and tried |
| 2 | Quick yes/no tests | One small experiment each: battery/info, preview photo, full-res Wi-Fi download, mic stream, glasses as Mac speaker, live video, what each gesture shows over BLE | Not started |
| 3 | Our own control library | Swift package `GlassesKit` + `glassesctl` CLI, built one proven feature at a time, with a safety tier on every command | Not started |
| 4 | Buttons and gestures | Detect presses on the laptop and map them to our own actions | Not started |
| 5 | Media sync | Photos/videos land on the Mac automatically, never deleted from glasses without confirmation | Not started |
| 6 | Live camera | On-demand frames (and live stream if Phase 2 says it works) | Not started |
| 7 | **OMNIS extension** | Talk to OMNIS through the glasses' mic/speaker; send it photos/videos | Waits for 3–6 |
| 8a | Firmware study (read-only) | Identify chips, read firmware structure; can run in parallel from Phase 2 | Not started |
| 8b | Firmware changes | Only if needed, recoverable, and approved | Gated |
| 9 | Phone app | Replace the laptop as the bridge (choose iPhone vs Android first) | Later |

## Biggest unknowns to answer early (Phase 2)

1. Can the glasses play OMNIS's voice? (Pair them to the Mac as a normal Bluetooth speaker.)
2. Does the mic stream work on our unit, and how much battery does it use?
3. Does live video (RTSP) actually decode, and how laggy is it?
4. The Mac has one Wi-Fi radio: joining the glasses' hotspot cuts the Mac's internet. How do we live with that?
5. What does each gesture show over BLE? (No direct "button pressed" messages exist; only side effects.)

## Next steps

1. Record what the vendor app shows: app version, firmware version, whether it asked to update (see `notes/open-questions.md`).
2. Photos of the box/manual/labels (hide serials) → fill `hardware/hardware-profile.md`.
3. First read-only BLE session: list services, ask battery and version. Hand-decode the replies.
