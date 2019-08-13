//
//  GetStartedToSetUp.swift
//  TimeStamp
//
//  Created by Jacky He on 2019-08-12.
//  Copyright © 2019 Baker Jackson. All rights reserved.
//

import UIKit

class GetStartedToSetUp: UIStoryboardSegue {
    let screenWidth = UIScreen.main.bounds.width;
    let screenHeight = UIScreen.main.bounds.height;
    
    override func perform()
    {
        let firstControllerView = self.source.view;
        let secondControllerView = self.destination.view;
        
        if let window = UIApplication.shared.keyWindow
        {
            window.insertSubview (secondControllerView!, aboveSubview: firstControllerView!)
            let fromVC = self.source as! GetStartedViewController
            let toVC = self.destination as! SetUpViewController
            
            toVC.view.layer.opacity = 0;
            fromVC.movingRectTrailing.constant = 0;
            fromVC.view.layoutIfNeeded()
            fromVC.movingRectTrailing.constant += screenWidth;
            
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations:
            {
                fromVC.view.layoutIfNeeded();
                toVC.view.layer.opacity = 1;
            }, completion:
                {
                    (Finished) in
                    self.source.present(self.destination, animated: false, completion: nil)
                    fromVC.movingRectTrailing.constant = 0;
            })
        }
    }
}
