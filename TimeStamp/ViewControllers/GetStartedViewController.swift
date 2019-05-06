//
//  ViewController.swift
//  TimeStamp
//
//  Created by Baker Jackson on 2019-04-28.
//  Copyright © 2019 Baker Jackson. All rights reserved.
//

import UIKit
import CoreData

class GetStartedViewController: UIViewController {
    
    @IBOutlet weak var generalNotif: UIButton!
    @IBOutlet weak var houseNotif: UIButton!
    @IBOutlet weak var eventNotif: UIButton!
    @IBOutlet weak var done: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let fetchRequest = NSFetchRequest <NSFetchRequestResult> (entityName: "Settings");
        do {
            if let results = try CoreDataStack.managedObjectContext.fetch(fetchRequest) as? [Settings] {
                self.generalNotif.isSelected = results[0].generalNotifications
                self.houseNotif.isSelected = results[0].houseNotifications
                self.eventNotif.isSelected = results[0].eventNotifications
            }
        }
        catch {
            fatalError("There was an error fetching the list of timetables");
        }
    }
    
    @IBAction func generalClick(_ sender: Any) {
        generalNotif.isSelected = !generalNotif.isSelected
        let fetchRequest = NSFetchRequest <NSFetchRequestResult> (entityName: "Settings");
        do {
            if let results = try CoreDataStack.managedObjectContext.fetch(fetchRequest) as? [Settings] {
                results[0].generalNotifications = generalNotif.isSelected
            }
        }
        catch {
            fatalError("There was an error fetching the list of timetables");
        }
        CoreDataStack.saveContext()
    }
    
    @IBAction func houseClick(_ sender: Any) {
        houseNotif.isSelected = !houseNotif.isSelected
        let fetchRequest = NSFetchRequest <NSFetchRequestResult> (entityName: "Settings");
        do {
            if let results = try CoreDataStack.managedObjectContext.fetch(fetchRequest) as? [Settings] {
                results[0].eventNotifications = eventNotif.isSelected
            }
        }
        catch {
            fatalError("There was an error fetching the list of timetables");
        }
        CoreDataStack.saveContext()
    }
    
    @IBAction func eventClick(_ sender: Any) {
        eventNotif.isSelected = !eventNotif.isSelected
        let fetchRequest = NSFetchRequest <NSFetchRequestResult> (entityName: "Settings");
        do {
            if let results = try CoreDataStack.managedObjectContext.fetch(fetchRequest) as? [Settings] {
                results[0].eventNotifications = eventNotif.isSelected
            }
        }
        catch {
            fatalError("There was an error fetching the list of timetables");
        }
        CoreDataStack.saveContext()
    }
    
    
    
}

