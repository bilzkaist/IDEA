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
    @IBOutlet var HeadingText: UITextView!
    @IBOutlet var SubHeadingText: UITextView!
    @IBOutlet var handshake: UITextView!
    
    let itemsarray = [ "Person A", "Person B", "Person C", "Person D", "Person E", "Person F", "Person G", "Person H", "Person I", "Person J" ]
    
    //  ----  Radar Color ----  //
    let redcolor = [1.0 , 0.0 , 0.0]
    let yellowcolor = [1.0, 1.0, 0.0]
    let greencolor = [0.0 , 1.0, 0.0]
    let bluecolor = [0.0, 0.5, 1.0]
    //     End     //
    
    //  -----  Timer  -----  //
    var bilzTimer: Timer?
    let callTimeInterval = 1.0
    let rssiTimeInterval = 4
    var rssiTimeIntervalCount  = 10
    //          End          //
    
    //  -----  Timer  -----  //
    var nowTime = Date()
    
    //          End          //
    
    
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
    let uuidArray = [UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5"),UUID(uuidString: "E2C56DB5-DFFB-48D2-B060-D0F5A71096E0"),UUID(uuidString:                                              "20195610-0000-0000-0000-000000000000")]
    var beaconConstraints = [CLBeaconIdentityConstraint: [CLBeacon]]()
    var beacons = [CLProximity: [CLBeacon]]()
    
    var IDEA_ID = ""
    
    //     END        //
    
    //  ----- IDEA Distance Variables -----  //
    let n_coeff_min = 1.8
    let n_coeff_max = 4.3
    var index = 0
    var indexDouble = 1.8
    var ratio_factor = 1.0
    var n_coeff = 2.0
    var pathLossFactor = 0.0
    //                  END                  //
    
    //  ----- Notification  -----  //
    
    //            END              //
    
    

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
        tableView.register(MyTableViewCell.nib(), forCellReuseIdentifier: MyTableViewCell.identifier)
        tableView.layer.borderWidth = 2
        tableView.layer.borderColor = UIColor.blue.cgColor
        tableView.delegate = self
        tableView.dataSource = self
    
        
        // BLE Scanning
        startScanning()
        
        // Timer Start
        bilzTimer = Timer.scheduledTimer(timeInterval: callTimeInterval, target: self, selector: #selector(runEveryTime), userInfo: nil, repeats: true)
        
        
    
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
            rSlider.value = Float(greencolor[0])
            gSlider.value = Float(greencolor[1])
            bSlider.value = Float(greencolor[2])
            print(rSlider.value)
            print(gSlider.value)
            print(bSlider.value)
            colorChanged(sender: nil)
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
        
        /*
        rSlider.value = 0
        gSlider.value = 0.455
        bSlider.value = 0.756
         */
        rSlider.value = Float(greencolor[0])
        gSlider.value = Float(greencolor[1])
        bSlider.value = Float(greencolor[2])
        
        
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
    

    // iBeacon Ranging
  
    func numberOfSections(in tableView: UITableView) -> Int {
        //print("Beacons Count: ",beacons.count)
        if (beacons.count == 0)
        {
            rSlider.value = Float(greencolor[0])
            gSlider.value = Float(greencolor[1])
            bSlider.value = Float(greencolor[2])
            colorChanged(sender: nil)
        }
        else
        {
            rSlider.value = Float(bluecolor[0])
            gSlider.value = Float(bluecolor[1])
            bSlider.value = Float(bluecolor[2])
            colorChanged(sender: nil)
        }
        return beacons.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Array(beacons.values)[section].count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Display the UUID, major, and minor for each beacon.
        let sectionkey = Array(beacons.keys)[indexPath.section]
        let beacon = beacons[sectionkey]![indexPath.row]
    
        let major = String(format:"%02X", beacon.major)
        let minor = String(format:"%02X", beacon.minor)
        
        
        //let distance = beacon.accuracy
        let distance = get_IDEA_Distance(txCalibratedPower: -59, rssi: beacon.rssi, n: 2.2)
        
        let distanceStr = String(format: "%.2f", distance)
    
        IDEA_ID.append(major)
        IDEA_ID.append("-1DEA-")
        IDEA_ID.append(minor)

        //let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let customCell = tableView.dequeueReusableCell(withIdentifier: MyTableViewCell.identifier, for: indexPath) as! MyTableViewCell
        customCell.configure(with: "UUID: \(beacon.uuid)", with: "IDEA ID: \(IDEA_ID)", with: "ID Detail: Major:  \(beacon.major) & Minor: \(beacon.minor)", with: "RSSI: \(beacon.rssi)", with: "d =  \(distanceStr) m", with: "Near", imageName: "gear")
        IDEA_ID = ""
        if  distance < 1.0
        {
            rSlider.value = Float(redcolor[0])
            gSlider.value = Float(redcolor[1])
            bSlider.value = Float(redcolor[2])
            colorChanged(sender: nil)
        }
        else if distance < 2.0 && distance > 1.0
        {
            rSlider.value = Float(yellowcolor[0])
            gSlider.value = Float(distance - 1.0)
            bSlider.value = Float(yellowcolor[2])
            colorChanged(sender: nil)
        }
        else
        {
            rSlider.value = Float(bluecolor[0])
            gSlider.value = Float(bluecolor[1])
            bSlider.value = Float(bluecolor[2])
            colorChanged(sender: nil)
        }
        
        
        return customCell

    }
 
    
    // BLE Functions Scanning Code   //
    
    func startScanning()
    {
        //print("Started Scanning !!!")
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


extension ViewController
{
    @objc func runEveryTime()
    {
        nowTime = Date()
        print("One Second Called at ")
        print("IDEA ID: ",generate_IDEA_ID(with: 2019, with: 5610, with: ""))
        print(nowTime)
    }
    
    func generate_IDEA_ID(with major: Int, with minor: Int, with other: String)-> String
    {
        var local_IDEA_ID = "1DEA-"
        let local_Major = String(format:"%02X", major)
        let local_Minor = String(format:"%02X", minor)
        let local_Time  = String(format:"%02X", Date() as CVarArg)
        
        local_IDEA_ID.append(local_Major)
        local_IDEA_ID.append("-")
        local_IDEA_ID.append(local_Minor)
        local_IDEA_ID.append("-")
        local_IDEA_ID.append(local_Time)
        print("Local Time: ",local_Time)
        print("Local IDEA ID: ",local_IDEA_ID)
        return local_IDEA_ID
    }
    
    func getDistance_RSSI(txCalibratedPower: Int, rssi: Int) -> Double
    {
        if rssi == 0 {
            return -1
        }
        if (rssi < txCalibratedPower)
        {
            n_coeff = 2.0
            let delta_rssi = Double(txCalibratedPower - rssi)
            let accuracy = Double(pow(10.0,Double((delta_rssi)/(10.0 * n_coeff))))
            return accuracy
        }
        else{
            n_coeff = 2.0
            let delta_rssi = Double(txCalibratedPower - rssi)
            let accuracy = Double(pow(10.0,Double((delta_rssi)/(10.0 * n_coeff))))
            return (accuracy * n_coeff)
        }
    }
    
    // PL  = PLo + 10nLog10.RSSI
     // d   = 10power[(CalibratedPower - RSSI - (PLo - PL))/10n]
    func get_IDEA_Distance(txCalibratedPower: Int, rssi: Int, n: Double) -> Double
    {
        if rssi == 0
        {
            return -1
        }
        let opt_n_coeff = n
        let delta_rssi = Double(txCalibratedPower - rssi)
         ratio_factor = Double(Double(rssi)/Double(txCalibratedPower))
      /*   if txCalibratedPower > rssi
         {
             ratio_factor = Double(log(pow(delta_rssi,((delta_rssi/10) + 1))))
         }
         if txCalibratedPower <= rssi {
             ratio_factor = 1
         }
         */
         let plo = 40.0
       //  print(ratio_factor)
         let pl = Double(plo + (10 * n_coeff * log(Double(ratio_factor))))
        // print(pl)
         let delta_pl = Double(plo - pl)
         pathLossFactor = ratio_factor//(1.0 + delta_pl/plo)
         let distance = Double(pow(10.0,Double((delta_rssi-delta_pl)/(10.0 * opt_n_coeff))))
         /*
         if txCalibratedPower > rssi{
             let accuracy = Double(pow(10.0,Double((delta_rssi)/(10.0 * opt_n_coeff))) + 0.1*ratio_factor)
             return accuracy
         }
         else
         {
             let accuracy = Double(pow(10.0,Double((delta_rssi)/(10.0 * opt_n_coeff))))
             return accuracy
         }
         */
         return distance
         
     }
}


