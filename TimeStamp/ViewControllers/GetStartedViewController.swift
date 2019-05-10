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
    @IBOutlet weak var LetsGetStartedLabel: UILabel!
    @IBOutlet weak var ExplainNotificationLabel: UILabel!
    @IBOutlet weak var GeneralNotificationLabel: UILabel!
    @IBOutlet weak var HouseNotificationLabel: UILabel!
    @IBOutlet weak var SpecialEventsNotificationLabel: UILabel!
    @IBOutlet weak var GeneralNotifExplain: UILabel!
    @IBOutlet weak var HouseNotifExplain: UILabel!
    @IBOutlet weak var SpecialEventNotifExplain: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setConstraints ();
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
    
    //aspect ratio constraints and horizontal center constraints are done in storyboard, here it's mainly the height constraints
    func setConstraints ()
    {
        LetsGetStartedLabel.translatesAutoresizingMaskIntoConstraints = false;
        ExplainNotificationLabel.translatesAutoresizingMaskIntoConstraints = false;
        GeneralNotificationLabel.translatesAutoresizingMaskIntoConstraints = false;
        GeneralNotifExplain.translatesAutoresizingMaskIntoConstraints = false;
        generalNotif.translatesAutoresizingMaskIntoConstraints = false;
        HouseNotificationLabel.translatesAutoresizingMaskIntoConstraints = false;
        HouseNotifExplain.translatesAutoresizingMaskIntoConstraints = false;
        houseNotif.translatesAutoresizingMaskIntoConstraints = false;
        SpecialEventsNotificationLabel.translatesAutoresizingMaskIntoConstraints = false;
        SpecialEventNotifExplain.translatesAutoresizingMaskIntoConstraints = false;
        eventNotif.translatesAutoresizingMaskIntoConstraints = false;
        done.translatesAutoresizingMaskIntoConstraints = false;
 
        
        LetsGetStartedLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 115.0/812*view.frame.height).isActive = true;
        LetsGetStartedLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 34/812.0).isActive = true;
        ExplainNotificationLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 151.0/812*view.frame.height).isActive = true;
        ExplainNotificationLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 38/812.0).isActive = true;
        GeneralNotificationLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 240.0/812*view.frame.height).isActive = true;
        GeneralNotificationLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 25/812.0).isActive = true;
        GeneralNotifExplain.topAnchor.constraint (equalTo: GeneralNotificationLabel.bottomAnchor).isActive = true;
        GeneralNotifExplain.leadingAnchor.constraint (equalTo: GeneralNotificationLabel.leadingAnchor).isActive = true;
        GeneralNotifExplain.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 65/812.0).isActive = true;
        generalNotif.topAnchor.constraint(equalTo: GeneralNotificationLabel.bottomAnchor).isActive = true;
        generalNotif.trailingAnchor.constraint(equalTo: GeneralNotificationLabel.trailingAnchor).isActive = true;
        generalNotif.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 40/812.0).isActive = true;
        
        HouseNotificationLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 376.0/812*view.frame.height).isActive = true;
        HouseNotificationLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 25/812.0).isActive = true;
        HouseNotifExplain.topAnchor.constraint (equalTo: HouseNotificationLabel.bottomAnchor).isActive = true;
        HouseNotifExplain.leadingAnchor.constraint (equalTo: HouseNotificationLabel.leadingAnchor).isActive = true;
        HouseNotifExplain.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 47/812.0).isActive = true;
        houseNotif.topAnchor.constraint(equalTo: HouseNotificationLabel.bottomAnchor).isActive = true;
        houseNotif.trailingAnchor.constraint(equalTo: HouseNotificationLabel.trailingAnchor).isActive = true;
        houseNotif.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 40/812.0).isActive = true;
        
        SpecialEventsNotificationLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 512.0/812*view.frame.height).isActive = true;
        SpecialEventsNotificationLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 25/812.0).isActive = true;
        SpecialEventNotifExplain.topAnchor.constraint (equalTo: SpecialEventsNotificationLabel.bottomAnchor).isActive = true;
        SpecialEventNotifExplain.leadingAnchor.constraint (equalTo: SpecialEventsNotificationLabel.leadingAnchor).isActive = true;
        SpecialEventNotifExplain.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 48/812.0).isActive = true;
        eventNotif.topAnchor.constraint(equalTo: SpecialEventsNotificationLabel.bottomAnchor).isActive = true;
        eventNotif.trailingAnchor.constraint(equalTo: SpecialEventsNotificationLabel.trailingAnchor).isActive = true;
        eventNotif.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 40/812.0).isActive = true;
        
        done.topAnchor.constraint(equalTo: view.topAnchor, constant: 648/812.0*view.frame.height).isActive = true;
        done.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 43/812.0).isActive = true;
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
                results[0].houseNotifications = houseNotif.isSelected
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

