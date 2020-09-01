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
    @IBOutlet var handshake: UILabel!
    
    let itemsarray = [ "Person A", "Person B", "Person C", "Person D", "Person E", "Person F", "Person G", "Person H", "Person I", "Person J" ]
    
    //  ----  Radar Color ----  //
    let redcolor = [1.0 , 0.0 , 0.0]
    let yellowcolor = [1.0, 1.0, 0.0]
    let greencolor = [0.0 , 1.0, 0.0]
    let bluecolor = [0.0, 0.5, 1.0]
    //     End     //
    
    //  -----  Timer  -----  //
    var bilzTimer: Timer?
    let callTimeInterval = 1.285  // Advertise Interval
    var callTimeCounter = 0.0
    let rssiTimeInterval = 4
    var rssiTimeIntervalCount  = 10
    let scanWindow  = 0.5120
    let scanInterval = 5.12
    let advertiseOnTime = 30.0
    var scanONCount = 5.12
    
    // ---- BLE Scan Time Mode ---- //
    let scanModeLowPowerWindowSec = 0.512
    let scanModeLowPowerIntervalSec = 5.120
    let scanModeBalancedWindowSec = 1.024
    let scanModeBalanceIntervalSec = 4.096
    let scanModeLowLatencyWindowSec = 4.096
    let scanModeLowLatencyIntervalSec = 4.096
    // ----- End ----_ //
    
    //  -----  Timer  -----  //
    var nowTime = Date()
    
    //          End          //
    
    
       
      // let advertiseONInterval = 30
       var advertiseONCounter = 30.0  // Seconds
       //          End          //
       
       // -------  Flags ------- //
       var advertiseFlag = true
       var scanFlag = false
       
       // -------   END --------- //
    
    
    // --- BLE -------//
    var locationManager: CLLocationManager!
    var blePowerON  = true
    var localBeacon: CLBeaconRegion!
    var beaconPeripheralData: NSDictionary!
    var peripheralManager: CBPeripheralManager!
    var localBeaconUUID = "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5"
    let localBeaconUUID_14_Static = "DA57A814-1DEA-DEED-AED1-418A75AD"
    var localBeaconUUID_02_Dynamic = "1000"
    var localIDEAUUID = "DA57A814-1DEA-DEED-AED1-418A75AD1000"
    var localBeaconMajor: CLBeaconMajorValue = 1000
    var localBeaconMinor: CLBeaconMinorValue = 0001
    var identifierBeacon = "Bilz"
    
    var beaconRegionGlobal = CLBeaconRegion(beaconIdentityConstraint: CLBeaconIdentityConstraint(uuid: UUID(uuidString: "DA57A814-1DEA-DEED-AED1-418A75AD1000")!) , identifier: "DA57A814-1DEA-DEED-AED1-418A75AD1000")
    
   
    //let uuid = UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5")!
    let uuidArray = [
                     UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5"),
                     UUID(uuidString: "E2C56DB5-DFFB-48D2-B060-D0F5A71096E0"),
                     UUID(uuidString: "20195610-0000-0000-0000-000000000000"),
                     
                     UUID(uuidString: "DA57A814-1DEA-DEED-AED1-418A75AD1000"),
                     UUID(uuidString: "DA57A814-1DEA-DEED-AED1-418A75AD1001"),
                     UUID(uuidString: "DA57A814-1DEA-DEED-AED1-418A75AD1002"),
                     UUID(uuidString: "DA57A814-1DEA-DEED-AED1-418A75AD1003"),
                     UUID(uuidString: "DA57A814-1DEA-DEED-AED1-418A75AD1004"),
                     UUID(uuidString: "DA57A814-1DEA-DEED-AED1-418A75AD1005"),
                     UUID(uuidString: "DA57A814-1DEA-DEED-AED1-418A75AD1006"),
                     UUID(uuidString: "DA57A814-1DEA-DEED-AED1-418A75AD1007"),
                     UUID(uuidString: "DA57A814-1DEA-DEED-AED1-418A75AD1008"),
                     UUID(uuidString: "DA57A814-1DEA-DEED-AED1-418A75AD1009"),
                     UUID(uuidString: "DA57A814-1DEA-DEED-AED1-418A75AD100A"),
                     UUID(uuidString: "DA57A814-1DEA-DEED-AED1-418A75AD100B"),
                     UUID(uuidString: "DA57A814-1DEA-DEED-AED1-418A75AD100C"),
                     UUID(uuidString: "DA57A814-1DEA-DEED-AED1-418A75AD100D"),
                     UUID(uuidString: "DA57A814-1DEA-DEED-AED1-418A75AD100E"),
                     UUID(uuidString: "DA57A814-1DEA-DEED-AED1-418A75AD100F"),
                     /*
                     UUID(uuidString: "DA57A814-1DEA-DEED-AED1-418A75AD1010"),
                     UUID(uuidString: "DA57A814-1DEA-DEED-AED1-418A75AD1011"),
                     UUID(uuidString: "DA57A814-1DEA-DEED-AED1-418A75AD1012"),
                     UUID(uuidString: "DA57A814-1DEA-DEED-AED1-418A75AD1013"),
                     UUID(uuidString: "DA57A814-1DEA-DEED-AED1-418A75AD1014"),
                     UUID(uuidString: "DA57A814-1DEA-DEED-AED1-418A75AD1015"),
                     UUID(uuidString: "DA57A814-1DEA-DEED-AED1-418A75AD1016"),
                     UUID(uuidString: "DA57A814-1DEA-DEED-AED1-418A75AD1017"),
                     UUID(uuidString: "DA57A814-1DEA-DEED-AED1-418A75AD1018"),
                     UUID(uuidString: "DA57A814-1DEA-DEED-AED1-418A75AD1019"),
                     UUID(uuidString: "DA57A814-1DEA-DEED-AED1-418A75AD101A"),
                     UUID(uuidString: "DA57A814-1DEA-DEED-AED1-418A75AD101B"),
                     UUID(uuidString: "DA57A814-1DEA-DEED-AED1-418A75AD101C"),
                     UUID(uuidString: "DA57A814-1DEA-DEED-AED1-418A75AD101D"),
                     UUID(uuidString: "DA57A814-1DEA-DEED-AED1-418A75AD101E"),
                     UUID(uuidString: "DA57A814-1DEA-DEED-AED1-418A75AD101F"),
                     */
                     UUID(uuidString: "DA57A814-1DEA-DEED-AED1-418A75AD1111")
                    ]
    let scanningUUIDArray = (1000...2999).map{UUID(uuidString: "DA57A814-1DEA-DEED-AED1-418A75AD\($0)")}
    //var scanningUUIDArrayDynamic = (0...9).map{"DA57A814-1DEA-DEED-AED1-418A75AD00D\($0)"}
    //var UUIDArray000A_F = ("A"..."F").map{"DA57A814-1DEA-DEED-AED1-418A75AD000\($0)"}
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
    var optimal_RSSI = -99
    var optimal_RSSI_Arr = [0, -99, -99, -99, -99, -99]
    var optimal_RSSI_Index = Int(1)
    var optimal_Distance = 0.0
    var tradition_Distance = 0.0
    var IDEA_Distance = 0.0
    var optimal_IDEA_Distance_arr = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
    var n_coeff_IDEA_Distance_arr = [1.8, 2.0, 2.2 ,2.4 ,2.6, 2.8, 3.0, 4.0, 4.2]
    var opt_DistanceRange = [99.0, 0.0, 0.0, 0.0]
    var txCalibratedPower = -59//-50  //-59 Default
    var optimal_IDEA_Multi_Distances_Str = ""
    //                  END                  //
    
    //  ----- Custom Alert  -----  //
    let distanceAlert = MyAlert()
    var distanceAlertFlag = false
    //            END              //
    
    //  ----- Motion & Motion Manager  ------  //
    let motion = CMMotionManager()
    let motionManager = CMMotionManager()
    var deviceMotionStatus = "Static"
    var deviceMotionStatusOther = "Static"
    
    let DYNAMIC = 1
    let STATIC = 0
    
    var acc_int_tol = 2
    
      var acc_raw_x = 0.0
      var acc_raw_y = 0.0
      var acc_raw_z = 0.0
      
      var acc_use_x = 0.0
      var acc_use_y = 0.0
      var acc_use_z = 0.0
      
      var acc_int_x = 0
      var acc_int_y = 0
      var acc_int_z = 0
      
      var acc_origin_x = 99
      var acc_origin_y = 99
      var acc_origin_z = 99

      var acc_last_x = 0
      var acc_last_y = 0
      var acc_last_z = 0
      
      var acc_cur_x = 1
      var acc_cur_y = 1
      var acc_cur_z = 1
      
      var acc_next_x = 2
      var acc_next_y = 2
      var acc_next_z = 2
      
      var acc_diff_x = 0
      var acc_diff_y = 0
      var acc_diff_z = 0
      
      var acc_display_x = 0
      var acc_display_y = 0
      var acc_display_z = 0
    
      var mag_int_tol = 2
    
      var mag_raw_x = 0.0
      var mag_raw_y = 0.0
      var mag_raw_z = 0.0
      
      var mag_use_x = 0.0
      var mag_use_y = 0.0
      var mag_use_z = 0.0
      
      var mag_int_x = 0
      var mag_int_y = 0
      var mag_int_z = 0
      
      var mag_origin_x = 99
      var mag_origin_y = 99
      var mag_origin_z = 99

      var mag_last_x = 0
      var mag_last_y = 0
      var mag_last_z = 0
      
      var mag_cur_x = 1
      var mag_cur_y = 1
      var mag_cur_z = 1
      
      var mag_next_x = 2
      var mag_next_y = 2
      var mag_next_z = 2
      
      var mag_diff_x = 0
      var mag_diff_y = 0
      var mag_diff_z = 0
      
      var mag_display_x = 0
      var mag_display_y = 0
      var mag_display_z = 0
    
      
      
      var xyzArray = [Int(0),Int(0),Int(0),Int(0)]
      var xyzCG_initial = [Int(0),Int(0),Int(0),Int(0)]
      var xyzGG_final = [Int(0),Int(0),Int(0),Int(0)]
      
    //                  END                    //
    

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
            handshake?.text = "Handshake Count: nil"
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Display the UUID, major, and minor for each beacon.
        let sectionkey = Array(beacons.keys)[indexPath.section]
        let beacon = beacons[sectionkey]![indexPath.row]
    
        let major = String(format:"%02X", beacon.major)
        let minor = String(format:"%02X", beacon.minor)
        
        let uuidParameterStr = beacon.uuid.uuidString;
       
        let distanceOtherDevice = extractDataFromUUID(uuidParameter: uuidParameterStr)
        let motionOtherDevice = deviceMotionStatusOther
        //let distance = beacon.accuracy
        optimal_RSSI = get_Optimal_RSSI(optimal_rssi: optimal_RSSI, beacon_rssi: beacon.rssi, deviceMotionOtherDevice: motionOtherDevice)
        
        computeMultiDistances()
        
        if (optimal_RSSI<txCalibratedPower)
        {
            n_coeff = n_coeff_max
        }
        else
        {
            n_coeff = n_coeff_min
        }
       // let distance = get_IDEA_Distance(txCalibratedPower: -59, rssi: optimal_RSSI, n: n_coeff)
        let distance_RSSI = getDistance_RSSI(txCalibratedPower: -59, rssi: optimal_RSSI)
        let distanceiBeacon = beacon.accuracy
        let distanceTradition = getDistance_RSSI(txCalibratedPower: -59, rssi: beacon.rssi)
        let distance = get_Optimal_Distance(SDD: distance_RSSI, ODD: distanceOtherDevice)
        
        
        let distanceStr = String(format: "%.2f", distance)
        let distanceiBeaconStr = String(format: "%.2f", distanceiBeacon)
        let distanceTraditionStr = String(format: "%.2f", distanceTradition)
    
        
        /*
        IDEA_ID.append(major)
        IDEA_ID.append("-1DEA-")
        IDEA_ID.append(minor)
        */
        IDEA_ID = generate_IDEA_ID(major: major, minor: minor, other: "Bilz")

        //let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
      
        let customCell = tableView.dequeueReusableCell(withIdentifier: MyTableViewCell.identifier, for: indexPath) as! MyTableViewCell
        customCell.configure(with: "UUID: \(beacon.uuid)", with: "CONTACT ID: \(IDEA_ID)", with: "d1: \(distanceiBeaconStr) m, d2: \(distanceTraditionStr) m and ODMS: \(motionOtherDevice)", with: "RSSI: \(optimal_RSSI)", with: "uRSSI: \(beacon.rssi)", with: "d =  \(distanceStr) m", with: "Device: \(deviceMotionStatus)", imageName: UIImage(named: "BLE.png")!)
        handshake?.text = "Handshaking : \(beacons.count)"
        IDEA_ID = ""
        
        if (Int(beacon.minor) == (localBeaconMinor))
        {
            localBeaconMinor = CLBeaconMinorValue(Int(beacon.minor) + 1 )
        }
        
        // call function here
       
        
        localIDEAUUID = updateUUID(distance: distance)
        print("IDEAUUID : ",localIDEAUUID)
        
        
     
        if  distance < 1.0
        {
            if distanceAlertFlag != false
            {
                distanceAlert.showAlert(with: "WARNING !!!", message: "Social Distancing Rule is violeted !!!", on: self)
                distanceAlertFlag = true
            }
            
            rSlider.value = Float(redcolor[0])
            gSlider.value = Float(redcolor[1])
            bSlider.value = Float(redcolor[2])
            colorChanged(sender: nil)
        }
        else if distance < 2.0 && distance > 1.0
        {
            if distanceAlertFlag == true
            {
                distanceAlert.dismissAlert()
                distanceAlertFlag = false
            }
            
            rSlider.value = Float(yellowcolor[0])
            gSlider.value = Float(distance - 1.0)
            bSlider.value = Float(yellowcolor[2])
            colorChanged(sender: nil)
        }
        else
        {
            if distanceAlertFlag == true
            {
                distanceAlert.dismissAlert()
                distanceAlertFlag = false
            }
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
        
        for uui in uuidArray//scanningUUIDArray
        {
            let constraint = CLBeaconIdentityConstraint(uuid: uui!)
            self.beaconConstraints[constraint] = []
           // let beaconRegion
            beaconRegionGlobal = CLBeaconRegion(beaconIdentityConstraint: constraint , identifier: uui!.uuidString)
            locationManager.startMonitoring(for: beaconRegionGlobal)
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
        
        print("\nBroadcast IDEA UUID :",localIDEAUUID)
        if (localIDEAUUID == nil)
        {
            localIDEAUUID = localBeaconUUID
        }
        let uuid = UUID(uuidString: localIDEAUUID)!
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
           // print("BLE Powered ON!")
            peripheralManager.startAdvertising(beaconPeripheralData as? [String: Any])
        }
        else if peripheral.state == .poweredOff {
           // print("BLE Powered OFF!")
            peripheralManager.stopAdvertising()
        }
    }
}

