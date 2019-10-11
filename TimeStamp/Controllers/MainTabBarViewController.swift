//
//  MainTabBarViewController.swift
//  TimeStamp
//
//  Created by Jacky He on 2019-06-22.
//  Copyright © 2019 Baker Jackson. All rights reserved.
//

import UIKit
import Crashlytics

class MainTabBarViewController: UITabBarController, UITabBarControllerDelegate {

    @IBInspectable var defaultIndex: Int = 0;
    
    //the screen width and height
    let screenWidth = UIScreen.main.bounds.width;
    let screenHeight = UIScreen.main.bounds.height;
    var tabBarItems = [UITabBarItem]()
    
    var unwind = false;
    
    lazy var underline: UIView = {
        let view = UIView ();
        view.frame.size = CGSize (width: 22/375.0*screenWidth, height: 2/375.0*screenWidth);
        view.backgroundColor = UIColor (red: 0/255.0, green: 48/255.0, blue: 87/255.0, alpha: 1);
        return view;
    }()
    
    let homeIcon = UIImageView (image: UIImage (named: "homeTabBarIcon"));
    let scheduleIcon = UIImageView (image: UIImage (named: "scheduleTabBarIcon"));
    let newsIcon = UIImageView (image: UIImage (named: "newsTabBarIcon"));
    let settingsIcon = UIImageView(image: UIImage(named: "settingsTabBarIcon"));
    var iconImages = [UIImageView] ();
    
