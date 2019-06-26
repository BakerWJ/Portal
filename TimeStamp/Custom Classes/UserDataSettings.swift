//
//  UserDataSettings.swift
//  TimeStamp
//
//  Created by Jacky He on 2019-05-09.
//  Copyright © 2019 Baker Jackson. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import Firebase
class UserDataSettings
{
    static var weekly: WeeklySchedule?
    static var delegate: AppDelegate?
    static func updateAll ()
    {
        addTimetables()
        addWeeklySchedule ()
        createSettings ()
        updateSchedules()
    }

    static func updateWithInternet ()
    {
        let connectedRef = Database.database().reference(withPath: ".info/connected");
        var x : Bool = false;
        for _ in 1 ... 5 {
            if (!x)
            {
                connectedRef.observe(.value)
                {
                    (snapshot) in
                    if let connected = snapshot.value as? Bool, connected
                    {
                        x = true;
                        self.updateData()
                        self.updateWeeklySchedule()
                    }
                }
            }
        }
    }
    
    //This creates the setttngs and default values
    static func createSettings () {
        let fetchRequest = NSFetchRequest <NSFetchRequestResult> (entityName: "Settings");
        do {
            if let results = try CoreDataStack.managedObjectContext.fetch(fetchRequest) as? [Settings] {
                if results.count == 0 {
                    guard let entity = NSEntityDescription.entity(forEntityName: "Settings", in: CoreDataStack.managedObjectContext) else {
                        fatalError("Could not find entity deccription!")
                    }
                    let mainSettings = Settings (entity: entity, insertInto: CoreDataStack.managedObjectContext)
                    mainSettings.daysBefore = 2;
                    mainSettings.eventNotifications = false;
                    mainSettings.generalNotifications = false;
                    mainSettings.notificationTime = 3;
                    mainSettings.houseNotifications = false;
                    CoreDataStack.saveContext()
                }
            }
        }
        catch {
            fatalError("There was an error fetching the list of timetables");
        }
    }
    
    //this adds weekly schedule if there isn't already one
    static func addWeeklySchedule ()
    {
        let fetchRequest = NSFetchRequest <NSFetchRequestResult> (entityName: "WeeklySchedule");
        do
        {
            if let results = try CoreDataStack.managedObjectContext.fetch (fetchRequest) as? [WeeklySchedule]
            {
                if results.count == 0
                {
                    guard let entity = NSEntityDescription.entity (forEntityName: "WeeklySchedule", in: CoreDataStack.managedObjectContext) else
                    {
                        fatalError ("Could not find entity description!")
                    }
                    let newWeeklySchedule = WeeklySchedule(entity: entity, insertInto: CoreDataStack.managedObjectContext)
                    newWeeklySchedule.abDay = [Bool] (repeating: false, count: 7);
                    newWeeklySchedule.flipOrNot = [Bool] (repeating: false, count: 7);
                    newWeeklySchedule.typeOfDay = [Int] (repeating: 0, count: 7);
                    weekly = newWeeklySchedule;
                    CoreDataStack.saveContext()
                }
                else
                {
                    weekly = results [0];
                }
            }
        }
        catch {
            fatalError("There was an error fetching the list of timetables");
        }
    }
    
    //This updates the schedule for the upcoming week
    static func updateWeeklySchedule ()
    {
        let ref = Database.database().reference();
        ref.child("DailySchedule").observeSingleEvent(of: .value, with:
            {
                (snapshot) in
                if let data = snapshot.value as? [Any]
                {
                    var x = 0;
                    for day in data
                    {
                        if let specifics = day as? [Any]
                        {
                            if let value = specifics [0] as? Int
                            {
                                self.weekly?.typeOfDay [x] = value;
                            }
                            if let ABDay = specifics [1] as? String
                            {
                                self.weekly?.abDay [x] = ABDay == "A";
                            }
                            if let flip = specifics [2] as? String
                            {
                                self.weekly?.flipOrNot [x] = flip == "F";
                            }
                        }
                        x += 1;
                    }
                    CoreDataStack.saveContext()
                }
        })
    }
    
    //This adds a timetable if there isn't already one
    static func addTimetables ()
    {
        let fetchRequest = NSFetchRequest <NSFetchRequestResult> (entityName: "Timetable");
        do
        {
            if let results = try CoreDataStack.managedObjectContext.fetch (fetchRequest) as? [Timetable]
            {
                if results.count == 0
                {
                    guard let entity = NSEntityDescription.entity (forEntityName: "Timetable", in: CoreDataStack.managedObjectContext) else
                    {
                        fatalError ("Could not find entity description!")
                    }
                    let newTimetableA = Timetable (entity: entity, insertInto: CoreDataStack.managedObjectContext);
                    newTimetableA.name = "ADay";
                    newTimetableA.classes = [String] (repeating: "", count: 6);
                    let newTimetableB = Timetable (entity: entity, insertInto: CoreDataStack.managedObjectContext);
                    newTimetableB.name = "BDay";
                    newTimetableB.classes = [String] (repeating: "", count: 6);
                    CoreDataStack.saveContext()
                }
            }
        }
        catch
        {
            fatalError ("There was an error fetching the list of timetables")
        }
    }
    
