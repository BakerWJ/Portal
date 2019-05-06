//
//  AppDelegate.swift
//  UTS APP
//
//  Created by Jacky He on 2019-04-01.
//  Copyright © 2019 Jacky He. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase
import FirebaseFirestore
import CoreData
import UserNotifications
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{
    // Setup for Notifications
    let notificationCenter = UNUserNotificationCenter.current()
    let options: UNAuthorizationOptions = [.alert, .sound, .badge]

    var window: UIWindow?
    /*
     //Code for Google Signins
     func applicationDidFinishLaunching(_ application: UIApplication)
     {
     // Initialize sign-in
     var configureError: NSError?
     GGLContext.sharedInstance().configureWithError(&configureError)
     assert(configureError == nil, "Error configuring Google services: \(String(describing: configureError))")
     }
     
     func application(_ application: UIApplication,
     open url: URL, sourceApplication: String?, annotation: Any) -> Bool
     {
     return GIDSignIn.sharedInstance().handle(url,
     sourceApplication: sourceApplication,
     annotation: annotation)
     }
     
     @available(iOS 9.0, *)
     func application(_ app: UIApplication, open url: URL,
     options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool
     {
     let sourceApplication = options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String
     let annotation = options[UIApplication.OpenURLOptionsKey.annotation]
     return GIDSignIn.sharedInstance().handle(url,
     sourceApplication: sourceApplication,
     annotation: annotation)
     }
     */
    //Template code
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
    {
        //Connection to firebase
        FirebaseApp.configure();
        //After the app launches, it will check if the current schedule stored locally is up to date
        updateSchedules()
        addSchedules()
        createSettings ()
        //if notifications are not allowed, it is asked for
        notificationCenter.getNotificationSettings { (settings) in
            if settings.authorizationStatus != .authorized {
                self.notificationCenter.requestAuthorization(options: self.options) {
                    (didAllow, error) in
                    if !didAllow {
                        print("User has declined notifications")
                    }
                }
            }
        }
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication)
    {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication)
    {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication)
    {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication)
    {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication)
    {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
        //This saves any changes to the CoreDataStack NSManagedContext before the app terminates so the changes
        //by the users can be saved
        CoreDataStack.saveContext()
    }
    //This will add the A and B day timetable to Core data if there wasn't one
    
    
    //This creates the setttngs and default values
    func createSettings () {
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
                }
            }
        }
        catch {
            fatalError("There was an error fetching the list of timetables");
        }
    }
    
    
    func addSchedules ()
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
    func deletePeriods ()
    {
        let fetchRequest = NSFetchRequest <NSFetchRequestResult> (entityName: "Period");
        do
        {
            if let results = try CoreDataStack.managedObjectContext.fetch (fetchRequest) as? [Period]
            {
                for each in results
                {
                    CoreDataStack.managedObjectContext.delete (each)
                }
            }
        }
        catch
        {
            fatalError ("There was an error fetching the list of periods")
        }
    }
    //will only be called if flipday is expired
    func deleteFlipDay ()
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
            }
        }
        catch
        {
            fatalError ("There was an error fetching the list of FlipDay")
            
        }
    }
    //This checks whether or not the current schedule is expired, if it is, then it will update the schedules
    //by calling updateData() and delete all the previous Schedule and Period Objects.
    func updateSchedules ()
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
                    updateData()
                }
                else
                {
                    for each in results
                    {
                        //assumes that if one is expired, then every one of the schedules is expired
                        if Date() > each.expirationDate as Date
                        {
                            //Deletes all the previous schedules
                            for each in results
                            {
                                CoreDataStack.managedObjectContext.delete (each);
                            }
                            //deletes all the previous periods
                            deletePeriods()
                            deleteFlipDay()
                            //updates the local data with new schedules, even though it might be the same as the old one
                            updateData()
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
    func updateData ()
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
                    //Creates a FlipDay Entity
                    guard let entityFlip = NSEntityDescription.entity (forEntityName: "FlipDay", in: CoreDataStack.managedObjectContext) else
                    {
                        fatalError ("Could not find entity description!")
                    }
                    guard let docSnapshot = docSnapshot else{return}
                    if let data = docSnapshot.data()
                    {
                        let arr = data ["correspondingPeriods"] as? [Int] ?? [];
                        print (arr)
                        //creates a flipday object
                        let Flip = FlipDay (entity: entityFlip, insertInto: CoreDataStack.managedObjectContext)
                        Flip.normalToFlip = arr;
                        Flip.expirationDate = self.nextSunday()
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
                        schedule.expirationDate = self.nextSunday ()
                        
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
    
    //The function returns the nearest Sunday from now
    func nextSunday () -> NSDate
    {
        //gets the current user calendar
        let calendar = Calendar.current;
        
        //gets today's date
        var today: Date = Date();
        
        //initialize weekday
        var weekday = -1;
        
        //loop until the weekday variable says 1, which indicates a Sunday
        while (weekday != 1)
        {
            //Adds one day to "today"'s date
            today = calendar.date(byAdding: .day, value: 1, to: today)!
            
            //The week day value is set to the weekday component of the Date Object with name "today"
            weekday = calendar.component (.weekday, from: today);
        }
        
        //Calling start of day makes the Date referring to the midnight of the current date
        today = calendar.startOfDay(for: today);
        
        //returns the value as NSDate because Core Data hates Date
        return today as NSDate
    }
}
