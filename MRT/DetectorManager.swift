//
//  DetectorManager.swift
//  MRT
//
//  Created by Ronald Sumichael Sunan on 20/07/23.
//

import CoreLocation
import CoreBluetooth
import AVFoundation

class DetectorManager: NSObject, ObservableObject, CBCentralManagerDelegate, CLLocationManagerDelegate, CBPeripheralManagerDelegate {
    @Published var bluetoothStatus: BluetoothStatus = .mati
    
    var bluetoothManager: CBCentralManager?
    var locationManager: CLLocationManager?
    var localBeacon: CLBeaconRegion!
    var beaconPeripheralData: NSDictionary!
    var peripheralManager: CBPeripheralManager!
    
    let alarmHelper = AlarmManager()
    
    var beaconData: [String: Int] = [:]
    var selectedBeaconID: String = ""
    let localBeaconMajor: CLBeaconMajorValue = 12
    let localBeaconMinor: CLBeaconMinorValue = 34
    let secondaryMajor: CLBeaconMajorValue = 56
    let secondaryMinor: CLBeaconMinorValue = 78
    let identifier = "MARTI Beacon"
    
    var gates: [String: GateData] = [:]
    var isPaid: Bool = true
    
    init(bluetoothManager: CBCentralManager, locationManager: CLLocationManager) {
        super.init()
        self.bluetoothManager = bluetoothManager
        self.bluetoothManager?.delegate = self
        self.locationManager = locationManager
        self.locationManager!.delegate = self
        self.locationManager!.requestWhenInUseAuthorization()
    }
    
    func getGates(completion: @escaping () -> Void) {
        guard let url = URL(string: "https://raw.githubusercontent.com/TeamMarti/marti-temp-data/main/GateDatas") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print(error)
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                self.gates = try decoder.decode([String: GateData].self, from: data)
                completion()
            }
            catch {
                print(error)
            }
        }
        
        task.resume()
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            bluetoothStatus = .nyala
        case .poweredOff:
            bluetoothStatus = .mati
        default:
            bluetoothStatus = .mati
        }
    }
    
    // MARK: Receiver
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedWhenInUse {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    if gates.isEmpty {
                        getGates() {
                            self.startMonitoring()
                        }
                    } else {
                        startMonitoring()
                    }
                }
            }
        }
    }

    func startMonitoring() {
        print("Start Monitoring")
        let beaconIDs = ["93BF79B4-90CC-4AFA-8740-2F7FF4FA4934", "2A03208F-1C94-4441-A479-9F09D04F8260"]
        for i in 0...1 {
            let uuid = UUID(uuidString: beaconIDs[i])!
            let beaconConstraint = CLBeaconIdentityConstraint(uuid: uuid, major: localBeaconMajor, minor: localBeaconMinor)
            locationManager?.startRangingBeacons(satisfying: beaconConstraint)
        }
//        for gate in gates {
//            let uuid = UUID(uuidString: gate.key)!
//            let beaconConstraint = CLBeaconIdentityConstraint(uuid: uuid, major: localBeaconMajor, minor: localBeaconMinor)
//            locationManager?.startRangingBeacons(satisfying: beaconConstraint)
//        }
    }
    
    func stopMonitoring() {
        print("Stop Monitoring")
        let beaconIDs = ["93BF79B4-90CC-4AFA-8740-2F7FF4FA4934", "2A03208F-1C94-4441-A479-9F09D04F8260"]
        for i in 0...1 {
            let uuid = UUID(uuidString: beaconIDs[i])!
            let beaconConstraint = CLBeaconIdentityConstraint(uuid: uuid, major: localBeaconMajor, minor: localBeaconMinor)
            locationManager?.stopRangingBeacons(satisfying: beaconConstraint)
        }
//        for gate in gates {
//            let uuid = UUID(uuidString: gate.key)!
//            let beaconConstraint = CLBeaconIdentityConstraint(uuid: uuid, major: localBeaconMajor, minor: localBeaconMinor)
//            locationManager?.stopRangingBeacons(satisfying: beaconConstraint)
//        }
    }
    
    func update(_ rssi: Int) {
        print(rssi)
        if rssi >= -30 && isPaid {
            let money = 50000
            if money >= 10000 {
                initLocalBeacon()
            }
            else {
                if !alarmHelper.alarmRinging {
                    alarmHelper.playWarningSound()
                }
            }
        } else if rssi <= -60 {
            if localBeacon != nil {
                stopLocalBeacon()
            }
        }
    }
    
    func updateMaxRSSI() {
        if let maxRSSI = beaconData.values.max(),
           let beaconID = beaconData.first(where: { $0.value == maxRSSI })?.key {
            self.selectedBeaconID = beaconID
            
            update(maxRSSI)
        } else {
            self.selectedBeaconID = "NONE"
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didRange beacons: [CLBeacon], satisfying beaconConstraint: CLBeaconIdentityConstraint) {
        print("DidRange satisfying", beaconConstraint.uuid)
        for beacon in beacons {
            let beaconUUID = beacon.uuid.uuidString
            let rssi = beacon.rssi
            beaconData[beaconUUID] = rssi
            print(beaconData)
        }
        updateMaxRSSI()
    }
    
    // MARK: Beacon
    func initLocalBeacon() {
        if localBeacon != nil {
            stopLocalBeacon()
        }
        let uuid = UUID(uuidString: selectedBeaconID)!
        localBeacon = CLBeaconRegion(uuid: uuid, major: secondaryMajor, minor: secondaryMinor, identifier: identifier)
        beaconPeripheralData = localBeacon.peripheralData(withMeasuredPower: nil)
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil, options: nil)
    }
    
    func stopLocalBeacon() {
        peripheralManager.stopAdvertising()
        peripheralManager = nil
        beaconPeripheralData = nil
        localBeacon = nil
    }
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        if peripheral.state == .poweredOn {
            peripheralManager.startAdvertising(beaconPeripheralData as? [String: Any])
        }
        else if peripheral.state == .poweredOff {
            peripheralManager.stopAdvertising()
        }
    }
}
