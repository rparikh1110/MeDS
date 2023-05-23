//
//  MedicationOptionViewController.swift
//  MeDS
//
//  
//

import UIKit

class MedicationOptionViewController: UIViewController {
    
// sets four medications as buttons
    @IBOutlet weak var btnNurtec: UIButton!
    @IBOutlet weak var btnAmoxicillin: UIButton!
    @IBOutlet weak var btnAdderall: UIButton!
    @IBOutlet weak var btnHydrocodone: UIButton!
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //rounds medication buttons
        self.btnNurtec.layer.cornerRadius = 8
        self.btnAmoxicillin.layer.cornerRadius = 8
        self.btnAdderall.layer.cornerRadius = 8
        self.btnHydrocodone.layer.cornerRadius = 8
    }
   
    
    //connects button presses to respective medication statistic view
    func moveToDetails(type : Int , name : String){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MedicationDetailsViewController") as! MedicationDetailsViewController
        //sends name and number of medication to next interface
        vc.name = name
        vc.type = type
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // move to slot 1
    @IBAction func actionHydrocodone(_ sender: Any) {
        self.moveToDetails(type: 1, name: "Green Pill")
        
    }
    
    // move to slot 2
    @IBAction func actionAdderall(_ sender: Any) {
        self.moveToDetails(type: 2, name: "Red Pill")
    }
    
    // move to slot 3
    @IBAction func actionAmoxicillin(_ sender: Any) {
        self.moveToDetails(type: 3, name: "Orange Pill")
    }
    
    // move to slot 4
    @IBAction func actionNurtec(_ sender: Any) {
        self.moveToDetails(type: 4, name: "Brown Pill")
    }
}