// End of BLE Functions Advertising Code   //


// WD Timer //
extension ViewController
{
    @objc func runEveryTime()
       {
        
        
        
        
        
        /*
           startLocalBeacon()
           nowTime = Date()
           //print("One Second Called at ")
           //print("IDEA ID: ",generate_IDEA_ID(major: "2019", minor: "5610", other: ""))
          // print(nowTime)
         //  print("\nBroadcast IDEA UUID :",localIDEAUUID)
        
           if isDeviceMove()==false
           {
               // Do Something here
           }
           else
           {
               // Do Something here
           }
        */
       }
}


//





extension ViewController
{
   
    func generate_IDEA_ID(major: String, minor: String, other: String)-> String
    {
        /*
         let date = Date()

         // MARK: Way 1

         let components = date.get(.day, .month, .year)
         if let day = components.day, let month = components.month, let year = components.year {
             print("day: \(day), month: \(month), year: \(year)")
         }
         
         let formatter = DateFormatter()
         formatter.dateFormat = "hh a" // "a" prints "pm" or "am"
         let hourString = formatter.string(from: Date()) // "12 AM"
         */ /*UUID333-Major-83167-Minor55*/
        
        let nowDate = Date()
        var local_IDEA_ID = "1DEA-"
        //let local_Major = String(format:"%02X", major)
        //let local_Minor = String(format:"%02X", minor)
        let local_Major = major
        let local_Minor = minor
        let local_Time  = String(format:"%02X", Date() as CVarArg)
        let components = nowDate.get(.day, .month, .year)
        let local_Year = String(nowDate.get(.year))
        let local_Month = String(nowDate.get(.month))
        let local_Day = String(nowDate.get(.day))
        let formatter = DateFormatter()
        formatter.dateFormat = "hh a" // "a" prints "pm" or "am"
        let local_Hour2 = formatter.string(from: Date()) // "12 AM"
        
        let local_Hour = String(Calendar.current.component(.hour, from: Date()))
        
        local_IDEA_ID.append(local_Major)
        local_IDEA_ID.append("-")
        local_IDEA_ID.append(local_Minor)
        local_IDEA_ID.append("-")
        local_IDEA_ID.append(local_Year)
        //local_IDEA_ID.append("-")
        local_IDEA_ID.append(local_Month)
        //local_IDEA_ID.append("-")
        local_IDEA_ID.append(local_Day)
        local_IDEA_ID.append("-")
        //local_IDEA_ID.append(local_Hour2)
        //local_IDEA_ID.append("-")
        local_IDEA_ID.append(local_Hour)
        //local_IDEA_ID.append("-")
        //local_IDEA_ID.append(other)
      //  print("Local Time: ",local_Time)
      //  print("Local IDEA ID: ",local_IDEA_ID)
        return local_IDEA_ID
    }
    