    override var selectedIndex: Int {
        didSet {
            tabChangedTo(index: selectedIndex)
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        selectedIndex = defaultIndex;
        self.delegate = self;
        update()
        initialsetup()
        UserDataSettings.updateAll();
        // Do any additional setup after loading the view.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews();
        update()
    }
    

    var selected = 0;
    
    //programmatically changing tabs
    private func tabChangedTo (index: Int)
    {
        for x in 0..<4
        {
            if x == index
            {
                //if it was not previously selected then execute the animation, otherwise do nothing
                if (selected != x)
                {
                    DispatchQueue.main.async {
                        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                            self.iconImages [x].frame = self.iconImages [x].frame.offsetBy(dx: 0, dy: -5/375.0*self.screenWidth);
                            self.underline.center.x = self.iconImages [x].center.x;
                        }, completion: nil)
                    }
                }
            }
            else //unselect the other icons
            {
                if (selected == x) //if it was previously selected, then execute the animation
                {
                    DispatchQueue.main.async {
                        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                            self.iconImages [x].frame = self.iconImages [x].frame.offsetBy(dx: 0, dy: 5/375.0*self.screenWidth);
                        }, completion: nil)
                    }
                }
            }
        }
        selected = index;
    }
    
    //user changing tabs
    //does some thing when a certain tabbaritem is selected (passed in as a parameter)
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        let index = tabBar.items?.firstIndex(of: item);
        for x in 0..<4
        {
            if x == index
            {
                //if it was not previously selected then execute the animation, otherwise do nothing
                if (selected != x)
                {
                    DispatchQueue.main.async {
                        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                            self.iconImages [x].frame = self.iconImages [x].frame.offsetBy(dx: 0, dy: -5/375.0*self.screenWidth);
                            self.underline.center.x = self.iconImages [x].center.x;
                        }, completion: nil)
                    }
                }
            }
            else //unselect the other icons
            {
                if (selected == x) //if it was previously selected, then execute the animation
                {
                    DispatchQueue.main.async {
                        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                            self.iconImages [x].frame = self.iconImages [x].frame.offsetBy(dx: 0, dy: 5/375.0*self.screenWidth);
                        }, completion: nil)
                    }
                }
            }
        }
        selected = index!;
    }
    
    //returns the animation necessary for the viewcontrollers
    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return TabBarTransition (viewControllers: tabBarController.viewControllers);
    }
    
    private func initialsetup ()
    {
        setTabBarItems()
        setUpTabBarIcons();
        setUpUnderline()
        //set it as not the first time launching the app
        UserDefaults.standard.set(true, forKey: "notFirstTimeLaunch");
        UserDataSettings.updateAll()
    }
    
    private func update ()
    {
        //makes the tab bar transparent
        tabBar.backgroundImage = UIImage();
        tabBar.shadowImage = UIImage ();
        tabBar.backgroundColor = .white;
        if #available(iOS 13.0, *)
        {
            if (XOrLater())
            {
                tabBar.frame.origin.y = 697/812.0*screenHeight;
                tabBar.frame.size.height = screenHeight - tabBar.frame.origin.y;
            }
            else
            {
                tabBar.frame.origin.y = 697/812.0*screenHeight;
                tabBar.frame.size.height = screenHeight - tabBar.frame.origin.y;
            }
        }
        else
        {
            tabBar.frame.origin = CGPoint (x: 35.375/375.0*screenWidth, y: 727/812.0*screenHeight);
            tabBar.frame.size = CGSize(width: 304.25/375.0*screenWidth, height: 52/375.0*screenWidth);
            tabBar.layer.cornerRadius = tabBar.frame.height/4;
            tabBar.dropShadow()
        }
    }
    
    //add the tab bar items to the corresponding view controllers
    private func setTabBarItems ()
    {
        //since we need to animate the images, the tab bar item's image is set to nil and we just put images free of constraint of the tab bar
        if let numcontrollers = viewControllers?.count
        {
            for x in 0..<numcontrollers
            {
                viewControllers? [x].tabBarItem = UITabBarItem (title: nil, image: nil, selectedImage: nil);
            }
        }
    }
    
    //set up the images used for icons
    private func setUpTabBarIcons ()
    {
        iconImages.append (homeIcon);
        iconImages.append (scheduleIcon);
        iconImages.append (newsIcon);
        iconImages.append (settingsIcon);
        for each in iconImages
        {
            view.addSubview(each);
        }
        
        if #available(iOS 13.0, *)
        {
            homeIcon.frame.size = CGSize (width: 22/375.0*screenWidth, height: 22/375.0*screenWidth);
            scheduleIcon.frame.size = CGSize (width: 47/375.0*screenWidth, height: 47/375.0*screenWidth);
            newsIcon.frame.size = CGSize (width: 47/375.0*screenWidth, height: 47/375.0*screenWidth);
            settingsIcon.frame.size = CGSize(width: 22/375.0*screenWidth, height: 22/375.0*screenWidth);
            
            homeIcon.frame.origin = CGPoint (x: 56.125/375.0*screenWidth, y: 767.5/812.0*screenHeight - (XOrLater() ? 14/812.0*screenHeight : 0));
            scheduleIcon.frame.origin = CGPoint (x: 121.875/375.0*screenWidth, y: 752/812.0*screenHeight - (XOrLater() ? 10/812.0*screenHeight : 0));
            newsIcon.frame.origin = CGPoint (x: 206.125/375.0*screenWidth, y: 752/812.0*screenHeight - (XOrLater() ? 10/812.0*screenHeight : 0));
            settingsIcon.frame.origin = CGPoint (x: 296.875/375.0*screenWidth, y: 767.5/812.0*screenHeight - (XOrLater() ? 14/812.0*screenHeight : 0));
        }
        else
        {
            homeIcon.frame.size = CGSize (width: 22/375.0*screenWidth, height: 22/375.0*screenWidth);
            scheduleIcon.frame.size = CGSize (width: 47/375.0*screenWidth, height: 47/375.0*screenWidth);
            newsIcon.frame.size = CGSize (width: 47/375.0*screenWidth, height: 47/375.0*screenWidth);
            settingsIcon.frame.size = CGSize(width: 22/375.0*screenWidth, height: 22/375.0*screenWidth);
            
            homeIcon.frame.origin = CGPoint (x: 71.125/375.0*screenWidth, y: 745.5/812.0*screenHeight - (XOrLater() ? 4/812.0*screenHeight : 0));
            scheduleIcon.frame.origin = CGPoint (x: 128.875/375.0*screenWidth, y: 730/812.0*screenHeight);
            newsIcon.frame.origin = CGPoint (x: 199.125/375.0*screenWidth, y: 730/812.0*screenHeight);
            settingsIcon.frame.origin = CGPoint (x: 281.875/375.0*screenWidth, y: 745.5/812.0*screenHeight - (XOrLater() ? 4/812.0*screenHeight : 0));
        }
    }
    
    private func setUpUnderline ()
    {
        //at the beginning, the homescreen is selected, so it should be higher placed
        homeIcon.frame = homeIcon.frame.offsetBy(dx: 0, dy: -5/375.0*screenWidth);
        //the underline should be placed right beneath the image
        //depend on the aspect ratio of the phone:
        if #available(iOS 13.0, *)
        {
            if (XOrLater()) //accounts for some double precision error
            {
                underline.frame.origin.y = 779/812.0*screenHeight;
            }
            else
            {
                underline.frame.origin.y = 796/812.0*screenHeight;
            }
        }
        else
        {
            if (XOrLater()) //accounts for some double precision error
            {
                underline.frame.origin.y = 769/812.0*screenHeight;
            }
            else
            {
                underline.frame.origin.y = 776/812.0*screenHeight;
            }
        }
        underline.center.x = homeIcon.center.x;
        view.addSubview(underline);
    }
    
    private func XOrLater () -> Bool {
        return 812.0/375.0 + 0.1 > screenHeight/screenWidth && screenHeight/screenWidth > 812.0/375.0 - 0.1
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func returnFromToDoList (sender: UIStoryboardSegue) {}
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? SignInViewController
        {
            dest.signedIn = false;
        }
    }
}

