//
//  SettingsViewController.swift
//  TimeStamp
//
//  Created by Baker Jackson on 2019-04-29.
//  Copyright © 2019 Baker Jackson. All rights reserved.
//

import UIKit
import CoreData
import GoogleSignIn
import FirebaseAuth
import UserNotifications

class SettingsViewController: UIViewController {
    
    var settings: Settings?
    
    var unwind = false;
    
    let screenWidth = UIScreen.main.bounds.width;
    let screenHeight = UIScreen.main.bounds.height;
    
    //this is a temperary placeholder for the back button
    lazy var backButton: UIButton = {
        let button = UIButton ();
        button.setBackgroundImage(UIImage(named: "backButton"), for: .normal);
        button.addTarget(self, action: #selector (back), for: .touchUpInside);
        return button;
    }()
    
    //this could be the sign out button if you decide to use it
    lazy var creditsButton: UIButton = {
        let button = UIButton ();
        button.backgroundColor = UIColor(red: 40/255.0, green: 73/255.0, blue: 164/255.0, alpha: 1);
        button.setTitleColor(.white, for: .normal);
        button.setTitleColor(.white, for: .highlighted);
        button.setTitle("Credits", for: .normal);
        button.titleLabel?.font = UIFont(name: "SitkaBanner", size: 20/375.0*screenWidth);
        button.setTitle("Credits", for: .highlighted);
        button.addTarget(self, action: #selector (toCredit), for: .touchUpInside);
        return button;
    }()
    
    lazy var restartButton : UIButton = {
        let button = UIButton ();
        button.backgroundColor = UIColor(red: 40/255.0, green: 73/255.0, blue: 164/255.0, alpha: 1);
        button.setTitleColor(.white, for: .normal);
        button.setTitleColor(.white, for: .highlighted);
        button.setTitle("Restart Setup", for: .normal);
        button.titleLabel?.font = UIFont(name: "SitkaBanner", size: 20/375.0*screenWidth);
        button.setTitle("Restart Setup", for: .highlighted);
        button.addTarget(self, action: #selector (restart), for: .touchUpInside);
        return button;
    }()
    
    lazy var notificationLabel : UILabel = {
        let label = UILabel()
        label.text = "Notifications";
        label.numberOfLines = 1;
        label.textAlignment = .left;
        label.baselineAdjustment = .alignCenters
        label.font = UIFont (name: "SitkaBanner", size: 20/375.0*screenWidth);
        label.backgroundColor = .clear;
        return label;
    }()
    
    let topContainerView = UIView ()
    let topWhiteContainerView = UIView ()
    
    //white container view at the bottom
    let bottomWhiteContainerView = UIView()
    let timeSlider = SettingsDayNightToggleButtonView()
    let onOffButton = SettingsNotifOnOffButtonView()
    let slider = SettingsDaysBeforeSlider()
    
    //the four buttons for notification options
    let generalNotif = SettingsSpecificNotifButtonView ()
    let articlesNotif = SettingsSpecificNotifButtonView()
    let houseNotif = SettingsSpecificNotifButtonView()
    let surveysNotif = SettingsSpecificNotifButtonView()
    
    var notifButtons = [SettingsSpecificNotifButtonView]()
    
    //for animation
    var topContainerTop = NSLayoutConstraint()
    var bottomWhiteContainerTop = NSLayoutConstraint()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup ()
    {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default);
        self.navigationController?.navigationBar.shadowImage = UIImage();
        self.navigationController?.navigationBar.isTranslucent = true
        let navView = self.navigationController?.view;
        
        view.backgroundColor = UIColor.getColor(242, 242, 242);
        //self.setNeedsStatusBarAppearanceUpdate()
        
        view.addSubview (bottomWhiteContainerView);
        bottomWhiteContainerView.backgroundColor = .white;
        bottomWhiteContainerView.translatesAutoresizingMaskIntoConstraints = false;
        view.addConstraintsWithFormat("H:|[v0]|", views: bottomWhiteContainerView);
        bottomWhiteContainerView.bottomAnchor.constraint (equalTo: view.bottomAnchor).isActive = true;
        bottomWhiteContainerTop = bottomWhiteContainerView.topAnchor.constraint (equalTo: view.topAnchor, constant: 581/812.0*screenHeight);
        bottomWhiteContainerTop.isActive = true;
        //add rounded corners
        bottomWhiteContainerView.layoutIfNeeded()
        let maskLayer = CAShapeLayer()
        let rect = CGRect(origin: bottomWhiteContainerView.bounds.origin, size: CGSize(width: bottomWhiteContainerView.bounds.width, height: bottomWhiteContainerView.bounds.height + 100/812.0*screenHeight))
        maskLayer.path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 15/375.0*screenWidth, height: 15/375.0*screenWidth)).cgPath
        bottomWhiteContainerView.layer.mask = maskLayer
        
        
        view.addSubview(backButton);
        backButton.translatesAutoresizingMaskIntoConstraints = false;
        backButton.topAnchor.constraint (equalTo: view.topAnchor, constant: 740/812.0*screenHeight).isActive = true;
        backButton.widthAnchor.constraint (equalToConstant: 45/375.0*screenWidth).isActive = true;
        backButton.heightAnchor.constraint (equalTo: backButton.widthAnchor).isActive = true;
        backButton.leadingAnchor.constraint (equalTo: view.leadingAnchor, constant: 30/375.0*screenWidth).isActive = true;
        
        view.addSubview(creditsButton);
        creditsButton.translatesAutoresizingMaskIntoConstraints = false;
        creditsButton.centerXAnchor.constraint (equalTo: view.centerXAnchor).isActive = true;
        creditsButton.topAnchor.constraint (equalTo: view.topAnchor, constant: 600/812.0*screenHeight).isActive = true;
        creditsButton.heightAnchor.constraint (equalToConstant: 41/375.0*screenWidth).isActive = true;
        creditsButton.widthAnchor.constraint (equalToConstant: 267/375.0*screenWidth).isActive = true;
        creditsButton.layoutIfNeeded();
        creditsButton.layer.cornerRadius = creditsButton.frame.height/3;
        
        view.addSubview (restartButton);
        restartButton.translatesAutoresizingMaskIntoConstraints = false;
        restartButton.centerXAnchor.constraint (equalTo: view.centerXAnchor).isActive = true;
        restartButton.topAnchor.constraint (equalTo: view.topAnchor, constant: 662/812.0*screenHeight).isActive = true;
        restartButton.heightAnchor.constraint (equalToConstant: 41/375.0*screenWidth).isActive = true;
        restartButton.widthAnchor.constraint (equalToConstant: 267/375.0*screenWidth).isActive = true;
        restartButton.layoutIfNeeded();
        restartButton.layer.cornerRadius = restartButton.frame.height/3;
        
        view.addSubview(topContainerView);
        topContainerView.translatesAutoresizingMaskIntoConstraints = false;
        view.addConstraintsWithFormat("H:|[v0]|", views: topContainerView);
        topContainerTop = topContainerView.topAnchor.constraint (equalTo: view.topAnchor);
        topContainerTop.isActive = true;
        topContainerView.heightAnchor.constraint (equalToConstant: 530/812.0*screenHeight).isActive = true;
        topContainerView.layoutIfNeeded()
        let maskLayer2 = CAShapeLayer()
        maskLayer2.path = UIBezierPath(roundedRect: topContainerView.bounds, byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: CGSize(width: 15/375.0*screenWidth, height: 15/375.0*screenWidth)).cgPath
        topContainerView.layer.mask = maskLayer2
        
        view.addSubview (notificationLabel);
        notificationLabel.translatesAutoresizingMaskIntoConstraints = false;
        notificationLabel.topAnchor.constraint (equalTo: view.topAnchor, constant: 57/812.0*screenHeight).isActive = true;
        notificationLabel.leadingAnchor.constraint (equalTo: view.leadingAnchor, constant: 31.81/375.0*screenWidth).isActive = true;
        notificationLabel.widthAnchor.constraint(equalToConstant: 110/375.0*screenWidth).isActive = true;
        notificationLabel.heightAnchor.constraint(equalToConstant: 25/812.0*screenHeight).isActive = true;
        
        view.addSubview(timeSlider);
        timeSlider.translatesAutoresizingMaskIntoConstraints = false;
        timeSlider.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true;
        timeSlider.widthAnchor.constraint (equalToConstant: 309/375.0*screenWidth).isActive = true;
        timeSlider.heightAnchor.constraint (equalToConstant: 85/812.0*screenHeight).isActive = true;
        timeSlider.topAnchor.constraint (equalTo: view.topAnchor, constant: 403/812.0*screenHeight).isActive = true;
        timeSlider.layer.cornerRadius = 15/375.0*screenWidth;
        let tg = UITapGestureRecognizer(target: self, action: #selector (timeChange))
        timeSlider.addGestureRecognizer(tg);
        
        navView!.addSubview(onOffButton);
        onOffButton.translatesAutoresizingMaskIntoConstraints = false;
        onOffButton.centerXAnchor.constraint (equalTo: navView!.centerXAnchor).isActive = true;
        onOffButton.widthAnchor.constraint(equalToConstant: 66/375.0*screenWidth).isActive = true;
        onOffButton.heightAnchor.constraint(equalToConstant: 22/812.0*screenHeight).isActive = true;
        onOffButton.centerYAnchor.constraint(equalTo: navView!.topAnchor, constant: 69.5/812.0*screenHeight).isActive = true;
        let tg2 = UITapGestureRecognizer(target: self, action: #selector (allNotif));
        onOffButton.addGestureRecognizer(tg2);
        onOffButton.layoutIfNeeded();
        onOffButton.layer.cornerRadius = onOffButton.frame.height/2;
        
        view.addSubview(topWhiteContainerView);
        topWhiteContainerView.translatesAutoresizingMaskIntoConstraints = false;
        topWhiteContainerView.centerXAnchor.constraint (equalTo: view.centerXAnchor).isActive = true;
        topWhiteContainerView.widthAnchor.constraint(equalToConstant: 320/375.0*screenWidth).isActive = true;
        topWhiteContainerView.heightAnchor.constraint (equalToConstant: 260/812.0*screenHeight).isActive = true;
        topWhiteContainerView.topAnchor.constraint (equalTo: view.topAnchor, constant: 101/812.0*screenHeight).isActive = true;
        topWhiteContainerView.layer.cornerRadius = 15/375.0*screenWidth;
        topWhiteContainerView.layoutIfNeeded();
        topWhiteContainerView.backgroundColor = .white;
        topWhiteContainerView.dropShadow();
        
        notifButtons.append (generalNotif);
        notifButtons.append (houseNotif);
        notifButtons.append (articlesNotif);
        notifButtons.append (surveysNotif);
        
        for each in notifButtons
        {
            view.addSubview(each);
            each.translatesAutoresizingMaskIntoConstraints = false;
            each.widthAnchor.constraint (equalToConstant: 120/375.0*screenWidth).isActive = true;
            each.heightAnchor.constraint(equalToConstant: 29/812.0*screenHeight).isActive = true;
            each.layoutIfNeeded();
            each.layer.cornerRadius = each.frame.height/2;
        }
        generalNotif.topAnchor.constraint (equalTo: topWhiteContainerView.topAnchor, constant: 146/812.0*screenHeight).isActive = true;
        generalNotif.leadingAnchor.constraint (equalTo: topWhiteContainerView.leadingAnchor, constant: 33/375.0*screenWidth).isActive = true;
        generalNotif.text = "General";
        let gr1 = UITapGestureRecognizer(target: self, action: #selector (generalTapped));
        generalNotif.addGestureRecognizer(gr1);
        
        articlesNotif.topAnchor.constraint (equalTo: generalNotif.topAnchor).isActive = true;
        articlesNotif.trailingAnchor.constraint (equalTo: topWhiteContainerView.trailingAnchor, constant: -33/375.0*screenWidth).isActive = true;
        articlesNotif.text = "Articles";
        let gr2 = UITapGestureRecognizer(target: self, action: #selector (articlesTapped))
        articlesNotif.addGestureRecognizer(gr2);
        
        houseNotif.topAnchor.constraint (equalTo: topWhiteContainerView.topAnchor, constant: 185/812.0*screenHeight).isActive = true;
        houseNotif.leadingAnchor.constraint (equalTo: generalNotif.leadingAnchor).isActive = true;
        houseNotif.text = "House";
        let gr3 = UITapGestureRecognizer(target: self, action: #selector (houseTapped));
        houseNotif.addGestureRecognizer(gr3);
        
        surveysNotif.trailingAnchor.constraint (equalTo: articlesNotif.trailingAnchor).isActive = true;
        surveysNotif.topAnchor.constraint (equalTo: houseNotif.topAnchor).isActive = true;
        surveysNotif.text = "Surveys";
        let gr4 = UITapGestureRecognizer (target: self, action: #selector (surveysTapped));
        surveysNotif.addGestureRecognizer(gr4);
        
        view.addSubview(slider);
        slider.translatesAutoresizingMaskIntoConstraints = false;
        slider.centerXAnchor.constraint (equalTo: view.centerXAnchor).isActive = true;
        slider.widthAnchor.constraint(equalToConstant: 231/375.0*screenWidth).isActive = true;
        slider.heightAnchor.constraint(equalToConstant: 74/812.0*screenHeight).isActive = true;
        slider.bottomAnchor.constraint (equalTo: topWhiteContainerView.bottomAnchor, constant: -154/812.0*screenHeight).isActive = true;
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        loadData()
    }
    
    private func loadData()
    {
        guard let setting = UserDataSettings.fetchSettings() else {return}
        timeSlider.day = (setting.notificationTime == 1, false); //second: animated = false
        //select the buttons
        articlesNotif.isSelected = setting.articleNotifications;
        houseNotif.isSelected = setting.houseNotifications;
        generalNotif.isSelected = setting.generalNotifications;
        surveysNotif.isSelected = setting.surveyNotifications;
        
        //if all notification turned off
        if !(setting.articleNotifications || setting.houseNotifications || setting.generalNotifications || setting.surveyNotifications)
        {
            topContainerView.backgroundColor = .white;
            slider.mode(off: true);
            timeSlider.mode(off: true, animated: false);
            onOffButton.on = false;
            
            //set textcolor
            notificationLabel.textColor = .black;
        }
        else //otherwise
        {
            topContainerView.backgroundColor = setting.notificationTime == 1 ? UIColor.getColor(246, 230, 223) : UIColor.getColor(40, 73, 164);
            slider.mode(off: false);
            timeSlider.mode(off: false, animated: false);
            onOffButton.on = true;
            //set text color
            notificationLabel.textColor = setting.notificationTime == 1 ? .black : .white;
        }
        self.view.layoutIfNeeded()
        self.topContainerTop.constant = self.onOffButton.on ? 0 : -147/812.0*self.screenHeight;
        self.bottomWhiteContainerTop.constant = self.onOffButton.on ? 581/812.0*self.screenHeight : 507/812.0*self.screenHeight;
    }
    
    
    //this triggers a unwind segue back to the tab bar controller
    @objc func back ()
    {
        UserDataSettings.setNotifications()
        self.tabBarController?.performSegue(withIdentifier: "fromTabBar", sender: self.tabBarController);
    }
    
    @objc func toCredit ()
    {
        performSegue(withIdentifier: "toCredit", sender: self);
    }
    
    //when making a sign out button, just connect the selector to this function
    //signs the user out of this place and segues to the login view
    private func signOut () {
        do {
            Auth.auth().addStateDidChangeListener { (auth, user) in
                if user == nil {
                    UserDefaults.standard.set(false, forKey: "loggedin");
                    self.unwind = true;
                    self.back();
                }
            }
            try Auth.auth().signOut()
            GIDSignIn.sharedInstance().signOut();
        }
        catch let signOutError as NSError
        {
            print ("Error signing out: %@", signOutError)
            return;
        }
        
    }
    
    @objc func restart ()
    {
        UserDefaults.standard.set(false, forKey: "notFirstTimeLaunch");
        UserDataSettings.eraseAll()
        signOut();
    }
    
    @objc func timeChange ()
    {
        timeSlider.day = (!timeSlider.day.0, true);
        if let setting = UserDataSettings.fetchSettings()
        {
            setting.notificationTime = timeSlider.day.0 ? 1 : 2; //day: 1, night: 2
            CoreDataStack.saveContext()
        }
        UserDataSettings.setNotifications()
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
                self.topContainerView.backgroundColor = self.timeSlider.day.0 ? UIColor.getColor(246, 230, 223) : UIColor.getColor(40, 73, 164);
            }, completion: nil)
        }
        DispatchQueue.main.async {
            UIView.transition(with: self.notificationLabel, duration: 0.5, options: .transitionCrossDissolve, animations: {
                self.notificationLabel.textColor = self.timeSlider.day.0 ? .black : .white;
            }, completion: nil);
        }
    }
    
    @objc func allNotif ()
    {
        onOffButton.on = !onOffButton.on
        allOnOffAnimation()
        for each in notifButtons
        {
            each.isSelected = onOffButton.on;
        }
        if let setting = UserDataSettings.fetchSettings()
        {
            setting.articleNotifications = onOffButton.on;
            setting.generalNotifications = onOffButton.on;
            setting.houseNotifications = onOffButton.on;
            setting.surveyNotifications = onOffButton.on;
            CoreDataStack.saveContext()
        }
        UserDataSettings.setNotifications()
    }
    
    func allOnOffAnimation ()
    {
        slider.mode(off: !onOffButton.on);
        timeSlider.mode(off: !onOffButton.on, animated: true);
        DispatchQueue.main.async {
            UIView.transition(with: self.notificationLabel, duration: 0.5, options: .transitionCrossDissolve, animations: {
                if (self.onOffButton.on)
                {
                    self.notificationLabel.textColor = self.timeSlider.day.0 ? .black : .white;
                }
                else
                {
                    self.notificationLabel.textColor = .black;
                }
            }, completion: nil);
        }
        DispatchQueue.main.async {
            self.topContainerTop.constant = self.onOffButton.on ? 0 : -147/812.0*self.screenHeight;
            self.bottomWhiteContainerTop.constant = self.onOffButton.on ? 581/812.0*self.screenHeight : 507/812.0*self.screenHeight;
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
                if (self.onOffButton.on)
                {
                    self.topContainerView.backgroundColor = self.timeSlider.day.0 ? UIColor.getColor(246, 230, 223) : UIColor.getColor(40, 73, 164);
                }
                else
                {
                    self.topContainerView.backgroundColor = .white;
                }
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    func checkForAllNotif ()
    {
        if !(generalNotif.isSelected || articlesNotif.isSelected || houseNotif.isSelected || surveysNotif.isSelected)
        {
            onOffButton.on = false;
            allOnOffAnimation()
        }
        else if (!onOffButton.on)
        {
            onOffButton.on = true;
            allOnOffAnimation()
        }
    }
    
    @objc func generalTapped()
    {
        generalNotif.isSelected = !generalNotif.isSelected;
        if let setting = UserDataSettings.fetchSettings()
        {
            setting.generalNotifications = generalNotif.isSelected;
            CoreDataStack.saveContext()
        }
        UserDataSettings.setNotifications()
        checkForAllNotif()
    }
    
    @objc func articlesTapped()
    {
        articlesNotif.isSelected = !articlesNotif.isSelected;
        if let setting = UserDataSettings.fetchSettings()
        {
            setting.articleNotifications = articlesNotif.isSelected;
            CoreDataStack.saveContext()
        }
        UserDataSettings.setNotifications()
        checkForAllNotif()
    }
    
    @objc func houseTapped()
    {
        houseNotif.isSelected = !houseNotif.isSelected
        if let setting = UserDataSettings.fetchSettings()
        {
            setting.houseNotifications = houseNotif.isSelected;
            CoreDataStack.saveContext()
        }
        UserDataSettings.setNotifications()
        checkForAllNotif()
    }
    
    @objc func surveysTapped()
    {
        surveysNotif.isSelected = !surveysNotif.isSelected;
        if let setting = UserDataSettings.fetchSettings()
        {
            setting.surveyNotifications = surveysNotif.isSelected;
            CoreDataStack.saveContext()
        }
        UserDataSettings.setNotifications()
        checkForAllNotif()
    }
    
    @IBAction func returnFromCredits (sender: UIStoryboardSegue) {}
}
