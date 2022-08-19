//
//  BLEManager.swift
//  EarEffect
//
//  Created by Muhammad Zafar on 2022-08-06.
//

import CoreBluetooth
import Foundation
import ExternalAccessory

class BLEManager: NSObject {
    static let shared = BLEManager()
    var centralManager: CBCentralManager?
    var state: BLEState = .unknown
    override private init() {
    }

    func startBleManger() {
        if centralManager == nil {
            centralManager = CBCentralManager(delegate: self, queue: nil)
        }
    }

    func scanForBLEDevices() {
        if centralManager != nil {
            centralManager?.scanForPeripherals(withServices: nil, options: nil)
        }
       
    }
}

extension BLEManager: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .unknown:
            state = .unknown
        case .resetting:
            state = .resetting
        case .unsupported:
            state = .unsupported
        case .unauthorized:
            state = .unauthorized
        case .poweredOff:
            state = .poweredOff
        case .poweredOn:
            state = .poweredOn
        @unknown default:
            state = .unknown
        }
    }
    
}

extension BLEManager: CBPeripheralDelegate {
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print(peripheral.name)
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected to \(peripheral.name ?? "Uknown Device")")
    }

    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
    }
}

enum BLEState {
    case unknown
    case resetting
    case unsupported
    case unauthorized
    case poweredOff
    case poweredOn
}
