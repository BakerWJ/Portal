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
    lazy var signOutButton: UIButton = {
        let button = UIButton ();
        button.backgroundColor = UIColor(red: 40/255.0, green: 73/255.0, blue: 164/255.0, alpha: 1);
        button.setTitleColor(.white, for: .normal);
        button.setTitleColor(.white, for: .highlighted);
        button.setTitle("Sign Out", for: .normal);
        button.titleLabel?.font = UIFont(name: "SitkaBanner", size: 20/375.0*screenWidth);
        button.setTitle("Sign Out", for: .highlighted);
        button.addTarget(self, action: #selector (signOut), for: .touchUpInside);
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
    
    //white container view at the bottom
    let whiteContainerView = UIView()
    let timeSlider = SettingsDayNightToggleButtonView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup ()
    {
        view.backgroundColor = UIColor.getColor(242, 242, 242);
        //self.setNeedsStatusBarAppearanceUpdate()
        
        view.addSubview (whiteContainerView);
        whiteContainerView.backgroundColor = .white;
        whiteContainerView.translatesAutoresizingMaskIntoConstraints = false;
        view.addConstraintsWithFormat("H:|[v0]|", views: whiteContainerView);
        whiteContainerView.bottomAnchor.constraint (equalTo: view.bottomAnchor).isActive = true;
        whiteContainerView.topAnchor.constraint (equalTo: view.topAnchor, constant: 581/812.0*screenHeight).isActive = true;
        //add rounded corners
        whiteContainerView.layoutIfNeeded()
        let maskLayer = CAShapeLayer()
        maskLayer.path = UIBezierPath(roundedRect: whiteContainerView.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 15/375.0*screenWidth, height: 15/375.0*screenWidth)).cgPath
        whiteContainerView.layer.mask = maskLayer
        
        
        view.addSubview(backButton);
        backButton.translatesAutoresizingMaskIntoConstraints = false;
        backButton.topAnchor.constraint (equalTo: view.topAnchor, constant: 740/812.0*screenHeight).isActive = true;
        backButton.widthAnchor.constraint (equalToConstant: 45/375.0*screenWidth).isActive = true;
        backButton.heightAnchor.constraint (equalTo: backButton.widthAnchor).isActive = true;
        backButton.leadingAnchor.constraint (equalTo: view.leadingAnchor, constant: 30/375.0*screenWidth).isActive = true;
        
        view.addSubview(signOutButton);
        signOutButton.translatesAutoresizingMaskIntoConstraints = false;
        signOutButton.centerXAnchor.constraint (equalTo: view.centerXAnchor).isActive = true;
        signOutButton.topAnchor.constraint (equalTo: view.topAnchor, constant: 619/812.0*screenHeight).isActive = true;
        signOutButton.heightAnchor.constraint (equalToConstant: 41/375.0*screenWidth).isActive = true;
        signOutButton.widthAnchor.constraint (equalToConstant: 267/375.0*screenWidth).isActive = true;
        signOutButton.layoutIfNeeded();
        signOutButton.layer.cornerRadius = signOutButton.frame.height/3;
        
        view.addSubview (restartButton);
        restartButton.translatesAutoresizingMaskIntoConstraints = false;
        restartButton.centerXAnchor.constraint (equalTo: view.centerXAnchor).isActive = true;
        restartButton.topAnchor.constraint (equalTo: view.topAnchor, constant: 681/812.0*screenHeight).isActive = true;
        restartButton.heightAnchor.constraint (equalToConstant: 41/375.0*screenWidth).isActive = true;
        restartButton.widthAnchor.constraint (equalToConstant: 267/375.0*screenWidth).isActive = true;
        restartButton.layoutIfNeeded();
        restartButton.layer.cornerRadius = restartButton.frame.height/3;
        
        view.addSubview(topContainerView);
        topContainerView.translatesAutoresizingMaskIntoConstraints = false;
        topContainerView.topAnchor.constraint (equalTo: view.topAnchor).isActive = true;
        view.addConstraintsWithFormat("H:|[v0]|", views: topContainerView);
        topContainerView.topAnchor.constraint (equalTo: view.topAnchor).isActive = true;
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
        
        loadData ()
    }
    
    private func loadData()
    {
        guard let setting = UserDataSettings.fetchSettings() else {return}
        if !(setting.articleNotifications || setting.houseNotifications || setting.generalNotifications || setting.surveyNotifications)
        {
            topContainerView.backgroundColor = .white;
        }
        else
        {
            topContainerView.backgroundColor = UIColor.getColor(40, 73, 164);
        }
        timeSlider.day = setting.notificationTime == 1;
    }
    
    
    //this triggers a unwind segue back to the tab bar controller
    @objc func back ()
    {
        performSegue (withIdentifier: "returnFromSettings", sender: self);
    }
    
    //when making a sign out button, just connect the selector to this function
    //signs the user out of this place and segues to the login view
    @objc func signOut () {
        do {
            try Auth.auth().signOut()
            GIDSignIn.sharedInstance().signOut();
        }
        catch let signOutError as NSError
        {
            print ("Error signing out: %@", signOutError)
            return;
        }
        UserDefaults.standard.set(false, forKey: "loggedin");
        unwind = true;
        back();
    }
    
    @objc func restart ()
    {
        UserDefaults.standard.set(false, forKey: "notFirstTimeLaunch");
        UserDataSettings.eraseAll()
        signOut();
    }
    
    @objc func timeChange ()
    {
        timeSlider.day = !timeSlider.day;
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
                self.topContainerView.backgroundColor = self.timeSlider.day ? UIColor.getColor(246, 230, 223) : UIColor.getColor(40, 73, 164);
            }, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? MainTabBarViewController
        {
            dest.unwind = unwind;
            unwind = false;
        }
    }
}
