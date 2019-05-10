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
        UserDataSettings.delegate = self;
        UserDataSettings.updateAll()
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
}
