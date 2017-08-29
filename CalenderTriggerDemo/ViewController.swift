//
//  ViewController.swift
//  CalenderTriggerDemo
//
//  Created by Sriteja Thuraka on 7/25/17.
//  Copyright © 2017 Sriteja Thuraka. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications
import UserNotificationsUI

class ViewController: UIViewController, NSFetchedResultsControllerDelegate, UITableViewDelegate, UITableViewDataSource,UNUserNotificationCenterDelegate,UIApplicationDelegate{
    var fetchResultController : NSFetchedResultsController<DetailMo>!
    @IBOutlet weak var tableView: UITableView!
    var details : [DetailMo] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       // scheduleNotification()
       
        
        let fetchRequest: NSFetchRequest<DetailMo> = DetailMo.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate){
            
            let context = appDelegate.persistentContainer.viewContext
            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultController.delegate = self
            do{
               try fetchResultController.performFetch()
                if let fetchedObjects = fetchResultController.fetchedObjects {
                    details = fetchedObjects
                }
            }catch{
                print(error)
            }
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return details.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? DetailTableViewCell
        cell?.titleLabel.text = details[indexPath.row].title
       cell?.dateLabel.text = details[indexPath.row].date_day
        var date = DateComponents()
        
        date.day = 14
        date.year = 2017
        date.minute = 01
        
        date.month = 8
        date.hour = 20
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: date , repeats: false)
        
        // reminder object needs to be in json format
        // ex.. {reminderId = 1234,
        //            reminderTilte = "Birthday",
        //             reminderDescriptio = "Please wish people" }
        
        // Db column (reminderId,reminderTilte,reminderDescriptio)

        let content = UNMutableNotificationContent()
        content.title = (cell?.titleLabel.text)! // title
        content.body = "Plesase wish people" //description
        content.categoryIdentifier = "1234" //id
        
        
        
        content.sound = UNNotificationSound.default()
        
        let request = UNNotificationRequest(identifier: "textNotification", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().delegate = self
        //UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().add(request) {(error) in
            if let error = error {
                print("Uh oh! We had an error: \(error)")
            }
        }
        
    
        
        return cell!
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Delete") { (action, indexpath) in
            if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                
                let context = appDelegate.persistentContainer.viewContext
                let detailToDelete = self.fetchResultController.object(at: indexPath)
                context.delete(detailToDelete)
                appDelegate.saveContext()
            }
        }
        
      
        return [deleteAction]
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let newIndexPath = newIndexPath{
                
                tableView.insertRows(at: [newIndexPath], with: .fade)
            }
        case .delete:
            if let indexPath = indexPath{
                
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        case .update:
            if let indexPath = indexPath{
                
                tableView.reloadRows(at: [indexPath], with: .fade)
            }
        default:
            tableView.reloadData()
           }
        if let fetchedObjects = controller.fetchedObjects {
            
            details = fetchedObjects as! [DetailMo]
        }
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }

    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        let userInfo = notification.request.content.categoryIdentifier
        print(userInfo)
        
        //body will come in json object
        // parse for looking reminderid or coloumn in Dam
        //if exist {
        //completionHandler( [.alert,.sound,.badge])
        //}else completionHandler([])
        if  userInfo == "1234" {
            completionHandler( [.alert,.sound,.badge])
        }else{
            completionHandler([])
        }
        
    }
    
    // The method will be called on the delegate when the user responded to the notification by opening the application, dismissing the notification or choosing a UNNotificationAction. The delegate must be set before the application returns from applicationDidFinishLaunching:.
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                
                                didReceive response: UNNotificationResponse,
                                
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.body
        print(userInfo)

        //body will come in json object 
        // parse for looking reminderid or coloumn in Dam
        //if exist {
        //
        //}
        
        if  userInfo == "1234" {
            completionHandler()
        }else{
            completionHandler()
        }
        
    }

}

