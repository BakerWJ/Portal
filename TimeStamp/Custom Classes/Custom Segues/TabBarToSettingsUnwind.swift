//
//  TabBarToSettingsUnwind.swift
//  TimeStamp
//
//  Created by Jacky He on 2019-08-14.
//  Copyright © 2019 Baker Jackson. All rights reserved.
//

import UIKit

class TabBarToSettingsUnwind: UIStoryboardSegue {

    let screenWidth = UIScreen.main.bounds.size.width;
    let screenHeight = UIScreen.main.bounds.size.height;
    
    override func perform()
    {
        let fromVC = self.source as! SettingsViewController
        let toVC = self.destination as! MainTabBarViewController;
        
        if let window = UIApplication.shared.keyWindow
        {
            let tempView = window.viewWithTag(100)!
            tempView.addSubview(fromVC.view);
            window.insertSubview(toVC.view, belowSubview: tempView);
            let tempViewHeight = tempView.heightAnchor.constraint (equalToConstant: 2000/375.0*screenWidth);
            
            tempViewHeight.isActive = true;
            window.layoutIfNeeded()
            tempView.layer.cornerRadius = tempView.frame.height/2;
            tempViewHeight.constant = 51/375.0*screenWidth;
            
            toVC.settingsButton.frame = toVC.settingsButton.frame.offsetBy(dx: screenWidth, dy: 0);
            fromVC.view.layer.opacity = 1;
            
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations:
            {
                toVC.settingsButton.frame = toVC.settingsButton.frame.offsetBy(dx: -self.screenWidth, dy: 0);
                fromVC.view.layer.opacity = 0;
                window.layoutIfNeeded()
                tempView.layer.cornerRadius = tempView.frame.height/2;
            }, completion:
                {
                    (Finished) in
                    self.source.navigationController?.popViewController(animated: false);
                    self.source.dismiss(animated: false, completion: nil)
                    tempView.removeFromSuperview()
            })
        }
    }
}