    func getDistance_RSSI(txCalibratedPower: Int, rssi: Int) -> Double
    {
        if rssi == 0 {
            return -1
        }
        if (rssi < txCalibratedPower)
        {
            n_coeff = 2.2
            let delta_rssi = Double(txCalibratedPower - rssi)
            let accuracy = Double(pow(10.0,Double((delta_rssi)/(10.0 * n_coeff))))
            return accuracy
        }
        else{
            n_coeff = 2.2
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
         //let distance = Double(pow(10.0,Double((delta_rssi-delta_pl)/(10.0 * opt_n_coeff))))
         let distance = Double(pow(10.0,Double((delta_rssi)/(10.0 * opt_n_coeff))))
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

extension Date {
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }

    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
}


extension ViewController
{
    
    @objc func dismissAlert()
    {
        distanceAlert.dismissAlert()
    }
}

class MyAlert
{
    struct Constants
    {
        static let backgroundAlphaTo: CGFloat = 0.6
    }
    
    private let backgroundView: UIView =
    {
        let backgroundView = UIView()
        backgroundView.backgroundColor = .red
        backgroundView.alpha = 0
        return backgroundView
        
    }()
    
    private let alertView:UIView  =
    {
        let alert = UIView()
        alert.backgroundColor = .white
        alert.layer.masksToBounds = true
        alert.layer.cornerRadius = 12
        return alert
    }()
    
    private var mytargetView: UIView?
    
    func showAlert(with title: String, message: String, on ViewController: UIViewController)
    {
        guard let targetView = ViewController.view else { return }
        mytargetView = targetView
        
        backgroundView.frame = targetView.bounds
        targetView.addSubview(backgroundView)
        targetView.addSubview(alertView)
        alertView.frame = CGRect(x: 40, y: -300, width: targetView.frame.size.width-80, height: 300)
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: alertView.frame.size.width, height: 80))
        titleLabel.text = title
        titleLabel.textAlignment = .center
        alertView.addSubview(titleLabel)
        
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 80, width: alertView.frame.size.width, height: 170))
        messageLabel.numberOfLines = 0
        messageLabel.text = message
        messageLabel.textAlignment = .left
        alertView.addSubview(messageLabel)
        
        let button = UIButton(frame: CGRect(x: 0, y: alertView.frame.size.height-50, width: alertView.frame.size.width, height: 50))
        
        button.setTitle("Dismiss", for: .normal)
        button.setTitleColor(.link, for: .normal)
        button.addTarget(self, action: #selector(dismissAlert), for: .touchUpInside)
        alertView.addSubview(button)
        UIView.animate(withDuration: 0.25, animations: {self.backgroundView.alpha = Constants.backgroundAlphaTo}, completion:
            {
                done in if done
                {
                    UIView.animate(withDuration: 0.25, animations: {self.alertView.center = targetView.center})
                }
        })
        
    }
    
    @objc func dismissAlert()
    {
        guard let targetView = mytargetView else { return }
        UIView.animate(withDuration: 0.25, animations: {self.alertView.frame = CGRect(x: 40, y: targetView.frame.size.height, width: targetView.frame.size.width-80, height: 300)}, completion:
            {
                done in if done
                {
                    UIView.animate(withDuration: 0.25, animations: {self.backgroundView.alpha = 0}, completion: {done in if done {self.alertView.removeFromSuperview()
                        self.backgroundView.removeFromSuperview()
                        } })
                }
        })
    }
    
}




