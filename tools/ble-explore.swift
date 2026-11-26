// ble-explore.swift — read-only BLE explorer for the E09 glasses.
//
// Safety: this script NEVER writes to the glasses. It only scans, connects, lists
// services/characteristics, and reads standard read-only values (battery level,
// device information). See protocols/command-safety.md.
//
// Usage:
//   swift tools/ble-explore.swift scan                 # list nearby E09 glasses (no connection)
//   swift tools/ble-explore.swift inspect <identifier> # connect to exactly that device and list its GATT table
//
// <identifier> is the UUID printed by `scan`. macOS never shows real Bluetooth MAC
// addresses to apps; it gives each device a per-Mac UUID instead. We pin to that UUID
// so we can never accidentally talk to someone else's glasses.

import CoreBluetooth
import Foundation

let args = CommandLine.arguments
let mode = args.count > 1 ? args[1] : "scan"
let targetID = args.count > 2 ? UUID(uuidString: args[2]) : nil

let glassesService = CBUUID(string: "AA12")
let batteryLevel = CBUUID(string: "2A19")
// Standard Device Information characteristics (all read-only by spec)
let deviceInfoChars: Set<CBUUID> = ["2A29", "2A24", "2A25", "2A26", "2A27", "2A28"].map { CBUUID(string: $0) }.reduce(into: []) { $0.insert($1) }

func describe(_ p: CBCharacteristicProperties) -> String {
    var f: [String] = []
    if p.contains(.read) { f.append("read") }
    if p.contains(.write) { f.append("write") }
    if p.contains(.writeWithoutResponse) { f.append("write-no-response") }
    if p.contains(.notify) { f.append("notify") }
    if p.contains(.indicate) { f.append("indicate") }
    return f.joined(separator: ", ")
}

func hex(_ d: Data) -> String { d.map { String(format: "%02X", $0) }.joined(separator: " ") }

