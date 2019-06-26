//
//  TodayToTomorrowAnimator.swift
//  TimeStamp
//
//  Created by Jacky He on 2019-06-23.
//  Copyright © 2019 Baker Jackson. All rights reserved.
//

import UIKit

class TodayToTomorrowAnimator: NSObject {

}

extension TodayToTomorrowAnimator: UIViewControllerAnimatedTransitioning
{
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.6
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let source = transitionContext.viewController(forKey: .from), let dest = transitionContext.viewController (forKey: .to)
        else {return}
        let container = transitionContext.containerView
        
        let screenWidth = UIScreen.main.bounds.size.width;
        let screenHeight = UIScreen.main.bounds.size.height;
        
        //navigationController.pushViewController(dest, animated: false)
        
        dest.view.frame = CGRect (x: screenWidth, y: 0, width: screenWidth, height: screenHeight)
        container.insertSubview (dest.view, aboveSubview: source.view)
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            source.view.frame = source.view.frame.offsetBy(dx: -screenWidth, dy: 0);
            dest.view.frame = dest.view.frame.offsetBy(dx: -screenWidth, dy: 0);
        }) { (Finished) in
            let didComplete = !transitionContext.transitionWasCancelled
            transitionContext.completeTransition(didComplete);
        }
    }
}
