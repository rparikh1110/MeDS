//
//  PinViewController.swift
//  MeDS
//
//  
//

import UIKit

class PinViewController: UIViewController , UITextFieldDelegate{
// pin code text fields
    @IBOutlet weak var txtfFour: UITextField!
    @IBOutlet weak var txtfThree: UITextField!
    @IBOutlet weak var txtfTwo: UITextField!
    @IBOutlet weak var txtfOne: UITextField!
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //This function checks user input and sends to interface 3 (medication list) if correct
    func checkPinCode(){
        if txtfOne.text != "" && txtfTwo.text != "" && txtfThree.text != "" && txtfFour.text != ""{
            let pinCode = txtfOne.text! + txtfTwo.text! + txtfThree.text! + txtfFour.text!
            if pinCode == "1234"{ // compare input to correct pin
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "MedicationOptionViewController") as! MedicationOptionViewController
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    //automatically move to next box when each digit is input
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField == txtfOne{
            if textField.text != ""{
                txtfTwo.becomeFirstResponder() //move to next box
            }
        }
        else if textField == txtfTwo{
            if textField.text != ""{
                txtfThree.becomeFirstResponder() //move to next box
            }
            
        }
        else if textField == txtfThree{
            if textField.text != ""{
                txtfFour.becomeFirstResponder() //move to next box
            }
        }
        //when all four digits entered, call checkPinCode function
        self.checkPinCode()
    }
    
    //digit replacement
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        textField.text = ""
        return true
    }
}
