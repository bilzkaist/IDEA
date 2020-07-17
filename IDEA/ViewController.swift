//
//  ViewController.swift
//  IDEA
//
//  Created by Bilal Dastagir on 2020/07/15.
//  Copyright © 2020 Bilal Dastagir. All rights reserved.
//


import UIKit
import CoreBluetooth
import CoreLocation
import CoreMotion

let kMaxRadius: CGFloat = 200
let kMaxDuration: TimeInterval = 10

class ViewController: UIViewController, CBPeripheralManagerDelegate{
    
    

    @IBOutlet weak var sourceView: UIImageView!
    @IBOutlet weak var countSlider: UISlider!
    @IBOutlet weak var radiusSlider: UISlider!
    @IBOutlet weak var durationSlider: UISlider!
    @IBOutlet weak var rSlider: UISlider!
    @IBOutlet weak var gSlider: UISlider!
    @IBOutlet weak var bSlider: UISlider!
    @IBOutlet weak var aSlider: UISlider!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var radiusLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var rLabel: UILabel!
    @IBOutlet weak var gLabel: UILabel!
    @IBOutlet weak var bLabel: UILabel!
    @IBOutlet weak var aLabel: UILabel!
    
    // --- Table View Controller ----//
    @IBOutlet var tableView: UITableView!
    
    let itemsarray = [ "Person A", "Person B", "Person C", "Person D", "Person E", "Person F", "Person G", "Person H", "Person I", "Person J" ]
    //     End     //
    
    // --- BLE -------//
    var locationManager: CLLocationManager!
    var blePowerON  = true
    var localBeacon: CLBeaconRegion!
    var beaconPeripheralData: NSDictionary!
    var peripheralManager: CBPeripheralManager!
    var localBeaconUUID = "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5"
    var localBeaconMajor: CLBeaconMajorValue = 2019
    var localBeaconMinor: CLBeaconMinorValue = 5610
    var identifierBeacon = "Bilz"
    
    let uuid = UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5")!
    let uuidArray = [UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5"),UUID(uuidString: "E2C56DB5-DFFB-48D2-B060-D0F5A71096E0")]
    var beaconConstraints = [CLBeaconIdentityConstraint: [CLBeacon]]()
    var beacons = [CLProximity: [CLBeacon]]()
    
    var IDEA_ID = ""
    
    //     END        //
    

    let pulsator = Pulsator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Pulsator
        sourceView.layer.superlayer?.insertSublayer(pulsator, below: sourceView.layer)
        setupInitialValues()
        pulsator.start()
        
        
        
        // BLE Advertisement
        startLocalBeacon()
        locationManager = CLLocationManager()
        locationManager.delegate = self
        
        
        
        // Table
        tableView.layer.borderWidth = 2
        tableView.layer.borderColor = UIColor.blue.cgColor
        tableView.delegate = self
        tableView.dataSource = self
        
        // BLE Scanning
        startScanning()
        
        
    
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        // Stop Monitoring
        for region in locationManager.monitoredRegions
        {
            locationManager.stopMonitoring(for: region)
        }
        
        // Stop Ranging
        for constraint in beaconConstraints.keys
        {
            locationManager.stopRangingBeacons(satisfying: constraint)
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.layer.layoutIfNeeded()
        pulsator.position = sourceView.layer.position
    }

    private func setupInitialValues() {
        countSlider.value = 5
        countChanged(sender: nil)
        
        radiusSlider.value = 0.7
        radiusChanged(sender: nil)
        
        durationSlider.value = 0.5
        durationChanged(sender: nil)
        
        rSlider.value = 0
        gSlider.value = 0.455
        bSlider.value = 0.756
        aSlider.value = 1
        colorChanged(sender: nil)
    }

    // MARK: - Actions
    
    @IBAction func countChanged(sender: UISlider?) {
        //you can specify the number of pulse by the property "numPulse"
        pulsator.numPulse = Int(countSlider.value)
        countLabel.text = "\(pulsator.numPulse)"
    }
    
    @IBAction func radiusChanged(sender: UISlider?) {
        pulsator.radius = CGFloat(radiusSlider.value) * kMaxRadius
        radiusLabel.text = String(format: "%.0f", pulsator.radius)
    }
    
    @IBAction func durationChanged(sender: UISlider?) {
        pulsator.animationDuration = Double(durationSlider.value) * kMaxDuration
        durationLabel.text = String(format: "%.1f", pulsator.animationDuration)
    }
    
    @IBAction func colorChanged(sender: UISlider?) {
        pulsator.backgroundColor = UIColor(
            red: CGFloat(rSlider.value),
            green: CGFloat(gSlider.value),
            blue: CGFloat(bSlider.value),
            alpha: CGFloat(aSlider.value)).cgColor
        rLabel.text = String(format: "%.2f", rSlider.value)
        gLabel.text = String(format: "%.2f", gSlider.value)
        bLabel.text = String(format: "%.2f", bSlider.value)
        aLabel.text = String(format: "%.2f", aSlider.value)
    }
    
    @IBAction func switchChanged(sender: UISwitch) {
        if sender.isOn {
            pulsator.start()
            blePowerON  = true
            peripheralManager.startAdvertising(beaconPeripheralData as? [String: Any])
           
        }
        else {
            pulsator.stop()
            blePowerON = false
            peripheralManager.stopAdvertising()
        }
    }
}


extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You Tapped Me! ")
    }
}