    //This function deletes all the Period Objects, instances of Period Class, a subclass of NSManagedObject.
    //All Period Objects that are expired are deleted from the Core Data Stack Context and the function
    //will only be called if the Periods' corresponding schedule is expired.
    static func deleteSchedules ()
    {
        let fetchRequest = NSFetchRequest <NSFetchRequestResult> (entityName: "Schedule");
        do
        {
            if let results = try CoreDataStack.managedObjectContext.fetch (fetchRequest) as? [Schedule]
            {
                for each in results
                {
                    CoreDataStack.managedObjectContext.delete (each)
                }
                CoreDataStack.saveContext()
            }
        }
        catch
        {
            fatalError ("There was an error fetching the list of periods")
        }
    }
    //will only be called if flipday is expired
    static func deleteFlipDay ()
    {
        let fetchRequest = NSFetchRequest <NSFetchRequestResult> (entityName: "FlipDay");
        do
        {
            if let results = try CoreDataStack.managedObjectContext.fetch (fetchRequest) as? [FlipDay]
            {
                for each in results
                {
                    CoreDataStack.managedObjectContext.delete (each)
                }
                CoreDataStack.saveContext()
            }
        }
        catch
        {
            fatalError ("There was an error fetching the list of FlipDay")
            
        }
    }
    
    //This checks whether or not the current schedule is expired, if it is, then it will update the schedules
    //by calling updateData() and delete all the previous Schedule and Period Objects.
    static func updateSchedules ()
    {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult> (entityName: "Schedule");
        do
        {
            if let results = try CoreDataStack.managedObjectContext.fetch (fetchRequest) as? [Schedule]
            {
                //If there is nothing stored locally that are schedules (the first time opening the app), then just update
                //the data
                if (results.count == 0)
                {
                    updateWithInternet()
                    CoreDataStack.saveContext()
                }
                else
                {
                    for each in results
                    {
                        //assumes that if one is expired, then every one of the schedules is expired
                        if Date() > each.expirationDate as Date
                        {
                            //updates the local data with new schedules, even though it might be the same as the old one
                            updateWithInternet()
                            CoreDataStack.saveContext()
                            break;
                        }
                    }
                }
            }
        }
        catch
        {
            fatalError ("There was an error fetching the list of schedules!")
        }
    }

    //This function updates the data
    static func updateData ()
    {
        //Creates a reference to firestore
        let ref = Firestore.firestore();
        //Gets the document containing flip day
        ref.document ("FlipDay/FlipDay").getDocument
            {
                (docSnapshot, err) in
                if let err = err
                {
                    print ("Error getting documents: \(err)")
                }
                else
                {
                    //deletes all the existing periods and flipday schedules
                    self.deleteFlipDay()
                    //Creates a FlipDay Entity
                    guard let entityFlip = NSEntityDescription.entity (forEntityName: "FlipDay", in: CoreDataStack.managedObjectContext) else
                    {
                        fatalError ("Could not find entity description!")
                    }
                    guard let docSnapshot = docSnapshot else{return}
                    if let data = docSnapshot.data()
                    {
                        let arr = data ["correspondingPeriods"] as? [Int] ?? [];
                         //creates a flipday object
                        let Flip = FlipDay (entity: entityFlip, insertInto: CoreDataStack.managedObjectContext)
                        Flip.normalToFlip = arr;
                        Flip.expirationDate = Util.nextDay()
                        CoreDataStack.saveContext()
                    }
                }
        }
        //Gets all the documents that contain schedules
        ref.collection ("Schedules").getDocuments ()
            {
                (querySnapshot, err) in
                if let err = err
                {
                    print ("Error getting documents: \(err)")
                }
                else
                {
                    self.deleteSchedules () //the delete rule of schedules is set to cascade, so if the schedule is deleted, all the period is deleted
                    //Creates a Period Entity
                    guard let entityPeriod = NSEntityDescription.entity(forEntityName: "Period", in: CoreDataStack.managedObjectContext) else
                    {
                        fatalError ("Could not find entity description!")
                    }
                    //Creates a Schedule Entity
                    guard let entitySchedule = NSEntityDescription.entity (forEntityName: "Schedule", in: CoreDataStack.managedObjectContext) else
                    {
                        fatalError ("Could not find entity description!")
                    }
                    for document in querySnapshot!.documents
                    {
                        //loops through the documents and creates and casts data as appropriate arrays
                        let data = document.data()
                        let value = data ["value"] as? Int ?? -1;
                        let names = data ["periodNames"] as? [String] ?? [];
                        let stime = data ["startTimes"] as? [Timestamp] ?? [];
                        let etime = data ["endTimes"] as? [Timestamp] ?? [];
                        let notes = data ["additionalNotes"] as? [String] ?? [];
                        let corres = data ["correspond"] as? [Int] ?? [];
                        
                        //uses the Schedule Entity to create a Schedule Object and inserts it into the Core Data Stack managed
                        //Object Context
                        let schedule = Schedule(entity: entitySchedule, insertInto: CoreDataStack.managedObjectContext)
                        
                        //sets the attribute of schedules
                        schedule.value = Int32(value)
                        schedule.kind = document.documentID
                        //sets the expirationDate of this schedule to the nearest future Sunday at midnight (so like the one
                        //between Saturday and Sunday)
                        schedule.expirationDate = Util.nextDay ()
                        
                        //loops through the arrays
                        for x in 0..<min(corres.count,min(min(min(names.count, stime.count), etime.count), notes.count))
                        {
                            //Creates a Period Object using the Period Entity and inserts it into the Core Data Stack managed
                            //Object Context
                            let period = Period(entity: entityPeriod, insertInto: CoreDataStack.managedObjectContext)
                            
                            ///sets corresponding attributes of the period class to appropriate things
                            period.periodName = names [x];
                            period.startTime = NSDate (timeIntervalSince1970: TimeInterval(stime [x].seconds));
                            period.endTime = NSDate (timeIntervalSince1970: TimeInterval (etime [x].seconds));
                            period.additionalNotes = notes [x];
                            period.correspond = Int32(corres [x]);
                            
                            //inserts the period into the current schedule's Set of periods (which is ordered by the way)
                            schedule.addToPeriods(period);
                        }
                    }
                    //Saves the existing changes
                    CoreDataStack.saveContext()
                }
        }
    }
}
