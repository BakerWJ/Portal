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
import UserNotifications

class UserDataSettings
{
    static var weekly: WeeklySchedule?

    static func updateAll ()
    {
        addTimetables()
        addWeeklySchedule ()
        createSettings ()
        updateSchedules()
    }

    static func eraseAll ()
    {
        deleteSchedules()
        deleteEvents()
        deleteFlipDay()
        deleteSettings()
        deleteTimetables()
    }
    
    static func updateArticles() {
        let ref = Firestore.firestore()
        ref.collection("Articles").getDocuments() {
            (querySnapshot, err) in
            if let err = err {
                print ("Error getting documents: \(err)")
            }
            else {
                guard let oldArticles = fetchAllArticles() else {return}
                //the set of old articles
                var oldSet = Set <String> ()
                var oldMap = [String : Article]()
                for each in oldArticles
                {
                    oldSet.insert(each.hashVal);
                    oldMap [each.hashVal] = each;
                }
                // the set of new articles
                var newSet = Set <String> ()
                
                guard let entityArticle = NSEntityDescription.entity(forEntityName: "Article", in: CoreDataStack.managedObjectContext) else {return}
                
                for document in querySnapshot!.documents {
                    let data = document.data()
                    let pub = data["publication"] as? String ?? ""
                    let hash = document.documentID
                    let timestamp = data ["timestamp"] as? Timestamp ?? Timestamp()
                    let author = data["author"] as? String ?? "John Doe"
                    let likes = data["likes"] as? Int32 ?? 0
                    let genre = data["tag"] as? String ?? "Boring"
                    let content = data["text"] as? String ?? "I forgot to add content"
                    let title = data["title"] as? String ?? "Bad article"
                    let imageLink = data["imageLink"] as? String ?? ""
                    let noImageKeyword = data["noImageKeyword"] as? String ?? ""
                    if (!noImageKeyword.isEmpty || !imageLink.isEmpty) {
                        if oldSet.contains(hash) //if this article was already in the phone, then just update it
                        {
                            if let article = oldMap [hash]
                            {
                                if (article.uploaded != article.liked) //if the status the user last uploaded is different from the current status
                                {
                                    //then update the new one
                                    //if the article is now liked add one, otherwise if the article is now unliked subtract one
                                    article.likes = likes + (article.liked ? 1 : -1)
                                    ref.collection("Articles").document(hash).setData(["likes" : article.likes], merge: true)
                                }
                                //update the uploaded status
                                article.uploaded = article.liked;
                            }
                        }
                        else //otherwise add it to the phone
                        {
                            let article = Article(entity: entityArticle, insertInto: CoreDataStack.managedObjectContext)
                            article.author = author
                            article.genre = genre
                            article.likes = likes
                            article.hashVal = hash
                            article.title = title
                            article.text = content
                            if (imageLink != "") {
                                article.img = imageLink
                            }
                            else {
                                article.img = "https://source.unsplash.com/1600x900/?" + noImageKeyword
                                print(article.img)
                            }
                            article.author = author
                            article.genre = genre
                            article.likes = likes
                            article.hashVal = hash
                            article.title = title
                            article.text = content
                            article.timestamp = NSDate(timeIntervalSince1970: TimeInterval(timestamp.seconds))
                            article.uploaded = false //default is false because assume that the user did not like the article before
                            article.liked = false; //assume the user did not like the article before
                            if (pub == "Cuspidor") {
                                article.publication = 0
                            }
                            else if (pub == "Blues News") {
                                article.publication = 1
                            }
                            else {
                                article.publication = 2
                            }
                        }
                        newSet.insert (hash);
                    }
                }
                //deletes the old articles that are no longer in the firestores
                let needDeleteSet = oldSet.subtracting(newSet);
                for each in needDeleteSet
                {
                    if let article = oldMap [each]
                    {
                        CoreDataStack.managedObjectContext.delete (article);
                    }
                }
                CoreDataStack.saveContext()
            }
        }
    }
    