extension ViewController: UITableViewDataSource {
    
/*
    func numberOfSections(in tableView: UITableView) -> Int {
        //return beacons.count
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        /*
        if beacons.count == 0
        {
            return 0
        }
        else
        {
            return Array(beacons.values)[section].count
        }
 */
        return itemsarray.count
    }
    
    // Section 1 -> Row 1
    // Section 2 -> Row 1
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        //let secctionkey = Array(beacons.keys)[indexPath.section]
        //let beacon = beacons[secctionkey]![indexPath.row]
        print("Inside TableView: ", beacons)
        //cell.textLabel?.text = "UUID: \(beacon.uuid.uuidString)"
        
        cell.textLabel?.text = itemsarray[indexPath.row]
        
        return cell
    }
 */
    
    // iBeacon Ranging
  
    func numberOfSections(in tableView: UITableView) -> Int {
        //print("Beacons Count: ",beacons.count)
        return beacons.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Array(beacons.values)[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        // Display the UUID, major, and minor for each beacon.
        let sectionkey = Array(beacons.keys)[indexPath.section]
        let beacon = beacons[sectionkey]![indexPath.row]
    
        let major = beacon.major
        let minor = beacon.minor
        
        let distance = String(format: "%.2f", beacon.accuracy)
        
        IDEA_ID.append(String(format: "%d",major))
        IDEA_ID.append("-1DEA-")
        IDEA_ID.append(String(format: "%d",minor))
        
        //print(IDEA_ID)
        cell.textLabel?.text = "ID: \(IDEA_ID)          d: \(distance) m"
        IDEA_ID = ""
        //cell.textLabel?.text = "ID: \(beacon.uuid.uuidString)"
        //print("UUID: \(beacon.uuid.uuidString)")
        //cell.detailTextLabel?.text = "Major: \(beacon.major) Minor: \(beacon.minor)"
        
        return cell
    }
 
    
    // BLE Functions Scanning Code   //
    
    func startScanning()
    {
        print("Started Scanning !!!")
        //var closestBeacon: CLBeacon? = nil
        self.locationManager.requestWhenInUseAuthorization()
        
        for uui in uuidArray
        {
            let constraint = CLBeaconIdentityConstraint(uuid: uui!)
            self.beaconConstraints[constraint] = []
            let beaconRegion = CLBeaconRegion(beaconIdentityConstraint: constraint , identifier: uui!.uuidString)
            locationManager.startMonitoring(for: beaconRegion)
            //print("Major : ",beaconRegion.major ?? 9999)
            //self.tableView.reloadData()
        }
        
    }
    
    // MARK: - Location Manager Delegate
    /// - Tag: didDetermineState
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {

        let beaconRegion = region as? CLBeaconRegion
        if state == .inside {
            // Start ranging when inside a region.
            manager.startRangingBeacons(satisfying: beaconRegion!.beaconIdentityConstraint)
        } else {
            // Stop ranging when not inside a region.
            manager.stopRangingBeacons(satisfying: beaconRegion!.beaconIdentityConstraint)
        }
    }
    
    /// - Tag: didRange
    func locationManager(_ manager: CLLocationManager, didRange beacons: [CLBeacon], satisfying beaconConstraint: CLBeaconIdentityConstraint) {
        /*
         Beacons are categorized by proximity. A beacon can satisfy
         multiple constraints and can be displayed multiple times.
         */
        beaconConstraints[beaconConstraint] = beacons
        
        self.beacons.removeAll()
        
        var allBeacons = [CLBeacon]()
        
        for regionResult in beaconConstraints.values {
            allBeacons.append(contentsOf: regionResult)
        }
        
        for range in [CLProximity.unknown, .immediate, .near, .far] {
            let proximityBeacons = allBeacons.filter { $0.proximity == range }
            if !proximityBeacons.isEmpty {
                self.beacons[range] = proximityBeacons
            }
        }
       // print("Location Manager:")
        //print("LM Beacons Count:", beacons.count)
        self.tableView.reloadData()
    }
    
    // End of BLE Functions Scanning Code   //
    
    
}






// BLE Functions Advertising Code   //

extension ViewController: CLLocationManagerDelegate {
    
    func startLocalBeacon()
    {
        if localBeacon != nil
        {
            stopLocalBeacon()
        }
        
        let uuid = UUID(uuidString: localBeaconUUID)!
        localBeacon = CLBeaconRegion(proximityUUID: uuid, major: localBeaconMajor, minor: localBeaconMinor, identifier: identifierBeacon)
        beaconPeripheralData = localBeacon.peripheralData(withMeasuredPower: nil)
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil, options: nil)
    }
    
    func stopLocalBeacon()
    {
        peripheralManager.stopAdvertising()
        peripheralManager = nil
        beaconPeripheralData = nil
        localBeacon = nil
    }
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        if peripheral.state == .poweredOn {
            print("BLE Powered ON!")
            peripheralManager.startAdvertising(beaconPeripheralData as? [String: Any])
        }
        else if peripheral.state == .poweredOff {
            print("BLE Powered OFF!")
            peripheralManager.stopAdvertising()
        }
    }
}

// End of BLE Functions Advertising Code   //
