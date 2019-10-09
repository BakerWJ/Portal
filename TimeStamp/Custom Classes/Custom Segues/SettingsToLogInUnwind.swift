//
//  SettingsToLogInUnwind.swift
//  TimeStamp
//
//  Created by Jacky He on 2019-09-01.
//  Copyright © 2019 Baker Jackson. All rights reserved.
//

import UIKit

class SettingsToLogInUnwind: UIStoryboardSegue {
    
    override func perform()
    {
        var fromVC : UIViewController? = self.source;
        let toVC = self.destination;
        
        
        if let window = UIApplication.shared.keyWindow
        {
            window.insertSubview (toVC.view!, aboveSubview: fromVC!.view!)
        }
        
        var temp = fromVC?.presentingViewController;
        fromVC?.dismiss(animated: false, completion: {
            fromVC = temp;
            if (!(fromVC === toVC) && fromVC != nil)
            {
                temp = fromVC?.presentingViewController;
                fromVC?.dismiss(animated: false, completion: {
                    fromVC = temp;
                    if (!(fromVC === toVC) && fromVC != nil)
                    {
                        temp = fromVC?.presentingViewController;
                        fromVC?.dismiss(animated: false, completion: {
                            fromVC = temp;
                            if (!(fromVC === toVC) && fromVC != nil)
                            {
                                temp = fromVC?.presentingViewController
                                fromVC?.dismiss(animated: false, completion: nil);
                            }
                        })
                    }
                })
            }
        })
    }
}
