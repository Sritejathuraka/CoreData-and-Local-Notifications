//
//  AddViewController.swift
//  CalenderTriggerDemo
//
//  Created by Sriteja Thuraka on 8/1/17.
//  Copyright © 2017 Sriteja Thuraka. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

class AddViewController: UIViewController {
    
    let datePicker = UIDatePicker()
    
    @IBOutlet weak var datetext: UITextField!
    var detail : DetailMo!

    @IBOutlet weak var titleField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //scheduleNotification()
    }
//
//    @IBAction func datepickerAction(_ sender: UIDatePicker) {
//        
//    
//   let formatter = DateFormatter()
//     formatter.dateFormat = "dd"
//        dateLabe.text = formatter.string(from: datePicker.date)
//        
//        
//        
//    }
   
  


    @IBAction func saveButton(_ sender: Any) {
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            
            detail = DetailMo(context: appDelegate.persistentContainer.viewContext)
            detail.title = titleField.text
           
            appDelegate.saveContext()
            
           
        }
    }
    
  

}