//the animation between transition of tab bar items
class TabBarTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    let viewControllers: [UIViewController]?
    let transitionDuration: Double = 0.3
    let screenWidth = UIScreen.main.bounds.width;
    let screenHeight = UIScreen.main.bounds.height;
    
    init (viewControllers: [UIViewController]?)
    {
        self.viewControllers = viewControllers;
    }
    
    //set the animation duration to whatever is specified above
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return TimeInterval(transitionDuration)
    }
    
    //animate the transition
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        //shorten the names so that it's easier to type
        guard let fromVC = transitionContext.viewController(forKey: .from),
            let fromView = fromVC.view,
            let toVC = transitionContext.viewController(forKey: .to),
            let toView = toVC.view
        else {
            transitionContext.completeTransition(false)
            return
        }
        
        //since the background without anyview is black, this is just for padding the view so that it seems like the background is white
        let whiteView = UIView ();
        whiteView.backgroundColor = .white;
        whiteView.frame = fromView.frame;
        
        //the animation
        DispatchQueue.main.async {
            transitionContext.containerView.addSubview(whiteView); //adds the white padding view
            transitionContext.containerView.sendSubviewToBack(whiteView); //sends it to the very bottom for padding
            transitionContext.containerView.addSubview(toView) //add the view destination
            fromView.layer.opacity = 1; //set the original opacity so that the destination view is not visible and the original view is visible
            toView.layer.opacity = 0;
            
            //makse sure no unnecessary animations are present
            fromView.layoutIfNeeded()
            toView.layoutIfNeeded()
            
            //set animations target constraints
            if let source = fromVC as? UINavigationController,
                let dest = toVC as? UINavigationController
            {
                if let source = source.topViewController as? MainPageViewController
                {
                    if (dest.topViewController as? ScheduleViewController) != nil
                    {
                        source.profileLeading.constant = 0;
                        source.profileTop.constant = 0;
                        source.view.layoutIfNeeded();
                        source.profileTop.constant = -self.screenHeight/2;
                    }
                    else if (dest.topViewController as? NewsViewController) != nil || dest.topViewController as? SettingsViewController != nil
                    {
                        source.profileTop.constant = 0;
                        source.profileLeading.constant = 0;
                        source.view.layoutIfNeeded();
                        source.profileLeading.constant = -self.screenWidth;
                    }
                    source.nextClassCenter.constant = self.screenWidth;
                    source.nextDaysCenter.constant = -self.screenWidth;
                }
                if let dest = dest.topViewController as? MainPageViewController
                {
                    if (source.topViewController as? ScheduleViewController) != nil
                    {
                        dest.profileLeading.constant = 0;
                        dest.profileTop.constant = -self.screenHeight/2
                        dest.view.layoutIfNeeded()
                        dest.profileTop.constant = 0;
                    }
                    else if (source.topViewController as? NewsViewController) != nil || source.topViewController as? SettingsViewController != nil
                    {
                        dest.profileLeading.constant = -self.screenWidth;
                        dest.profileTop.constant = 0;
                        dest.view.layoutIfNeeded()
                        dest.profileLeading.constant = 0;
                    }
                    dest.nextClassCenter.constant = 0;
                    dest.nextDaysCenter.constant = 0;
                }
            }
            
            //perform the animations
            UIView.animate(withDuration: self.transitionDuration, delay: 0, options: .curveEaseOut, animations: {
                fromView.layoutIfNeeded()  //animates constraints
                toView.layoutIfNeeded()    //animates constraints
                fromView.layer.opacity = 0;  //animates the opacity
                toView.layer.opacity = 1;
            }, completion: { (Finished) in
                if (Finished)
                {
                    fromView.removeFromSuperview()  //if transition is finished (not interrupted) then remove the source view and padding from superview
                    whiteView.removeFromSuperview()  //leaving only the destination view visible
                }
                transitionContext.completeTransition(Finished)  //pass in the boolean as a parameter to indicate if the transition is finished or not
            })
        }
    }
}