final class Explorer: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    var central: CBCentralManager!
    var peripheral: CBPeripheral?
    var seen = Set<UUID>()
    var otherDevices = 0
    var pendingServices = 0
    var pendingReads = 0

    override init() {
        super.init()
        central = CBCentralManager(delegate: self, queue: nil)
    }

    func finish(_ message: String, code: Int32 = 0) {
        print(message)
        if let p = peripheral { central.cancelPeripheralConnection(p) }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { exit(code) }
    }

    // MARK: Central

    func centralManagerDidUpdateState(_ c: CBCentralManager) {
        switch c.state {
        case .poweredOn: break
        case .unauthorized:
            finish("Bluetooth permission denied. Allow your terminal app in System Settings > Privacy & Security > Bluetooth.", code: 1); return
        case .poweredOff:
            finish("The Mac's Bluetooth is off.", code: 1); return
        default:
            return // still starting up
        }

        if mode == "scan" {
            print("Scanning for 15 seconds. Nothing will be connected or sent.\n")
            c.scanForPeripherals(withServices: nil, options: nil)
            DispatchQueue.main.asyncAfter(deadline: .now() + 15) {
                c.stopScan()
                self.finish("\nDone. Ignored \(self.otherDevices) unrelated Bluetooth devices nearby.")
            }
        } else if mode == "inspect" {
            guard let id = targetID else { finish("Usage: inspect <identifier from scan>", code: 1); return }
            if let p = c.retrievePeripherals(withIdentifiers: [id]).first {
                connect(p)
            } else {
                print("Device not cached yet; scanning for exactly \(id)...")
                c.scanForPeripherals(withServices: nil, options: nil)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 30) {
                self.finish("Timed out after 30 s. Are the glasses on, and the iPhone's Bluetooth off?", code: 1)
            }
        } else {
            finish("Unknown mode '\(mode)'. Use scan or inspect.", code: 1)
        }
    }

    func centralManager(_ c: CBCentralManager, didDiscover p: CBPeripheral,
                        advertisementData ad: [String: Any], rssi: NSNumber) {
        let name = p.name ?? (ad[CBAdvertisementDataLocalNameKey] as? String) ?? ""
        let services = (ad[CBAdvertisementDataServiceUUIDsKey] as? [CBUUID]) ?? []

        if mode == "inspect" {
            if p.identifier == targetID { c.stopScan(); connect(p) }
            return
        }

        guard !seen.contains(p.identifier) else { return }
        seen.insert(p.identifier)
        let looksLikeGlasses = name.hasPrefix("E09") || services.contains(glassesService)
        guard looksLikeGlasses else { otherDevices += 1; return }

        let connectable = (ad[CBAdvertisementDataIsConnectable] as? NSNumber)?.boolValue ?? false
        let mfg = (ad[CBAdvertisementDataManufacturerDataKey] as? Data).map(hex) ?? "none"
        print("FOUND \(name)")
        print("  identifier : \(p.identifier.uuidString)")
        print("  signal     : \(rssi) dBm (closer to 0 = nearer)")
        print("  connectable: \(connectable)")
        print("  advertised services: \(services.map(\.uuidString))")
        print("  manufacturer data  : \(mfg)\n")
    }

    func connect(_ p: CBPeripheral) {
        guard peripheral == nil else { return }
        peripheral = p
        p.delegate = self
        print("Connecting to \(p.name ?? "?") (\(p.identifier.uuidString))...")
        central.connect(p)
    }

    func centralManager(_ c: CBCentralManager, didConnect p: CBPeripheral) {
        print("Connected.")
        print("Largest write the Mac will send: \(p.maximumWriteValueLength(for: .withResponse)) bytes (with response), "
              + "\(p.maximumWriteValueLength(for: .withoutResponse)) bytes (without response)\n")
        p.discoverServices(nil)
    }

    func centralManager(_ c: CBCentralManager, didFailToConnect p: CBPeripheral, error: Error?) {
        finish("Failed to connect: \(error?.localizedDescription ?? "unknown")", code: 1)
    }

    func centralManager(_ c: CBCentralManager, didDisconnectPeripheral p: CBPeripheral, error: Error?) {
        if let error { print("Disconnected: \(error.localizedDescription)") }
    }

    // MARK: Peripheral

    func peripheral(_ p: CBPeripheral, didDiscoverServices error: Error?) {
        if let error { finish("Service discovery failed: \(error.localizedDescription)", code: 1); return }
        let services = p.services ?? []
        pendingServices = services.count
        for s in services { p.discoverCharacteristics(nil, for: s) }
    }

    func peripheral(_ p: CBPeripheral, didDiscoverCharacteristicsFor s: CBService, error: Error?) {
        print("SERVICE \(s.uuid.uuidString)\(s.uuid == glassesService ? "  <- vendor glasses service" : "")")
        for ch in s.characteristics ?? [] {
            print("  char \(ch.uuid.uuidString)  [\(describe(ch.properties))]")
            // Read-only: only standard battery / device-information values.
            if ch.properties.contains(.read) && (ch.uuid == batteryLevel || deviceInfoChars.contains(ch.uuid)) {
                pendingReads += 1
                p.readValue(for: ch)
            }
        }
        pendingServices -= 1
        maybeFinish()
    }

    func peripheral(_ p: CBPeripheral, didUpdateValueFor ch: CBCharacteristic, error: Error?) {
        pendingReads -= 1
        if let error {
            print("READ \(ch.uuid.uuidString) failed: \(error.localizedDescription)")
        } else if let v = ch.value {
            if ch.uuid == batteryLevel, let b = v.first {
                print("READ battery level (standard 0x2A19): \(b)%   raw: \(hex(v))")
            } else {
                print("READ \(ch.uuid.uuidString): \"\(String(decoding: v, as: UTF8.self))\"   raw: \(hex(v))")
            }
        }
        maybeFinish()
    }

    func maybeFinish() {
        if pendingServices <= 0 && pendingReads <= 0 {
            finish("\nDone. Nothing was written to the glasses. Disconnecting.")
        }
    }
}

let explorer = Explorer()
RunLoop.main.run()