extension ViewController
{
    /*
Input: OR, BR, SDMS,ODMS
Output: OR or BR
Function Get Optimal RSSI
begin
   if BR is Zero
       return OR
   else
   begin
       if SDMS & ODMS are Static
       begin
          if OR is greater BR
             return OR
         else
             return BR
       end
       else
          return BR
   end
end
    */
    func get_Optimal_RSSI(optimal_rssi: Int, beacon_rssi: Int, deviceMotionOtherDevice: String)->(Int)
    {

        if beacon_rssi == 0
        {
            return optimal_rssi
        }
        //if isDeviceMove() == false
        else
        {
            if deviceMotionStatus == "Static" && deviceMotionOtherDevice == "Static"
            {
                //deviceMotion = "The device is Static"
                if optimal_rssi > beacon_rssi
                {
                    return optimal_rssi
                }
                else
                {
                    return beacon_rssi
                }
            }
            else
            {
                //deviceMotion = "The device is Dynamic"
                return beacon_rssi
            }
        }
        /*
        if rssiTimeIntervalCount > 0
        {
            rssiTimeIntervalCount = rssiTimeIntervalCount - 1
        }
        else
        {
            rssiTimeIntervalCount = rssiTimeInterval
            return beacon_rssi
        }
        return optimal_rssi*/
    }
    
