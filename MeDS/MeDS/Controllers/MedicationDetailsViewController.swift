//
//  MedicationDetailsViewController.swift
//  MeDS
//
//  
//

import UIKit
import SwiftSocket

class MedicationDetailsViewController: UIViewController {
    
   //these are outlets of views which are showing on interface
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var txtDetails: UITextView!
    @IBOutlet weak var txtDosage: UITextView!
    @IBOutlet weak var txtTime: UITextView!
    @IBOutlet weak var txtCycle: UITextView!
    @IBOutlet weak var txtPills: UITextView!
    @IBOutlet weak var viewDetails: UIView!
    @IBOutlet weak var viewDosage: UIView!
    @IBOutlet weak var viewTime: UIView!
    @IBOutlet weak var viewCycle: UIView!
    @IBOutlet weak var viewPills: UIView!
    @IBOutlet weak var lblType: UILabel!
  
    //declare variables
    var type = 0
    var name = ""
    let userDefaults = UserDefaults.standard
    var cycles = [1, 2, 3, 4, 6, 8, 12, 24]
    var medication = MedicationModel() //this is model on medication i.e name , dosage , time etc properties
    
    
    //socket variable declaration
    
    let host = "18.218.15.131"
    let port = 5050
    var client: TCPClient?
    
    override func viewDidLoad() {
        
        self.setupToHideKeyboardOnTapOnView()
        
        super.viewDidLoad()
        
        //inialization of socket with port number and host address
        client = TCPClient(address: host, port: Int32(port))
       
        //this line will show the name of medication selected by user
        self.lblType.text = name
        self.tableView.layer.cornerRadius = 8
        //rounds out statistics labels
        self.viewDetails.layer.cornerRadius = 8
        self.viewDosage.layer.cornerRadius = 8
        self.viewTime.layer.cornerRadius = 8
        self.viewCycle.layer.cornerRadius = 8
        self.viewPills.layer.cornerRadius = 8
        
        //this method will fetch the previously entered data by user from local database and show the respective data
        self.fetchMedicationData()
   //     guard let client = client else { return }
 //       print("---> Data from tcp server \(String(describing: self.readDataFromSocket(from: client)))")
        // Do any additional setup after loading the view.
    }
    
    
 //   func readDataFromSocket(from client: TCPClient) -> String? {
   //   guard let response = client.read(1024*10) else { return nil }
     // return String(bytes: response, encoding: .utf8)
   // }
    
    //this method will make the connection with the socket
    func connectToSocket(identifier : String){
        
        let strrr = medication.pills
        let stringSend = String(strrr.components(separatedBy: CharacterSet.decimalDigits.inverted).joined())
        let hours = medication.cycle
        let cycle = String(hours.components(separatedBy: CharacterSet.decimalDigits.inverted).joined())
        let time = medication.time
        
        print("Response: \(stringSend)") //test
        
        let pillNum = String(stringSend.count) //length of # of pills in String
        let slot_num = String(type) //slot number in String
        let send = String("Slot #:" + slot_num + ", Pills: " + stringSend + ", Hour Cycle: " + cycle + ", " + time) //length of # of pills in String
        
        print("Response: \(send)") //test
        
        let length_send = String(send.count) //length of full send statement
        
        let num_spaces = String(repeating: " ", count: (4-(length_send.count))) //sends number of characters required for pill num
        let newStr:String = length_send + num_spaces //concatenates two length values
        
        guard let client = client else { return }
        switch client.connect(timeout: 10) {
        case .success: // each if block transmits a certain variable to server
          print("Connected to host \(client.address)")
          if let response = sendRequest(string:identifier, using: client) {
              print("Response: \(response)")
          }
          if let response = sendRequest(string:newStr, using: client) {
              print("Response: \(response)")
          }
          if let response = sendRequest(string:send, using: client) {
            print("Response: \(response)")
          }
            
            
   //       if let res = client.read(1024*10) {
     //         print("go")
       //   }
            
       //   let resp = String(bytes: res, encoding: .utf8)
        //  print(resp)
        
//        print("word")
        case .failure(let error):
            self.showAlert(message: "Connection Timeout")
            print(String(describing: error))
        }
        
    }
    
    func showAlert(message : String){
        let alert = UIAlertController(title: "Alert Message", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil) //showing the pop on screen
    }
    
    
    
    //this method will send the data to socket
    private func sendRequest(string: String, using client: TCPClient) -> String? {
      print("Sending data ... ")
      switch client.send(string: string) {
      case .success:
        return readResponse(from: client)
      case .failure(let error):
          self.showAlert(message: "Connection Timeout")
          print(String(describing: error))
        return nil
      }
    }
    
    //this method will read the response from socket
    private func readResponse(from client: TCPClient) -> String? {
      guard let response = client.read(8) else { return nil }
      return String(bytes: response, encoding: .utf8)
    }
    
    @IBAction func actionCycle(_ sender: Any) {
        self.tableView.isHidden = !self.tableView.isHidden
    }
    
    //this method will save the entered data to local database for the selected medication type
    //also you can call the connect to socket method here to send entered data to your socket
    @IBAction func actionSave(_ sender: Any) {
        do {
            self.saveMedication() // this method will set the data to model
            connectToSocket(identifier: "iapp")
            try userDefaults.setObject(medication, forKey: "\(type)") //this method will save the model to local database
        } catch {
            print(error.localizedDescription)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    
    //Remotely Dispense action
    @IBAction func actionRemotelyDispense(_ sender: Any) {
        print("Remotely Dispense button pressed")
        self.saveMedication() // this method will set the data to model. should i put this before or after socket connection?
        do {
            connectToSocket(identifier: "disp")
            try userDefaults.setObject(medication, forKey: "\(type)") //this method will save the model to local database
        } catch {
            print(error.localizedDescription)
        }
        self.navigationController?.popViewController(animated: true)
        
    }
    //this method will display data which is pulled from local database
    func setMedicationData(){
        self.txtPills.text = medication.pills
        self.txtCycle.text = medication.cycle
        self.txtTime.text = medication.time
        self.txtDosage.text = medication.dosage
        self.txtPills.text = medication.pills
    }
    
    // this method will set the data to model
    func saveMedication(){
        medication.pills = self.txtPills.text ?? ""
        medication.cycle =  self.txtCycle.text  ?? ""
         medication.time = self.txtTime.text ?? ""
         medication.dosage = self.txtDosage.text ?? ""
         medication.pills = self.txtPills.text ?? ""
    }
    
    //this method will fetch the data from database
    func fetchMedicationData(){
        do {
            medication = try userDefaults.getObject(forKey: "\(type)", castTo: MedicationModel.self)
            self.setMedicationData()
        } catch {
            print(error.localizedDescription)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension MedicationDetailsViewController : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cycles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CycleTableViewCell", for: indexPath) as! CycleTableViewCell
        cell.lblCycle.text = "\(self.cycles[indexPath.row])"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.isHidden = true
        self.txtCycle.text = "\(self.cycles[indexPath.row]) Hour Cycle"
    }
    
}

extension MedicationDetailsViewController
{
    func setupToHideKeyboardOnTapOnView()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(MedicationDetailsViewController.dismissKeyboard))

        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
}
