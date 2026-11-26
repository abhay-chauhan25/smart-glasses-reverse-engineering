# Open questions

## Waiting on me (the user)

- [x] Firmware: app says "latest version" (BT V2.0.7 / ISP V2.3.6). Whether setup updated it is unknown.
- [x] FCC internal photos saved: JieLi chip confirmed, second chip unreadable.
- [ ] Try downloading the FCC **Block Diagram** and **Operational Description** for 2BF3Z-E09 from fcc.gov (they'd name the chips).
- [ ] Was an EYEVUE account created, or used without one?
- [ ] Confirm on the glasses: which arm has the touch area, button, camera, charging port.
- [x] App version: iOS v3.3.6
- [x] Phone: iPhone
- [x] Box/manual photos: FCC ID 2BF3Z-E09, specs, controls (see `hardware/hardware-profile.md`)
- [ ] Is Ghidra installed somewhere? (Not found on disk; the Ghidra MCP server refused connections.)

## Technical unknowns (answer with experiments)

- Does the glasses' BLE accept a second connection while the iPhone app is connected? (Likely not: turn the iPhone's Bluetooth off first.)
- Does a BLE connection keep the glasses awake, or do they still auto power-off after 3 minutes idle?
- Does our unit (TK11, BT 2.0.7) speak the same protocol as the researched units (TK8, BT 1.1.9)?
- Wi-Fi: AP mode at `192.168.169.1`? Same password?
- Can the Mac use the glasses as a Bluetooth speaker? Simultaneously with the BLE mic stream?
- Battery drain of: continuous mic stream, Wi-Fi hotspot, RTSP live video (300 mAh battery is small).
- Does RTSP decode on the Mac with ffmpeg? Latency?
- Which gesture/button produces which BLE side effect? Does translation mode report taps to the app?
- Does connecting our own BLE client stop the 6–7 s offline "Hi Luma" fallback mode?
- Camera/Wi-Fi chip identity. Does firmware have signature checks? Any recovery mode?

## Decisions for later

- Are glasses photos allowed to go to Claude, or only the local model? (OMNIS currently sends only text to Claude.)
- Buy a spare unit before any firmware experiments?
- Phone app (Phase 9) will be **iOS** (user has an iPhone): no Wi-Fi Direct, background limits. Our unit is probably AP-mode Wi-Fi, which iOS can join.