    func computeMultiDistances()
    {

        let array_size = optimal_IDEA_Distance_arr.count
        while index < array_size
        {
            optimal_IDEA_Distance_arr[index] = get_IDEA_Distance(txCalibratedPower: txCalibratedPower, rssi: optimal_RSSI, n: n_coeff_IDEA_Distance_arr[index])
            optimal_IDEA_Multi_Distances_Str.append(String (format: "%.2f, ", optimal_IDEA_Distance_arr[index]))
            //print(optimal_IDEA_Multi_Distances_Str)
            index = index + 1
        }
        
        
        
        /*
        while indexDouble < n_coeff_max {
            
            //print(n_coeff_arr)
            //optimal_Distance_arr[index] = get_BJ_Distance(txCalibratedPower: txCalibratedPower, rssi: optimal_RSSI, n: n_coeff_arr[index])
            if optimal_RSSI != 0{
                optimal_Distance =  get_IDEA_Distance(txCalibratedPower: txCalibratedPower, rssi: optimal_RSSI, n: indexDouble)
            }
            if opt_DistanceRange[0] > optimal_Distance{
                opt_DistanceRange[0] = optimal_Distance
                opt_DistanceRange[1] = indexDouble
            }
            if opt_DistanceRange[2] < optimal_Distance{
                opt_DistanceRange[2] = optimal_Distance
                opt_DistanceRange[3] = indexDouble
            }
            
           // opt_DistanceRange[1] = (opt_DistanceRange[0] + opt_DistanceRange[2])/2
            //remarksStr.append(String (format: "%.2f, ", optimal_Distance_arr[index]))
            //print(remarksStr)
            //index = index + 1
            indexDouble = indexDouble + 0.1
        
        }
        indexDouble = n_coeff_min
 */
    }
    
