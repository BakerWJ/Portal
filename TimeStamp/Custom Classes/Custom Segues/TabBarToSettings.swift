//
//  tabBarToSettings.swift
//  TimeStamp
//
//  Created by Jacky He on 2019-08-14.
//  Copyright © 2019 Baker Jackson. All rights reserved.
//

import UIKit

class TabBarToSettings: UIStoryboardSegue {

    let screenWidth = UIScreen.main.bounds.size.width;
    let screenHeight = UIScreen.main.bounds.size.height;
    
    override func perform()
    {
        let fromVC = self.source as! MainTabBarViewController;
        let toVC = self.destination as! SettingsViewController;
        
        if let window = UIApplication.shared.keyWindow
        {
            let tempView = UIView();
            tempView.backgroundColor = .clear;
            tempView.clipsToBounds = true;
            window.insertSubview(tempView, aboveSubview: fromVC.view!);
            tempView.translatesAutoresizingMaskIntoConstraints = false;
            tempView.centerXAnchor.constraint (equalTo: window.leadingAnchor, constant: 309.5/375.0*screenWidth).isActive = true;
            tempView.centerYAnchor.constraint (equalTo: window.topAnchor, constant: 759.5/812.0*screenHeight).isActive = true;
            tempView.tag = 100;
            let tempViewWidth = tempView.widthAnchor.constraint (equalToConstant: 51/375.0*screenWidth);
            tempViewWidth.isActive = true;
            tempView.heightAnchor.constraint(equalTo: tempView.widthAnchor).isActive = true;
            tempView.layoutIfNeeded();
            tempView.layer.cornerRadius = tempView.frame.height/2;
            
            tempView.addSubview(toVC.view);
            toVC.view.translatesAutoresizingMaskIntoConstraints = false;
            toVC.view.topAnchor.constraint (equalTo: window.topAnchor).isActive = true;
            toVC.view.leadingAnchor.constraint (equalTo: window.leadingAnchor).isActive = true;
            toVC.view.trailingAnchor.constraint (equalTo: window.trailingAnchor).isActive = true;
            toVC.view.bottomAnchor.constraint (equalTo: window.bottomAnchor).isActive = true;
            
            window.layoutIfNeeded()
            toVC.view.layer.opacity = 0;
            tempViewWidth.constant = 2000/375.0*screenWidth;
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations:
            {
                toVC.view.layer.opacity = 1;
                window.layoutIfNeeded();
                tempView.layer.cornerRadius = tempView.frame.height/2;
                fromVC.settingsButton.frame = fromVC.settingsButton.frame.offsetBy(dx: self.screenWidth, dy: 0);
            }) {
                (Finished) in
                if (Finished)
                {
                    window.insertSubview(toVC.view, aboveSubview: tempView);
                    self.source.present(self.destination, animated: false, completion: nil)
                    fromVC.settingsButton.frame = fromVC.settingsButton.frame.offsetBy(dx: -self.screenWidth, dy: 0);
                    tempViewWidth.isActive = false;
                }
            }
        }
    }
}
