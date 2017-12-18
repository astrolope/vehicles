//
//  FilterViewController.swift
//  CandySearch
//
//  Created by Garrett Criss on 12/17/17.
//  Copyright © 2017 GC. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController {
    
    let instance = SearchState.sharedInstance

    @IBOutlet weak var isAutomatic: UISwitch!
    @IBOutlet weak var hasSunroof: UISwitch!
    @IBOutlet weak var isFourWheelDrive: UISwitch!
    @IBOutlet weak var hasLowMiles: UISwitch!
    @IBOutlet weak var hasPowerWindows: UISwitch!
    @IBOutlet weak var hasNavigation: UISwitch!
    @IBOutlet weak var hasHeatedSeats: UISwitch!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isAutomatic.setOn(instance.isAutomatic, animated: true)
        hasSunroof.setOn(instance.hasSunroof, animated: true)
        isFourWheelDrive.setOn(instance.isFourWheelDrive, animated: true)
        hasLowMiles.setOn(instance.hasLowMiles, animated: true)
        hasPowerWindows.setOn(instance.hasPowerWindows, animated: true)
        hasNavigation.setOn(instance.hasNavigation, animated: true)
        hasHeatedSeats.setOn(instance.hasHeatedSeats, animated: true)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func isAutomatic(_ sender: UISwitch) {
        instance.isAutomatic = sender.isOn
    }
    @IBAction func hasSunroof(_ sender: UISwitch) {
        instance.hasSunroof = sender.isOn
    }
  
    @IBAction func isFourWheelDrive(_ sender: UISwitch) {
        instance.isFourWheelDrive = sender.isOn
    }
   
    @IBAction func hasLowMiles(_ sender: UISwitch) {
        instance.hasLowMiles = sender.isOn
    }
    
    @IBAction func hasPowerWindows(_ sender: UISwitch) {
        instance.hasPowerWindows = sender.isOn
    }
    
    @IBAction func hasNavigation(_ sender: UISwitch) {
        instance.hasNavigation = sender.isOn
    }
 
    @IBAction func hasHeatedSeats(_ sender: UISwitch) {
        instance.hasHeatedSeats = sender.isOn
    }
    
    @IBAction func saveFilters(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
