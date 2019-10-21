//
//  LogInToGetStarted.swift
//  TimeStamp
//
//  Created by Jacky He on 2019-08-12.
//  Copyright © 2019 Baker Jackson. All rights reserved.
//

import UIKit

class LogInToGetStarted: UIStoryboardSegue
{
    let screenWidth = UIScreen.main.bounds.size.width;
    let screenHeight = UIScreen.main.bounds.size.height;
    
    override func perform ()
    {
        let firstControllerView = self.source.view;
        let secondControllerView = self.destination.view;
        
        if let window = UIApplication.shared.keyWindow
        {
            window.insertSubview (secondControllerView!, aboveSubview: firstControllerView!)
            let fromVC = self.source as! SignInViewController;
            let toVC = self.destination as! GetStartedViewController;
            
            fromVC.imageWidth.constant = 0;
            
            toVC.view.layer.opacity = 0;
            toVC.imageTop.constant -= self.screenHeight/2;
            toVC.imageLeading.constant -= self.screenWidth/2;
            toVC.view.layoutIfNeeded();
            toVC.imageTop.constant += self.screenHeight/2;
            toVC.imageLeading.constant += self.screenWidth/2;
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations:
            {
                fromVC.view.layoutIfNeeded()
                fromVC.imageView.layer.opacity = 0;
                toVC.view.layoutIfNeeded();
                toVC.view.layer.opacity = 1;
            }, completion:
            {
                (Finished) in
                self.destination.modalPresentationStyle = .fullScreen;
                self.source.present(self.destination, animated: false, completion: nil)
            })
        }
    }
}
