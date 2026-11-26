# Open questions

## Waiting on me (the user)

- [ ] Vendor app: app version, firmware version shown, and **did it update the glasses' firmware** when I first connected?
- [ ] Phone used for the vendor app: iPhone or Android? Spare Android available?
- [ ] Photos of box, manual, and labels (serials hidden): FCC ID?
- [ ] Physical layout and default gesture behavior (see `hardware/hardware-profile.md`).
- [ ] Is Ghidra installed somewhere? (Not found on disk; the Ghidra MCP server refused connections.)

## Technical unknowns (answer with experiments)

- Does the glasses' BLE accept a second connection while the phone app is connected? (Likely not: disconnect the phone first.)
- Can the Mac use the glasses as a Bluetooth speaker? Simultaneously with the BLE mic stream?
- Battery drain of: continuous mic stream, Wi-Fi hotspot, RTSP live video.
- Does RTSP decode on the Mac with ffmpeg? Latency?
- Which gesture produces which BLE side effect?
- Does connecting our own BLE client stop the 6–7 s offline "Hi Luma" fallback mode?
- Do the glasses need vendor-cloud activation for anything?
- Camera/Wi-Fi chip identity. Does firmware have signature checks? Any recovery mode?

## Decisions for later

- Are glasses photos allowed to go to Claude, or only the local model? (OMNIS currently sends only text to Claude.)
- Buy a spare unit before any firmware experiments?
- Phone platform for Phase 9.