    func isDeviceMove()-> Bool
    {
        
        if self.motion.isAccelerometerAvailable {
            self.motion.accelerometerUpdateInterval = 1.0 / 60.0  // 60 Hz
            self.motion.startAccelerometerUpdates()
            
        }
         
          
           
           if let xValue = motion.accelerometerData?.acceleration.x {
               acc_raw_x = xValue
           }
           if let yValue = motion.accelerometerData?.acceleration.y {
               acc_raw_y = yValue
           }
           if let zValue = motion.accelerometerData?.acceleration.z {
               acc_raw_z = zValue
           }
           
        
           
           
           acc_use_x = (acc_raw_x * 100)
           acc_use_y = (acc_raw_y * 100)
           acc_use_z = (acc_raw_z * 100)
           
          
           
           acc_int_x = Int(acc_use_x)
           acc_int_y = Int(acc_use_y)
           acc_int_z = Int(acc_use_z)
           
        
           
           acc_diff_x = abs(acc_cur_x-acc_int_x)
           acc_diff_y = abs(acc_cur_y-acc_int_y)
           acc_diff_z = abs(acc_cur_z-acc_int_z)
        
           if acc_diff_x  < acc_int_tol {
                 //  print("Status:  Static at X ")
                   xyzArray[0] = 0
                   acc_display_x = acc_cur_x
           }
           else{
                //  print("Status:  Dynamic at X ")
                  xyzArray[0] = 1
                  acc_last_x = acc_cur_x
                  acc_display_x = acc_cur_x
                  acc_cur_x  = acc_int_x
           }
             //  print("Difference of Y = ",acc_diff_y)
            //   print("acc_display_y = ",acc_display_y)
            //   print("acc_cur_y = ",acc_cur_y)
             //  print("acc_int_y = ", acc_int_y)
           if acc_diff_y  < acc_int_tol {
                  // print("Status:  Static at Y ")
                   xyzArray[1] = 0
                   acc_display_y = acc_cur_y
           }
           else{
                 //  print("Status:  Dynamic at Y ")
                   xyzArray[1] = 1
                  acc_last_y = acc_cur_y
                  acc_display_y = acc_cur_y
                  acc_cur_y  = acc_int_y
           }
           //    print("Difference of Z = ",acc_diff_z)
            //   print("acc_display_z = ",acc_display_z)
            //   print("acc_cur_z = ",acc_cur_z)
            //   print("acc_int_z = ", acc_int_z)
           if acc_diff_z  < acc_int_tol {
                   //print("Status:  Static at Z ")
                   xyzArray[2] = 0
                   acc_display_z = acc_cur_z
                   
           }
           else{
                  // print("Status:  Dynamic at Z ")
                   xyzArray[2] = 1
                  acc_last_z = acc_cur_z
                  acc_display_z = acc_cur_z
                  acc_cur_z  = acc_int_z
                  
           }
           xyzArray[3] = xyzArray[0]+xyzArray[1]+xyzArray[2]
           if xyzArray[3] == STATIC {
               deviceMotionStatus = "Static"
             //  print(deviceMotionStatus)
               return false
           }
           else{
               deviceMotionStatus = "Dynamic"
             //  print(deviceMotionStatus)
               return true
           }
        
        
    }
    
