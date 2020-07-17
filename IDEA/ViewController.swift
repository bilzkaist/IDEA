//
//  ViewController.swift
//  IDEA
//
//  Created by Bilal Dastagir on 2020/07/15.
//  Copyright © 2020 Bilal Dastagir. All rights reserved.
//


import UIKit

let kMaxRadius: CGFloat = 200
let kMaxDuration: TimeInterval = 10

class ViewController: UIViewController {

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
    
    let itemsarray = [ "Person A", "Person B", "Person C", "Person D", "Person E"]
    //     End     //
    

    let pulsator = Pulsator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sourceView.layer.superlayer?.insertSublayer(pulsator, below: sourceView.layer)
        setupInitialValues()
        pulsator.start()
        
        tableView.layer.borderWidth = 2
        tableView.layer.borderColor = UIColor.blue.cgColor
        tableView.delegate = self
        tableView.dataSource = self
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
        }
        else {
            pulsator.stop()
        }
    }
}


extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You Tapped Me! ")
    }
}


extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsarray.count
    }
    
    // Section 1 -> Row 1
    // Section 2 -> Row 1
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = itemsarray[indexPath.row]
        return cell
    }
    
    
}
