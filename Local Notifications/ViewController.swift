//
//  ViewController.swift
//  Local Notifications
//
//  Created by لمياء فالح الدوسري on 16/05/1443 AH.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {
   
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var theStack: UIStackView!
    @IBOutlet weak var total: UILabel!
    @IBOutlet weak var hourMin: UILabel!
    @IBOutlet weak var workUntil: UILabel!
    @IBOutlet weak var timerSet: UILabel!
    var totalTime=0
    var AddedTime=0
    var selection=0
    var min = 0
    var preesed=true

    
    var logs:[String]=[]
    
    @IBAction func cancleButt(_ sender: UIBarButtonItem) {
        timerSet.isHidden=true
        workUntil.isHidden=true
        
        logs.append("canceled Timer")
        
    }
    @IBAction func DisplyLog(_ sender: UIButton) {
        if preesed == true{
        tableView.reloadData()

        theStack.isHidden=true
        tableView.isHidden=false
            preesed=false

            print(logs)}else{
                theStack.isHidden=false
                tableView.isHidden=true
                preesed=true

                
            }
        
        
    }
    @IBAction func newDay(_ sender: UIBarButtonItem) {
        
      
        totalTime=0
         AddedTime=0
         selection=0
        min = 0
        
        total.text = "total Time : \(totalTime)"
        
        hourMin.text = " 0 hours : \(min) min"
        
        timerSet.isHidden=true
        workUntil.isHidden=true
        logs.append("new Day")
        
        
    }
    //  var curntTime=Date().addingTimeInterval(TimeInterval(AddedTime*60))


    @IBAction func startTimer(_ sender: UIButton) {
        
        
        if selection == 0{
            AddedTime=5
        }else if selection == 1{
            AddedTime=10
        }else if selection == 2{
            AddedTime=20
        }else if selection == 3{
            AddedTime=30
        }else if selection == 4{
            AddedTime=40
        }
       // let curntTime=Date().addingTimeInterval(TimeInterval(AddedTime*60))
        
        
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        
        askPermission()

        workUntil.text = "Work until: \(formatter.string(from:   Date().addingTimeInterval(Double(AddedTime) * 60.0) ))"
      
        

      //  workUntil.text="work Until : \(curntTime)"
        timerSet.isHidden=false
        workUntil.isHidden=false

        min = AddedTime
        totalTime += AddedTime
        
        total.text = "total Time : \(totalTime)"
        
        hourMin.text = " 0 hours : \(min) min"
        
        logs.append("\(formatter.string(from: Date().addingTimeInterval(0.0) )) - \(formatter.string(from: Date().addingTimeInterval(Double(AddedTime) * 60.0) )) -- \(AddedTime) minute timer")
        
        let dialogConfirm = UIAlertController(title: "\(AddedTime) min countdown", message: "After \(AddedTime) Minutes, you'll be notified.\nTurn your ringer on", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        dialogConfirm.addAction(action)
        present(dialogConfirm, animated: true, completion: nil)
    }
    @IBOutlet weak var picker: UIPickerView!
    
    
    var pickerData = ["5 minute","10 minute","20 minute","30 minute","40 minute"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.isHidden=true
        
        timerSet.isHidden=true
        workUntil.isHidden=true

        tableView.dataSource=self
        
        picker.dataSource=self
        picker.delegate=self
        
        
    }

    
    
    
    
    func askPermission(){
        
        let center=UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert,.sound]){
            (granted,error) in
        }
        let contant=UNMutableNotificationContent()
        contant.title = "\(AddedTime) min countdown"
        contant.body = "\(AddedTime) is done!!"
        
        let date=Date().addingTimeInterval(TimeInterval(AddedTime*60))
        
        let dateCompnante=Calendar.current.dateComponents([.year,.month,.day ,.hour,.minute,.second], from: date)
        
       let trigger = UNCalendarNotificationTrigger(dateMatching: dateCompnante , repeats: false )
        let id = UUID().uuidString
       let requst  =  UNNotificationRequest(identifier: id  , content: contant, trigger: trigger)
        
        center.add(requst){(error) in }
        
    }
    
    
 
}

extension ViewController:UIPickerViewDelegate,UIPickerViewDataSource{
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        NSAttributedString(string: pickerData[row], attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        
        return pickerData[row]
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
     
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        timerSet.text="\(pickerData[row]) timer set"
        selection=row
      //  logs.append(pickerData[row])
       
    }
    
    
    
    
    
}
extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return logs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = logs[indexPath.row]
        cell.textLabel?.textColor = UIColor.blue
        
        return cell
    }
}