    func getNoise() -> Double{
        
        if motionManager.isMagnetometerAvailable {
            motionManager.magnetometerUpdateInterval = 0.1
            motionManager.startMagnetometerUpdates(to: OperationQueue.main) { (data, error) in
                //print(data)
            }
        }
        if let xValue = motionManager.magnetometerData?.magneticField.x {
            mag_raw_x = xValue
        }
        if let yValue = motionManager.magnetometerData?.magneticField.y {
            mag_raw_y = yValue
        }
        if let zValue = motionManager.magnetometerData?.magneticField.z {
            mag_raw_z = zValue
        }
        print(mag_raw_x)
        mag_display_x = Int(mag_raw_x)
        mag_display_y = Int(mag_raw_y)
        mag_display_z = Int(mag_raw_z)
        print(" Mag X : ")
        print(mag_display_x)
        print(" Mag Y : ")
        print(mag_display_y)
        print(" Mag Z : ")
        print(mag_display_z)
        mag_use_x = (mag_raw_x * 100)
        mag_use_y = (mag_raw_y * 100)
        mag_use_z = (mag_raw_z * 100)
        
        mag_int_x = Int(mag_use_x)
        mag_int_y = Int(mag_use_y)
        mag_int_z = Int(mag_use_z)
       
        mag_diff_x = abs(mag_cur_x-acc_int_x)
        mag_diff_y = abs(mag_cur_y-acc_int_y)
        mag_diff_z = abs(mag_cur_z-acc_int_z)
        
        let noise = 0.0
        return noise
    }
}


extension ViewController
{
    
    func updateUUID (distance: Double)-> String
    {
        var UUID_Str = ""
        UUID_Str.append(localBeaconUUID_14_Static)
        UUID_Str.append("100")
        let distanceHex = Int(distance*4.0)
        if (distanceHex>=0 && distanceHex<9)
        {
            //localIDEAUUID = ""
            if deviceMotionStatus == "Static"
            {
                UUID_Str.append(String(distanceHex))
                
            }
            else
            {
                switch distanceHex
                {
                    case 0:
                        UUID_Str.append("A")
                    case 1:
                        UUID_Str.append("B")
                    case 2:
                        UUID_Str.append("C")
                    case 3:
                        UUID_Str.append("D")
                    case 4:
                        UUID_Str.append("E")
                    case 5:
                        UUID_Str.append("F")
                    
                    default:
                        UUID_Str.append("0")
                }
                //UUID_Str.append("100")
            }
           // print("IDEAUUID (Before Ammendment): ",UUID_Str)
          //  let mDig = getDistanceMeter(distance: distance)
           // let cmDig = getDistanceCentiMeter(distance: distance)
           // print("Distance is ",mDig," m")
           // print("and ",cmDig," cm")
           /*
            if distance < 9.0
            {
                UUID_Str.append(mDig)
            }
            else
            {
                //print("Double Digit Detected !!! mDig = ",mDig)
                UUID_Str.append("F")
            }
            */
            
        }
        else
        {
            UUID_Str.append("9")
            
        }
        return UUID_Str
    }
    func getDistanceMeter (distance:Double)-> String
    {
        //print("Inside getDistanceMeter d : ",distance)
        return String(Int(distance))
    }
    
