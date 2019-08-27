//
//  TodayViewController.swift
//  Portal
//
//  Created by Jacky He on 2019-08-26.
//  Copyright © 2019 Baker Jackson. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    
    lazy var nextPeriodView = NextPeriodView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        extensionContext?.widgetLargestAvailableDisplayMode = .expanded

        // Do any additional setup after loading the view.
    }
    
    private func setup ()
    {

        view.addSubview(nextPeriodView);
        nextPeriodView.translatesAutoresizingMaskIntoConstraints = false;
        nextPeriodView.centerXAnchor.constraint (equalTo: view.centerXAnchor).isActive = true;
        nextPeriodView.centerYAnchor.constraint (equalTo: view.centerYAnchor).isActive = true;
        nextPeriodView.widthAnchor.constraint(equalToConstant: 334).isActive = true;
        nextPeriodView.heightAnchor.constraint(equalToConstant: 54).isActive = true;
        nextPeriodView.layoutIfNeeded()
        nextPeriodView.layer.cornerRadius = nextPeriodView.frame.height/2;
    }

    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        let expanded = activeDisplayMode == .expanded
        preferredContentSize = expanded ? CGSize(width: maxSize.width, height: 200) : maxSize
    }
    
}
