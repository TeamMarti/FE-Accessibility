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
//class DetectorManager: NSObject, ObservableObject, CLLocationManagerDelegate, CBPeripheralManagerDelegate {
    @Published var isBluetoothOn: Bool = true
    
    var bluetoothManager: CBCentralManager?
    var locationManager: CLLocationManager?
    var localBeacon: CLBeaconRegion!
    var beaconPeripheralData: NSDictionary!
    var peripheralManager: CBPeripheralManager!
    
    let alarmHelper = AlarmManager()
    
    var beaconData: [String: Int] = [:]
    var selectedBeaconID: String = "0368D30E-BC09-4583-BFB6-77089872AA93"
    let localBeaconMajor: CLBeaconMajorValue = 12
    let localBeaconMinor: CLBeaconMinorValue = 34
    let secondaryMajor: CLBeaconMajorValue = 56
    let secondaryMinor: CLBeaconMinorValue = 78
    let identifier = "MARTI Beacon"
    
    var gates: [String: GateData] = [:]
    
    var isBalanceEnough: Bool = false
    
    override init() {
        super.init()
        self.bluetoothManager = CBCentralManager()
        self.bluetoothManager?.delegate = self
        self.locationManager = CLLocationManager()
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
                self.gates = [
                    "CDC83B22-72D9-4D25-A72B-4254E13F9DD9": GateData(station: "FWI", gate: 1),
                    "934C3403-9C39-42E7-A88F-EDF7106DB211": GateData(station: "LBG", gate: 1)
                ]
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
            isBluetoothOn = true
        case .poweredOff:
            isBluetoothOn = false
        default:
            isBluetoothOn = false
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
        for gate in gates {
            print(gate.key)
            let uuid = UUID(uuidString: gate.key)!
            let beaconConstraint = CLBeaconIdentityConstraint(uuid: uuid, major: localBeaconMajor, minor: localBeaconMinor)
            locationManager?.startRangingBeacons(satisfying: beaconConstraint)
        }
    }
    
    func stopMonitoring() {
        print("Stop Monitoring")
        for gate in gates {
            let uuid = UUID(uuidString: gate.key)!
            let beaconConstraint = CLBeaconIdentityConstraint(uuid: uuid, major: localBeaconMajor, minor: localBeaconMinor)
            locationManager?.stopRangingBeacons(satisfying: beaconConstraint)
        }
    }
    
    func update(_ rssi: Int) {
        if UserDefaults.standard.bool(forKey: "isConfirmed") {
            if rssi >= -40 && rssi != 0{
                if isBalanceEnough {
                    initLocalBeacon()
                    if UserDefaults.standard.integer(forKey: "tripStatus") == 0 {
                        UserDefaults.standard.set(1, forKey: "tripStatus")
                        UserDefaults.standard.set(true, forKey: "justChecked")
                    } else if !UserDefaults.standard.bool(forKey: "justChecked") {
                        UserDefaults.standard.set(2, forKey: "tripStatus")
                    }
                } else {
                    if !alarmHelper.alarmRinging {
                        alarmHelper.playWarningSound()
                    }
                }
            } else {
                if localBeacon != nil {
                    stopLocalBeacon()
                }
                UserDefaults.standard.set(false, forKey: "justChecked")
            }
        } else {
            print("Haven't Confirmed")
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
    
//    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
//        for beacon in beacons {
//            let beaconUUID = beacon.uuid.uuidString
//            let rssi = beacon.rssi
//            beaconData[beaconUUID] = rssi
//            print(beaconData)
//        }
//        updateMaxRSSI()
//    }
    
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
        print(peripheral.state)
        if peripheral.state == .poweredOn {
            peripheralManager.startAdvertising(beaconPeripheralData as? [String: Any])
        }
        else if peripheral.state == .poweredOff {
            peripheralManager.stopAdvertising()
        }
    }
}