    func getDistanceCentiMeter (distance:Double)-> String
    {
        var dcm = 0
        print("Inside getDistanceCentiMeter d : ",distance)
        if (distance<1.0)
        {
            dcm = (Int (distance * 100.0))
            
        }
        else
        {
            let dr =  (distance*100.0) - (Double(Int(distance)) * 100)
            print("dr : ",dr)
            dcm = Int(dr)
            
        }
        if (dcm > 9)
        {
            print("dcm : ",dcm)
            return String (dcm)
        }
        else
        {
            let dcma = "0"+String(dcm)
            print("dcma : ",dcma)
            return dcma
        }
    }
}


extension ViewController
{
    func extractDataFromUUID(uuidParameter: String)->Double
    {
        let uuidParameterLast = uuidParameter.last;
        var distanceOther = 0.0
        print("UUID Parameter Extracted : ", uuidParameterLast)
        switch uuidParameterLast
        {
            case "0":
            deviceMotionStatusOther = "Static"
            distanceOther = 0.0
            case "1":
            deviceMotionStatusOther = "Static"
            distanceOther = 0.25
            case "2":
            deviceMotionStatusOther = "Static"
            distanceOther = 0.50
            case "3":
            deviceMotionStatusOther = "Static"
            distanceOther = 0.75
            case "4":
            deviceMotionStatusOther = "Static"
            distanceOther = 1.0
            case "5":
            deviceMotionStatusOther = "Static"
            distanceOther = 1.25
            case "6":
            deviceMotionStatusOther = "Static"
            distanceOther = 1.50
            case "7":
            deviceMotionStatusOther = "Static"
            distanceOther = 1.75
            case "8":
            deviceMotionStatusOther = "Static"
            distanceOther = 2.00
            case "9":
            deviceMotionStatusOther = "Static"
            distanceOther = -1
            
            case "A":
            deviceMotionStatusOther = "Dynamic"
            distanceOther = 0.0
            case "B":
            deviceMotionStatusOther = "Dynamic"
            distanceOther = 0.5
            case "C":
            deviceMotionStatusOther = "Dynamic"
            distanceOther = 1.0
            case "D":
            deviceMotionStatusOther = "Dynamic"
            distanceOther = 1.5
            case "E":
            deviceMotionStatusOther = "Dynamic"
            distanceOther = 2.0
            case "F":
            deviceMotionStatusOther = "Dynamic"
            distanceOther = 2.5
            
            default:
            deviceMotionStatusOther = "Unknown"
            distanceOther = -1.0
        }
        return distanceOther
    }
    
    /*
     Input: SDD, ODD,
     Output: SDD or ODD
     Function Get Optimal Distance
     begin
        if ODD is greater than zero
        begin
            if SDD is lower than ODD
                 return SDD
            else SDD is greater than ODD
                 return ODD
        end
        else
            return SDD
     end
     */
    func get_Optimal_Distance(SDD: Double, ODD: Double)->(Double)
    {
        if ODD>0
        {
            if SDD < ODD
            {
                return SDD
            }
            else
            {
                return ODD
            }
        }
        else
        {
            return SDD
        }
        
    }
}


extension ViewController
{
    func startAdvestisment()
    {
        startLocalBeacon()
    }
    func stopAdvertisement()
    {
        stopLocalBeacon()
    }
    func startScanner()
    {
        locationManager.startMonitoring(for: beaconRegionGlobal)
    }
    func stopScanner()
    {
        locationManager.stopMonitoring(for: beaconRegionGlobal)
    }
}
