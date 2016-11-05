////
////  BluetoothManager.swift
////  OneRail
////
////  Created by Danny Bravo on 05/11/2016.
////  Copyright © 2016 HackTrain. All rights reserved.
////
//
//import Foundation
//import CoreBluetooth
//
//protocol BluetoothManagerDelegate {
//    
//}
//
//final class BluetoothManager: NSObject, CBCentralManagerDelegate { //CBPeripheralDelegate do we need this?
//    
//    //MARK: - variables
//    let centralManager: CBCentralManager
//    var delegate: BluetoothManagerDelegate?
//    
//    //MARK: - lifecycle
//    init() {
//        centralManager = CBCentralManager(delegate: self, queue: nil, options: nil) //TODO add background options
//        startScanning()
//    }
//    
//    //MARK: - utilities
//    func startScanning() {
//        centralManager.scanForPeripherals(withServices: nil, options: nil) //TODO add service limitation (should this go in delegate "centralManagerDidUpdateState")
//    }
//    
//    //MARK: - central manager delegate
//    func centralManagerDidUpdateState(_ central: CBCentralManager) {
//        switch central.state {
//        case .poweredOff:
//            print("powered off")
//        case .poweredOn:
//            print("powered on")
//        case .resetting:
//            print("resetting")
//        case .unauthorized:
//            print("unauthorized")
//        case .unknown:
//            print("unknown")
//        case .unsupported:
//            print("unsupported")
//        }
//    }
//    
//    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
//        print(#function)
////        peripheral.delegate = self; I don't think we need this.
//        centralManager.stopScan() //verify train and get welcome message
//    }
//    
//    func centralManager(_ central: CBCentralManager, willRestoreState dict: [String : Any]) {
//        print(#function) //TODO do we need this?
//    }
//    
//    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
//        if let error = error {
//            print(error) //TODO error handling?
//        }
//        print(#function)
//    }
//    
//    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
//        if let error = error {
//            print(error) //TODO error handling?
//        }
//        print(#function)
//        startScanning()
//    }
//    
//    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
//        print(#function)
//        centralManager.connect(peripheral, options: nil) //TODO verify advertisement data
//    }
//    
//}
