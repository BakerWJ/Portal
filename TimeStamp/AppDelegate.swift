//
//  AppDelegate.swift
//  UTS APP
//
//  Created by Jacky He on 2019-04-01.
//  Copyright © 2019 Jacky He. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseMessaging
import Firebase
import FirebaseFirestore
import CoreData
import UserNotifications
import FirebaseAuth
import GoogleSignIn
import GTMAppAuth

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate, UNUserNotificationCenterDelegate
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
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if (url.scheme == "com.googleusercontent.apps.367766824243-2lift2fsdd0d6nmvi4uic7grt3e60r1l")
        {
            if (UserDefaults.standard.bool(forKey: "loggedin") && UserDefaults.standard.bool(forKey: "notFirstTimeLaunch"))
            {
                if let window = self.window
                {
                    window.makeKeyAndVisible()
                    if let root = window.rootViewController
                    {
                        let currVC = findBestViewController(vc: root);
                        let tabBarVC = findTabBarController (vc: root);
                        if let vc = currVC as? CreditsViewController
                        {
                            DispatchQueue.main.async {
                                vc.cancel()
                            }
                        }
                        else if let vc = currVC as? PublicationViewController
                        {
                            DispatchQueue.main.async {
                                vc.exit()
                            }
                        }
                        else if let vc = currVC as? ArticleViewController
                        {
                            DispatchQueue.main.async {
                                vc.handleTap();
                            }
                            if let vc2 = vc.delegate as? PublicationViewController
                            {
                                DispatchQueue.main.asyncAfter(deadline: .now()+0.3, execute: {
                                    vc2.exit()
                                })
                            }
                        }
                        
                        if tabBarVC != nil
                        {
                            UIApplication.shared.beginIgnoringInteractionEvents()
                            switch url.host
                            {
                            case "main":
                                DispatchQueue.main.asyncAfter(deadline: .now()+0.7, execute: {
                                    tabBarVC?.selectedIndex = 0;
                                    UIApplication.shared.endIgnoringInteractionEvents()
                                })
                                
                            case "featured":
                                DispatchQueue.main.asyncAfter(deadline: .now()+0.7, execute: {
                                    tabBarVC?.selectedIndex = 0;
                                })
                                
                                if let vc = tabBarVC?.viewControllers? [0] as? UINavigationController
                                {
                                    if let vc2 = vc.topViewController as? MainPageViewController
                                    {
                                        DispatchQueue.main.asyncAfter(deadline: .now()+1, execute: {
                                            vc2.featured()
                                            UIApplication.shared.endIgnoringInteractionEvents()
                                        })
                                    }
                                }
                            case "today":
                                if let vc = currVC as? ScheduleViewController
                                {
                                    DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
                                        vc.defaultIndex = (Util.next(days: 0) as Date, true);
                                        vc.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .left, animated: true);
                                        UIApplication.shared.endIgnoringInteractionEvents()
                                    }
                                }
                                else if let vc = tabBarVC?.viewControllers? [1] as? UINavigationController
                                {
                                    if let vc2 = vc.topViewController as? ScheduleViewController
                                    {
                                        vc2.defaultIndex = (Util.next(days: 0) as Date, true);
                                        DispatchQueue.main.asyncAfter(deadline: .now()+0.7, execute: {
                                            tabBarVC?.selectedIndex = 1;
                                            UIApplication.shared.endIgnoringInteractionEvents()
                                        })
                                    }
                                }
                            default:
                                break;
                            }
                        }
                    }
                }
                
            }
        }
        return GIDSignIn.sharedInstance().handle(url)
    }
    
    private func findTabBarController (vc: UIViewController) -> UITabBarController?
    {
        if let controller = vc as? UITabBarController
        {
            return controller;
        }
        else if let controller = vc.presentedViewController
        {
            return findTabBarController(vc: controller)
        }
        else if let controller = vc as? UINavigationController
        {
            if (controller.viewControllers.count > 0)
            {
                if let temp = controller.topViewController
                {
                    return findTabBarController(vc: temp);
                }
            }
            return nil;
        }
        return nil
    }
    
    //finds the currently presented view controller
    private func findBestViewController (vc: UIViewController) -> UIViewController
    {
        if let controller = vc.presentedViewController
        {
            return findBestViewController(vc: controller)
        }
        else if let controller = vc as? UINavigationController
        {
            if (controller.viewControllers.count > 0)
            {
                if let temp = controller.topViewController
                {
                    return findBestViewController(vc: temp);
                }
            }
            return controller;
        }
        else if let controller = vc as? UITabBarController
        {
            if let controllers = controller.viewControllers
            {
                if (controllers.count > 0)
                {
                    if let temp = controller.selectedViewController
                    {
                        return findBestViewController(vc: temp);
                    }
                }
            }
            return controller
        }
        return vc
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!)
    {
        var vc: SignInViewController?;
        if let vc2 = self.window?.rootViewController?.presentedViewController as? SignInViewController
        {
            vc = vc2;
        }
        else if let vc2 = self.window?.rootViewController as? SignInViewController
        {
            vc = vc2;
        }
        if let error = error {
            let alert = UIAlertController(title: "Sign In Failed", message: "", preferredStyle: .alert);
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            vc?.present (alert, animated: true, completion: nil);
            vc?.signInButton.isUserInteractionEnabled = true;
            vc?.appleSignIn.isUserInteractionEnabled = true;
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                print("The user has not signed in before or they have since signed out.")
            } else {
                print("\(error.localizedDescription)")
            }
            return
        }
        else
        {
            // Perform any operations on signed in user here.
            guard let authentication = user.authentication else {return}
            let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
            Auth.auth().signIn(with: credential, completion: {
                (authResult, error) in
                if let error = error
                {
                    let alert = UIAlertController(title: "Sign In Failed", message: "", preferredStyle: .alert);
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil));
                    vc?.present (alert, animated: true, completion: nil);
                    print (error.localizedDescription)
                    vc?.signInButton.isUserInteractionEnabled = true;
                    vc?.appleSignIn.isUserInteractionEnabled = true;
                    return;
                }
                if (user.profile.email.suffix(13) == "@utschools.ca")
                {
                    UserDefaults.standard.set(true, forKey: "loggedin");
                    UserDataSettings.updateAll()
                    if (UserDefaults.standard.bool(forKey: "notFirstTimeLaunch"))
                    {
                        vc?.performSegue (withIdentifier: "toTabBar", sender: vc);
                    }
                    else
                    {
                        vc?.performSegue(withIdentifier: "toGetStarted", sender: vc);
                    }
                    vc?.signInButton.isUserInteractionEnabled = true;
                    vc?.appleSignIn.isUserInteractionEnabled = true;
                }
                else
                {
                    do {
                        vc?.signInButton.isUserInteractionEnabled = true;
                        vc?.appleSignIn.isUserInteractionEnabled = true;
                        try Auth.auth().signOut()
                        GIDSignIn.sharedInstance().signOut();
                    }
                    catch let signOutError as NSError
                    {
                        vc?.signInButton.isUserInteractionEnabled = true;
                        vc?.appleSignIn.isUserInteractionEnabled = true;
                        print ("Error signing out: %@", signOutError)
                        return;
                    }
                    let alert = UIAlertController(title: "Unsupported Account", message: "Sign in is restricted to UTS Members", preferredStyle: .alert);
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    vc?.present (alert, animated: true, completion: nil);
                }
            })
            
            //let userId = user.userID                  // For client-side use only!
            let idToken = user.authentication.idToken // Safe to send to the server
            //let fullName = user.profile.name
            let givenName = user.profile.givenName
            //let familyName = user.profile.familyName
            //let email = user.profile.email
            Crashlytics.sharedInstance().setUserIdentifier(idToken);
            UserDefaults.standard.set(givenName, forKey: "username");
            if (user.profile.hasImage)
            {
                let url = user.profile.imageURL(withDimension: UInt(60/812.0*UIScreen.main.bounds.height))
                guard let link = url else {return};
                URLSession.shared.dataTask(with: link) { data, response, error in
                    guard let data = data, error == nil
                        else { return }
                    UserDefaults.standard.set(data, forKey: "userimage")
                }.resume()
            }
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
       // Util.printFonts()
        UITabBar.appearance().backgroundImage = UIImage();
        UITabBar.appearance().shadowImage = UIImage();
        //Connection to firebase
        FirebaseApp.configure();
        //setup crashlytics
        Fabric.sharedSDK().debug = true;
        
        //Initialize sign-in
        //need to later prompt the additionalScope for consent
        GIDSignIn.sharedInstance()?.clientID = FirebaseApp.app()?.options.clientID;
        GIDSignIn.sharedInstance()?.delegate = self;

        
        //MARK: remote notification
        UNUserNotificationCenter.current().delegate = self;
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound];
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { (_, _) in}
        application.registerForRemoteNotifications()
        Messaging.messaging().delegate = self;
        
        //After the app launches, it will check if the current schedule stored locally is up to date
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
        
        self.window = UIWindow (frame: UIScreen.main.bounds)
        
        let mainStoryboard = UIStoryboard (name: "Main", bundle: nil);
        
        var viewControllerName: String;
        
        if (UserDefaults.standard.bool(forKey: "notFirstTimeLaunch"))
        {
            viewControllerName = "Sign In View Controller";
        }
        else
        {
            viewControllerName = "Launch View Controller";
        }
        
        let entranceViewController = mainStoryboard.instantiateViewController(withIdentifier: viewControllerName);
        self.window?.rootViewController = entranceViewController;
        self.window?.makeKeyAndVisible()
        
        //updates the data in the background every hour
        UIApplication.shared.setMinimumBackgroundFetchInterval(3600);
        return true
    }


    
    func applicationWillEnterForeground(_ application: UIApplication)
    {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        if let window = self.window
        {
            if let root = window.rootViewController
            {
                let currVC = findBestViewController(vc: root);
                if let vc = currVC as? ScheduleViewController
                {
                    vc.refresh()
                }
                else if let vc = currVC as? NewsViewController
                {
                    vc.refresh()
                }
            }
        }
        
    }
    
    func applicationDidBecomeActive(_ application: UIApplication)
    {
        //sets the badge number to 0
        application.applicationIconBadgeNumber = 0;
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication)
    {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
        //This saves any changes to the CoreDataStack NSManagedContext before the app terminates so the changes
        //by the users can be saved
        CoreDataStack.saveContext()
    }
    
    //this is the code that gets executed every hour for background updates
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void)
    {
        UserDataSettings.updateAll();
        completionHandler(.newData);
    }
}

extension AppDelegate: MessagingDelegate
{
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        
        
        if let user = Auth.auth().currentUser,
            let email = user.email,
        email.suffix(13) == "@utschools.ca"
        {
            let ref = Firestore.firestore();
            ref.collection("Users").document(email).setData(["fcmToken" : fcmToken, "name" : user.displayName ?? ""]);
        }

        let dataDict:[String: String] = ["token": fcmToken]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        
        InstanceID.instanceID().instanceID { (result, error) in
            if let error = error {
                print ("Error fetching remote instance ID: \(error)")
            } else if let result = result {
                print ("Remote intance ID token: \(result.token)")
                Messaging.messaging().subscribe(toTopic: "all");
            }
        }
    }
}
