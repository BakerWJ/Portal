//
//  VerticalUpShiftTransitionUnwind.swift
//  TimeStamp
//
//  Created by Jacky He on 2019-05-24.
//  Copyright © 2019 Baker Jackson. All rights reserved.
//

import UIKit

class VerticalUpShiftTransitionUnwind: UIStoryboardSegue {
    override func perform()
    {
        let firstControllerView = self.source.view;
        let secondControllerView = self.destination.view;
        
        let screenWidth = UIScreen.main.bounds.size.width;
        let screenHeight = UIScreen.main.bounds.size.height;
        
        secondControllerView?.frame = CGRect (x: 0, y: -screenHeight, width: screenWidth, height: screenHeight)
        if let window = UIApplication.shared.keyWindow
        {
            window.insertSubview (secondControllerView!, aboveSubview: firstControllerView!)
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations:
                {
                    firstControllerView?.frame = (firstControllerView?.frame)!.offsetBy(dx: 0, dy: screenHeight)
                    secondControllerView?.frame = (secondControllerView?.frame)!.offsetBy (dx: 0, dy: screenHeight)
            }, completion:
                {
                    (Finished) in
                    self.source.navigationController?.popViewController (animated: false);
                    self.source.dismiss(animated: false, completion: nil)
            })
        }
    }
}
