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
import GoogleSignIn
import GoogleAPIClientForREST
import GTMAppAuth

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate
{
    // Setup for Notifications
    let notificationCenter = UNUserNotificationCenter.current()
    let options: UNAuthorizationOptions = [.alert, .sound, .badge]
    var window: UIWindow?

    //The top label that appears at the top of the screen
    var label = UILabel();
    var today = UILabel();
    //an array of schedules for the day.
    var schedules = [Schedule]()
    //an weekly schedule object
    var weeklySchedule: WeeklySchedule?
    
    //MARK: Google Sign In
    //handle the url received at the end of the authentification process
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool
    {
        return GIDSignIn.sharedInstance().handle(url as URL?,
                                                 sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                                                 annotation: options[UIApplication.OpenURLOptionsKey.annotation])
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!)
    {
        if let error = error
        {
            print("\(error.localizedDescription)")
        }
        else
        {
            // Perform any operations on signed in user here.
            
            guard let authentication = user.authentication else {return}
            let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
            
            Auth.auth().signInAndRetrieveData(with: credential, completion: {
                (authResult, error) in
                if let error = error
                {
                    print (error.localizedDescription)
                    return;
                }
                
                if let vc = self.window?.rootViewController as? SignInViewController
                {
                    
                    if (user.profile.email.suffix(13) == "@utschools.ca")
                    {
                        UserDefaults.standard.set(true, forKey: "loggedin");
                        UserDataSettings.updateAll()
                        if (UserDefaults.standard.bool(forKey: "notFirstTimeLaunch"))
                        {
                            vc.performSegue(withIdentifier: "toTabBar", sender: vc)
                        }
                        else
                        {
                            vc.performSegue(withIdentifier: "toGetStarted", sender: vc)
                        }
                    }
                    else
                    {
                        vc.showWarning ();
                        do {
                            try Auth.auth().signOut()
                            GIDSignIn.sharedInstance().signOut();
                        }
                        catch let signOutError as NSError
                        {
                            print ("Error signing out: %@", signOutError)
                            return;
                        }
                    }
                }
            })
            
            let userId = user.userID                  // For client-side use only!
            let idToken = user.authentication.idToken // Safe to send to the server
            let fullName = user.profile.name
            let givenName = user.profile.givenName
            let familyName = user.profile.familyName
            let email = user.profile.email
            // ...
            
        }
    }

    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
    
    // Implement these methods only if the GIDSignInUIDelegate is not a subclass of
    // UIViewController.
    
    // Stop the UIActivityIndicatorView animation that was started when the user
    // pressed the Sign In button
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
    {
        //Connection to firebase
        FirebaseApp.configure();
        
        //Initialize sign-in
        //need to later prompt the additionalScope for consent
        let calendarScope = "https://www.googleapis.com/auth/calendar.events";
        let calendarScope2 = "https://www.googleapis.com/auth/calendar";
        let classroomScope = "https://www.googleapis.com/auth/classroom.coursework.me";
        GIDSignIn.sharedInstance()?.clientID = FirebaseApp.app()?.options.clientID;
        GIDSignIn.sharedInstance()?.delegate = self;
        GIDSignIn.sharedInstance()?.scopes.append(calendarScope);
        GIDSignIn.sharedInstance().scopes.append (calendarScope2);
        GIDSignIn.sharedInstance().scopes.append (classroomScope);
        
        //After the app launches, it will check if the current schedule stored locally is up to date
        UserDataSettings.delegate = self;
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
        UserDataSettings.updateAll()
        setNotifications ();
        
        self.window = UIWindow (frame: UIScreen.main.bounds)
        let mainStoryboard = UIStoryboard (name: "Main", bundle: nil);
        
        var viewControllerName: String;

        viewControllerName = "Sign In View Controller";
        
        let entranceViewController = mainStoryboard.instantiateViewController(withIdentifier: viewControllerName);
        self.window?.rootViewController = entranceViewController;
        self.window?.makeKeyAndVisible()
        
        //updates the data in the background every 10 minutes
        UIApplication.shared.setMinimumBackgroundFetchInterval(600);
        return true
    }

    func setNotifications(){

        
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
                                    
                                }else if(results[0].eventNotifications && (days[0].typeOfDay[x]==5 || days[0].typeOfDay[x] == 6 || days[0].typeOfDay[x] == 7)){
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
                                    
                                    time.weekday = (Int)(x + 8 - Int(results[0].daysBefore)%7)
                                    
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
                                }
                            }
                        }
                    }
                }
            }
        }
        catch {
            fatalError("There was an error fetching the list of timetables");
        }
        

        //latestart,
        
        
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
    
    //this is the code that gets executed every 10 minutes for background updates
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void)
    {
        UserDataSettings.updateAll();
    }
}