    static func fetchAllArticles() -> [Article]? {
        let fetchRequest = NSFetchRequest <NSFetchRequestResult> (entityName: "Article");
        do
        {
            if let results = try CoreDataStack.managedObjectContext.fetch (fetchRequest) as? [Article]
            {
                return results
            }
        }
        catch
        {
            print ("There was an error fetching the list of articles")
        }
        return nil;
    }
    
    static func deleteArticles() {
        let fetchRequest = NSFetchRequest <NSFetchRequestResult> (entityName: "Article");
        do
        {
            if let results = try CoreDataStack.managedObjectContext.fetch (fetchRequest) as? [Article]
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
            print ("There was an error fetching the list of articles")
        }
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
                        self.updateEvents ();
                        self.updateArticles()
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
                    guard let entity = NSEntityDescription.entity(forEntityName: "Settings", in: CoreDataStack.managedObjectContext) else {return}
                    let mainSettings = Settings (entity: entity, insertInto: CoreDataStack.managedObjectContext)
                    mainSettings.daysBefore = 2;
                    mainSettings.surveyNotifications = true;
                    mainSettings.generalNotifications = true;
                    mainSettings.notificationTime = 2; //default: evening
                    mainSettings.houseNotifications = true;
                    mainSettings.articleNotifications = true;
                    CoreDataStack.saveContext()
                }
            }
        }
        catch {
            print("There was an error fetching the list of timetables");
        }
    }
    
    static func deleteSettings()
    {
        let fetchRequest = NSFetchRequest <NSFetchRequestResult> (entityName: "Settings");
        do
        {
            if let results = try CoreDataStack.managedObjectContext.fetch (fetchRequest) as? [Settings]
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
            print ("There was an error fetching the list of periods")
        }
    }
    
    static func fetchSettings () -> Settings?
    {
        let fetchRequest = NSFetchRequest <NSFetchRequestResult> (entityName: "Settings");
        do {
            if let results = try CoreDataStack.managedObjectContext.fetch(fetchRequest) as? [Settings] {
                if (results.count != 0)
                {
                    return results [0]
                }
            }
        }
        catch {
            print("There was an error fetching the list of timetables");
        }
        return nil;
    }
    
    static func fetchAllSchedules () -> [Schedule]?
    {
        //fetch data from core data
        let fetchRequest = NSFetchRequest<NSFetchRequestResult> (entityName: "Schedule");
        do
        {
            if let results = try CoreDataStack.managedObjectContext.fetch (fetchRequest) as? [Schedule]
            {
                return results;
            }
        }
        catch
        {
            print ("There was an error fetching the list of schedules!")
        }
        return nil;
    }
    
    static func fetchWeeklySchedule() -> WeeklySchedule?
    {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult> (entityName: "WeeklySchedule");
        do
        {
            if let results = try CoreDataStack.managedObjectContext.fetch (fetchRequest) as? [WeeklySchedule]
            {
                if (results.count != 0)
                {
                    return results [0];
                }
            }
        }
        catch
        {
            print("There was an error fetching the list of weeklySchedules!")
        }
        return nil
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
                    guard let entity = NSEntityDescription.entity (forEntityName: "WeeklySchedule", in: CoreDataStack.managedObjectContext) else {return}
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
            print("There was an error fetching the list of timetables");
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
                    guard let entity = NSEntityDescription.entity (forEntityName: "Timetable", in: CoreDataStack.managedObjectContext) else {return}
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
            print ("There was an error fetching the list of timetables")
        }
    }
    
    static func deleteTimetables()
    {
        let fetchRequest = NSFetchRequest <NSFetchRequestResult> (entityName: "Timetable");
        do
        {
            if let results = try CoreDataStack.managedObjectContext.fetch (fetchRequest) as? [Timetable]
            {
                for each in results{
                    CoreDataStack.managedObjectContext.delete(each);
                }
                CoreDataStack.saveContext()
            }
        }
        catch
        {
            print ("There was an error fetching the list of timetables")
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
            print ("There was an error fetching the list of periods")
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
            print ("There was an error fetching the list of FlipDay")
            
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
            print ("There was an error fetching the list of schedules!")
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
                    guard let entityFlip = NSEntityDescription.entity (forEntityName: "FlipDay", in: CoreDataStack.managedObjectContext) else {return}
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
                    guard let entityPeriod = NSEntityDescription.entity(forEntityName: "Period", in: CoreDataStack.managedObjectContext) else {return}
                    //Creates a Schedule Entity
                    guard let entitySchedule = NSEntityDescription.entity (forEntityName: "Schedule", in: CoreDataStack.managedObjectContext) else {return}
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
                        //sets the expirationDate of this schedule to the next day)
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
    
    static func deleteEvents ()
    {
        let fetchRequest = NSFetchRequest <NSFetchRequestResult> (entityName: "Event");
        do
        {
            if let results = try CoreDataStack.managedObjectContext.fetch (fetchRequest) as? [Event]
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
            print ("There was an error fetching the list of events")
        }
    }
    
    //updates the events
    static func updateEvents ()
    {
        let formatter = DateFormatter ();
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        let ref = Database.database().reference();
        ref.child("Events").observeSingleEvent(of: .value) { (snapshot) in
            if let data = snapshot.value as? [Any]
            {
                //deletes existing events
                self.deleteEvents ()
                for each in data
                {
                    if let specifics = each as? [Any]
                    {
                        //creates an entity description
                        guard let entityEvent = NSEntityDescription.entity(forEntityName: "Event", in: CoreDataStack.managedObjectContext) else {return}
                        //creates the event object and insert it into the coredata managed object context
                        let event = Event (entity: entityEvent, insertInto: CoreDataStack.managedObjectContext);
                        guard let titleDetail = specifics [0] as? String,
                            let time = specifics [1] as? String,
                            let date = specifics [2] as? String,
                            let kind = specifics [3] as? Int
                        else {
                            CoreDataStack.managedObjectContext.delete(event);
                            continue;
                        }
                        let time2 = time.trimmingCharacters(in: .whitespacesAndNewlines);
                        if (time2 == "A")
                        {
                            event.time = "all day";
                        }
                        else if (time2 == "B")
                        {
                            event.time = "before school";
                        }
                        else if (time2 == "L")
                        {
                            event.time = "at lunch";
                        }
                        else if (time2 == "E")
                        {
                            event.time = "after school";
                        }
                        else
                        {
                            event.time = time2;
                        }
                        event.titleDetail = titleDetail;
                        event.date = formatter.date(from: date)! as NSDate;
                        event.kind = Int32 (kind);
                    }
                }
                CoreDataStack.saveContext()
            }
        }
    }
    
    static func fetchAllEvents () -> [Event]?
    {
        let fetchRequest = NSFetchRequest <NSFetchRequestResult> (entityName: "Event");
        do
        {
            if let results = try CoreDataStack.managedObjectContext.fetch (fetchRequest) as? [Event]
            {
                return results;
            }
        }
        catch
        {
            print ("There was an error fetching the list of events")
        }
        return nil;
    }
    
    static func fetchAllEventsFor (day: Date) -> [Event]?
    {
        let fetchRequest = NSFetchRequest <NSFetchRequestResult> (entityName: "Event");
        do
        {
            if let results = try CoreDataStack.managedObjectContext.fetch (fetchRequest) as? [Event]
            {
                var ret = [Event]();
                for each in results
                {
                    if (each.date.isEqual(to: day))
                    {
                        ret.append (each);
                    }
                }
                return ret
            }
        }
        catch
        {
            print ("There was an error fetching the list of events")
        }
        return nil;
    }
    
    let notificationCenter = UNUserNotificationCenter.current()
    let options: UNAuthorizationOptions = [.alert, .sound, .badge]
    
    static func setNotifications(){
        
        let daysWeek = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests();
        
        guard let results = self.fetchSettings(),
        let days = self.fetchWeeklySchedule(),
        let schedule = self.fetchAllSchedules(),
        let events = self.fetchAllEvents()
        else {return}
        
        var requests = [UNNotificationRequest]()
        
        if (schedule.count != 0)
        {
            for x in 0...6 { //checks every day
                
                //today's weekday, Sunday is 1
                let weekday = Calendar.current.component(.weekday, from: Date());
                //target weekday
                let target = x + 1;
                var diff = target >= weekday ? target - weekday : target + 7 - weekday;
                //determines if that day requires a notification
                //if not a regular school day and a school day
                if(days.typeOfDay[x] != 1 && days.typeOfDay[x] != 4 && results.generalNotifications){
                    let general = UNMutableNotificationContent() //Notification content
                    var eventName = "";
                    for z in schedule{
                        if(z.value == days.typeOfDay[x]){
                            eventName = z.kind;
                            
                        }
                    }
                    //creates a notification the day of
                    general.title = eventName;
                    general.body = "There is " + eventName.lowercased() + " today.";
                    var time = Calendar.current.dateComponents([.year, .month, .day], from: Util.next(days: diff) as Date);
                    //notifies in the morning
                    time.hour = 7;
                    time.minute = 10;
                    
                    let trigger1 = UNCalendarNotificationTrigger(dateMatching: time, repeats: false)
                    requests.append(UNNotificationRequest(identifier: UUID().uuidString, content: general, trigger: trigger1))
                    
                    let general2 = UNMutableNotificationContent()
                    general2.title = eventName;
                    if (results.daysBefore == 1)
                    {
                        general2.body = "There is \(eventName.lowercased()) tomorrow.";
                    }
                    else
                    {
                        general2.body = "There is \(eventName.lowercased()) in \(results.daysBefore) days on \(daysWeek[x])";
                    }
                    diff -= Int(results.daysBefore)
                    if (diff >= 0)
                    {
                        time = Calendar.current.dateComponents([.year, .month, .day], from: Util.next(days: diff) as Date);
                        /*var time = DateComponents()
                        
                        time.weekday = (Int)(x + 7 - Int(results.daysBefore))%7+1*/
                        
                        if(results.notificationTime == 1){ //afternoon
                            time.hour = 12;
                            time.minute = 40;
                        }else if(results.notificationTime == 2){ //evening
                            time.hour = 16;
                            time.minute = 0;
                        }
                        
                        let trigger2 = UNCalendarNotificationTrigger(dateMatching: time, repeats: false)
                        requests.append(UNNotificationRequest(identifier: UUID().uuidString, content: general2, trigger: trigger2))
                    }
                    
                    //print(general.title);
                    //Determining time
                    
                    
                }
                if(results.articleNotifications){
                    //no article notification so far
                }
                
                
            }
        }
        
        //events notification
        var acceptableValues = [Int]();
        if (results.generalNotifications) {acceptableValues.append(1);}
        if (results.houseNotifications) {acceptableValues.append (2);}
        var wantedEvents = [Event]()
        for event in events
        {
            if acceptableValues.contains(Int(event.kind))
            {
                wantedEvents.append (event);
            }
        }
        for each in wantedEvents
        {
            //set the day of notification
            let title = UNMutableNotificationContent()
            title.title = each.titleDetail.trimmingCharacters(in: .whitespacesAndNewlines);
            title.body = each.titleDetail.trimmingCharacters(in: .whitespacesAndNewlines);
            title.body += " today \(each.time.trimmingCharacters(in: .whitespacesAndNewlines))";
            var time = Calendar.current.dateComponents([.year, .month, .day], from: each.date as Date);
            //gets notifiied in the morning for "day of" events
            time.hour = 7;
            time.minute = Int.random (in: 20...30);
            
            
            //set the daysBefore notification
            let title2 = UNMutableNotificationContent()
            title2.title = each.titleDetail.trimmingCharacters(in: .whitespacesAndNewlines);
            title2.body = each.titleDetail.trimmingCharacters(in: .whitespacesAndNewlines);
            guard let notifyDay = Calendar.current.date(byAdding: .day, value: -Int(results.daysBefore), to: each.date as Date)
                else {continue};
            var time2 = Calendar.current.dateComponents([.year, .month, .day], from: notifyDay);
            if (results.daysBefore == 1)
            {
                title2.body += " tomorrow \(each.time.trimmingCharacters(in: .whitespacesAndNewlines))";
            }
            else
            {
                title2.body += " \(daysWeek [Calendar.current.component(.weekday, from: each.date as Date) - 1]) \(each.time.trimmingCharacters(in: .whitespacesAndNewlines))"
            }
            
            if (results.notificationTime == 1) //afternoon
            {
                time2.hour = 12;
                time2.minute = Int.random(in: 30...59);
            }
            else if (results.notificationTime == 2) //evening
            {
                time2.hour = 16;
                time2.minute = Int.random(in: 30...59);
            }
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: time, repeats: false)
            requests.append(UNNotificationRequest(identifier: UUID().uuidString, content: title, trigger: trigger))
            let trigger2 = UNCalendarNotificationTrigger(dateMatching: time2, repeats: false)
            requests.append(UNNotificationRequest(identifier: UUID().uuidString, content: title2, trigger: trigger2))
        }
        
        //adds whatever notification there is
        let notificationCenter = UNUserNotificationCenter.current()
        for request in requests
        {
            notificationCenter.add(request)
        }
        //latestart,
    }
    
    //the previous method
    /*func setNotifications(){
        
        let daysWeek = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests();
        
        let fetchRequest = NSFetchRequest <NSFetchRequestResult> (entityName: "Settings");
        let fetchRequest2 = NSFetchRequest <NSFetchRequestResult> (entityName: "WeeklySchedule");
        let fetchRequest3 = NSFetchRequest <NSFetchRequestResult> (entityName: "Schedule");
        
        do {
            if let results = try CoreDataStack.managedObjectContext.fetch(fetchRequest) as? [Settings] {
                if let days = try CoreDataStack.managedObjectContext.fetch(fetchRequest2) as? [WeeklySchedule] {
                    if let schedule = try CoreDataStack.managedObjectContext.fetch(fetchRequest3) as? [Schedule] {
                        if (results.count != 0 && days.count != 0 && schedule.count != 0)
                        {
                            for x in 0...6 { //checks every day
                                var notify = false;
                                //determines if that day requires a notification
                                if((days[0].typeOfDay[x] == 2 || days[0].typeOfDay[x] == 3) && results[0].generalNotifications){
                                    notify = true;
                                    
                                }else if(results[0].articleNotifications && (days[0].typeOfDay[x]==5 || days[0].typeOfDay[x] == 6 || days[0].typeOfDay[x] == 7)){
                                    notify = true;
                                    
                                }else if(results[0].houseNotifications){
                                    //No house events thus far
                                    
                                }
                                if(notify == true){
                                    let general = UNMutableNotificationContent() //Notification content
                                    var eventName = "";
                                    for z in schedule{
                                        if(z.value == days[0].typeOfDay[x]){
                                            eventName = z.kind;
                                            
                                        }
                                    }
                                    
                                    if(results[0].daysBefore == 0){
                                        general.title = "There is " + eventName + " today.";
                                        
                                    }else{
                                        general.title = "There is " + eventName + " in " + String(results[0].daysBefore) + " days on " + daysWeek[x];
                                        
                                    }
                                    
                                    print(general.title);
                                    //Determining time
                                    var time = DateComponents()
                                    
                                    time.weekday = (Int)(x + 7 - Int(results[0].daysBefore))%7+1
                                    
                                    if(results[0].notificationTime == 1){ //morning
                                        time.hour = 8;
                                        time.minute = 10;
                                    }else if(results[0].notificationTime == 2){
                                        time.hour = 12;
                                        time.minute = 40;
                                    }else if(results[0].notificationTime == 3){//evening
                                        time.hour = 16;
                                    }
                                    
                                    let trigger = UNCalendarNotificationTrigger(dateMatching: time, repeats: false)
                                    
                                    let uuidString = UUID().uuidString
                                    let request = UNNotificationRequest(identifier: uuidString, content: general, trigger: trigger)
                                    
                                    let notificationCenter = UNUserNotificationCenter.current()
                                    notificationCenter.add(request)
                                    
                                    //latestart,
                                }
                            }
                        }
                    }
                }
            }
        }
        catch {
            print("There was an error fetching the list of timetables");
        }
    }*/
}
