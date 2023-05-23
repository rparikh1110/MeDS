//
//  WelcomeViewController.swift
//  MeDS
//
//  
//

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var btnConnect: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //rounds out connect button
        btnConnect.layer.cornerRadius = 8

        // Do any additional setup after loading the view.
    }
    
    
    //connect button sends view to PinView
    @IBAction func actionConnect(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PinViewController") as! PinViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
