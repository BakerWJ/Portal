//
//  MainTabBarViewController.swift
//  TimeStamp
//
//  Created by Jacky He on 2019-06-22.
//  Copyright © 2019 Baker Jackson. All rights reserved.
//

import UIKit

class MainTabBarViewController: UITabBarController, UITabBarControllerDelegate {

    @IBInspectable var defaultIndex: Int = 0;
    
    
    //the screen width and height
    let screenWidth = UIScreen.main.bounds.width;
    let screenHeight = UIScreen.main.bounds.height;
    var tabBarItems = [UITabBarItem]()
    
    var unwind = false;
    
    //this is the button to be clicked when go to settings
    lazy var settingsButton: UIView = {
        let view = UIView ();
        //adds the image
        view.frame = CGRect (x: 284/375.0*screenWidth, y: 734/812.0*screenHeight, width: 51/375.0*screenWidth, height: 51/375.0*screenWidth);
        //add the settingsImage
        let image = UIImageView(image: UIImage(named: "settingsTabBarIcon"));
        view.addSubview(image);
        image.frame.size = CGSize(width: 45/375.0*screenWidth, height: 45/375.0*screenWidth);
        image.center = CGPoint (x: view.frame.width/2, y: view.frame.height/2);
        view.clipsToBounds = true;
        view.backgroundColor = .white;
        view.layer.cornerRadius = view.frame.height/2;
        view.dropShadow()
        //adds a gesture recongizer for detecting if clicked
        let gestureRecognizer = UITapGestureRecognizer (target: self, action: #selector (toSettings));
        view.addGestureRecognizer(gestureRecognizer);
        return view;
    }()
    
    lazy var underline: UIView = {
        let view = UIView ();
        view.frame.size = CGSize (width: 22/375.0*screenWidth, height: 2/375.0*screenWidth);
        view.backgroundColor = UIColor (red: 0/255.0, green: 160/255.0, blue: 225/255.0, alpha: 1);
        return view;
    }()
    
    let homeIcon = UIImageView (image: UIImage (named: "homeTabBarIcon"));
    let scheduleIcon = UIImageView (image: UIImage (named: "scheduleTabBarIcon"));
    let newsIcon = UIImageView (image: UIImage (named: "newsTabBarIcon"));
    var iconImages = [UIImageView] ();
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        selectedIndex = defaultIndex;
        self.delegate = self;
        update()
        initialsetup()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews();
        update()
    }

    var selected = 0;
    
    //does some thing when a certain tabbaritem is selected (passed in as a parameter)
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        let index = tabBar.items?.firstIndex(of: item);
        for x in 0..<3
        {
            if x == index
            {
                //if it was not previously selected then execute the animation, otherwise do nothing
                if (selected != x)
                {
                    DispatchQueue.main.async {
                        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseOut, animations: {
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
                        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseOut, animations: {
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
        view.addSubview(settingsButton);
        setTabBarItems()
        setUpTabBarIcons();
        setUpUnderline()
        //set it as not the first time launching the app
        UserDefaults.standard.set(true, forKey: "notFirstTimeLaunch");
        UserDataSettings.updateAll()
    }
    
    private func update ()
    {
        //tabBar positioning
        tabBar.frame = CGRect(x: 34/375.0*screenWidth, y: 737/812.0*screenHeight, width: 217/375.0*screenWidth, height: 46/375.0*screenWidth);
        //makes the tab bar transparent
        tabBar.backgroundImage = UIImage();
        tabBar.shadowImage = UIImage ();
        tabBar.backgroundColor = .white;
        tabBar.layer.cornerRadius = tabBar.frame.height/4;
        tabBar.dropShadow()
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
        for each in iconImages
        {
            view.addSubview(each);
            each.frame.size = CGSize (width: 45/375.0*screenWidth, height: 45/375.0*screenWidth);
        }
        homeIcon.frame.origin = CGPoint (x: 63.5/375.0*screenWidth, y: 736/812.0*screenHeight);
        scheduleIcon.frame.origin = CGPoint (x: 122.5/375.0*screenWidth, y: homeIcon.frame.origin.y);
        newsIcon.frame.origin = CGPoint (x: 180.5/375.0*screenWidth, y: homeIcon.frame.origin.y);
    }
    
    private func setUpUnderline ()
    {
        //at the beginning, the homescreen is selected, so it should be higher placed
        homeIcon.frame = homeIcon.frame.offsetBy(dx: 0, dy: -5/375.0*screenWidth);
        //the underline should be placed right beneath the image
        //depend on the aspect ratio of the phone:
        if (screenHeight/screenWidth == 812.0/375.0)
        {print ("X")
            underline.frame.origin.y = 773/812.0*screenHeight;
        }
        else
        {print ("Y")
            underline.frame.origin.y = 780/812.0*screenHeight;
        }
        underline.center.x = homeIcon.center.x;
        view.addSubview(underline);
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @objc func toSettings ()
    {
        performSegue (withIdentifier: "toSettings", sender: self);
    }
    
    @IBAction func returnFromToDoList (sender: UIStoryboardSegue) {}
    @IBAction func returnFromSettings (sender: UIStoryboardSegue)
    {
        if (unwind)
        {
            unwind = false;
            performSegue(withIdentifier: "fromTabBar", sender: self.tabBarController);
        }
    }
}

//the animation between transition of tab bar items
class TabBarTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    let viewControllers: [UIViewController]?
    let transitionDuration: Double = 0.5
    
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
            UIView.animate(withDuration: self.transitionDuration, animations: {
                fromView.layer.opacity = 0;  //animates the opacity
                toView.layer.opacity = 1;
            }) {
                (Finished) in
                if (Finished)
                {
                    fromView.removeFromSuperview()  //if transition is finished (not interrupted) then remove the source view and padding from superview
                    whiteView.removeFromSuperview()  //leaving only the destination view visible
                }
                transitionContext.completeTransition(Finished)  //pass in the boolean as a parameter to indicate if the transition is finished or not
            }
        }
    }
}
