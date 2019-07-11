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
    override func viewDidLoad()
    {
        super.viewDidLoad()
        selectedIndex = defaultIndex;
        self.delegate = self;
        
        //makes the tab bar transparent
        tabBar.backgroundImage = UIImage();
        tabBar.shadowImage = UIImage ();
        tabBar.backgroundColor = .clear;
        // Do any additional setup after loading the view.
        
        //set it as not the first time launching the app
        UserDefaults.standard.set(true, forKey: "notFirstTimeLaunch");
        UserDataSettings.updateAll()
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

}
