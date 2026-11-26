# CLAUDE.md — EYEVUE E09 smart glasses research

Instructions for Claude Code sessions in this repo. Read this first, then `notes/roadmap.md` for where things stand.

## What this project is

Reverse-engineering my own EYEVUE E09 AI smart glasses so I can control them from my MacBook without the vendor app or cloud: camera, video, microphone, speaker, buttons/gestures, media download, and (stretch) firmware.

**Order of work:** first get full control of the glasses from the laptop as a standalone project. Only after that, connect it to OMNIS (`~/projects/omnis`) as an extension so I can talk to OMNIS through the glasses and send it photos/videos. Do not work on OMNIS integration until the roadmap says so.

## How to work with me

- I'm learning. Explain what we're doing and why, in plain language first, details second. Keep summaries short.
- Give me a few hardware actions at a time, wait for my results, interpret them, then continue.
- After each meaningful stage: short summary of what we did, why, how it works, what I learned, limits, next step.
- Mark every claim as one of: **verified on our unit**, **third-party (upstream) finding**, **hypothesis**, **unknown**. Never present upstream research as our own discovery.

## Hardware safety rules (hard rules)

- Never update or flash firmware, erase storage, or factory reset without my explicit approval for that specific action.
- Never send a BLE command that isn't documented, and check `protocols/command-safety.md` before sending anything. Destructive-tier commands need my explicit approval every time.
- Never run the upstream `e09_reverse` tool without `--help`/`--list`/an explicit `--test` list of reviewed tests: with no flags it auto-connects to the first device named "*E09*" and runs the full suite (see `notes/audit-2026-11-26.md`).
- Only talk to my own glasses: pin the device by its identifier, never connect by name match alone.
- Do not disable the camera recording LED or any privacy indicator.
- Do not execute downloaded research code without reviewing it first. Keep upstream clones outside this repo.

## Privacy rules

Never commit: serial numbers, MAC addresses, Wi-Fi SSIDs with device suffixes, personal photos/recordings, raw packet captures, credentials/API keys, vendor secrets found in the decompiled app, proprietary firmware images, or the vendor APK. Redact before committing excerpts. Don't send device data to external services without asking.

## Git workflow

- Commit and push to `origin main` when a meaningful chunk is done and checked.
- Commit messages: short and natural, 3-6 words (e.g. "Add hardware profile notes"). No AI/Claude co-author trailers.
- Never force-push or rewrite history without asking.

## Repo layout

| Path | Contents |
|---|---|
| `notes/roadmap.md` | Phases, current status, next steps — keep updated |
| `notes/audit-2026-11-26.md` | Initial verification audit of the existing research |
| `notes/open-questions.md` | Things we don't know yet |
| `notes/experiment-template.md` | Template for `notes/experiments/EXP-NNN-*.md` |
| `hardware/hardware-profile.md` | What our exact unit is (versions, IDs, physical layout) |
| `protocols/compatibility-matrix.md` | Upstream claims vs. what works on our unit |
| `protocols/command-safety.md` | Every BLE command sorted by risk tier |
| `protocols/research-sources.md` | Upstream repos, pinned commits, licenses |
| `app/` | Vendor EYEVUE app observations |
| `firmware/` | Read-only firmware study notes (no binaries) |
| `tools/` | Our own code (planned: Swift package `GlassesKit` + `glassesctl` CLI) |

## Tech decisions so far (see `notes/roadmap.md`)

- Device code in **Swift** (CoreBluetooth): it's what OMNIS uses, it can later run on iOS, and the best reference implementation is Swift. Python only for offline analysis scripts.
- Upstream research is a reference, reimplemented in our own code. The `e09_reverse` tool is MIT (reusable with attribution); the main research repo has no LICENSE file and contains decompiled vendor code — don't copy from it.

## Environment (checked 2026-11-26)

macOS 26.5.1 on M4, Swift 6.3.3, Xcode 26.6, Python 3.13.7, ffmpeg, Homebrew `opus`, uv, Java 21, Docker, gh (signed in). Not installed: Ghidra (not found on disk), jadx, binwalk, Wireshark, adb, LightBlue, PacketLogger. Docker cannot reach the Mac's Bluetooth/Wi-Fi hardware.
