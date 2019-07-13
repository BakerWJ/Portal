//
//  TaskListView.swift
//  TimeStamp
//
//  Created by Jacky He on 2019-07-09.
//  Copyright © 2019 Baker Jackson. All rights reserved.
//

import UIKit

class TaskListView: UITableView, UITableViewDelegate
{
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style);
        setup ();
    }
    
    required init?(coder: NSCoder) {
        super.init (coder: coder);
    }
    
    private func setup ()
    {
        backgroundColor = UIColor(red: 243.0/255, green: 243.0/255, blue: 243.0/255, alpha: 1.0);
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
