//
//  TaskEventMenu.swift
//  TimeStamp
//
//  Created by Jacky He on 2019-07-09.
//  Copyright © 2019 Baker Jackson. All rights reserved.
//

import UIKit

class TaskEventMenu: UIView
{
    var selectedFirst: Bool = true {
        didSet {
            if (selectedFirst)
            {
                taskButton.backgroundColor = UIColor (red: 219/255.0, green: 103/255.0, blue: 103/255.0, alpha: 1);
                taskButton.isSelected = true;
                eventButton.backgroundColor = .clear;
                eventButton.isSelected = false;
            }
            else
            {
                taskButton.backgroundColor = .clear;
                taskButton.isSelected = false;
                eventButton.backgroundColor = UIColor (red: 219/255.0, green: 103/255.0, blue: 103/255.0, alpha: 1);
                eventButton.isSelected = true;
            }
        }
    }
    //initializes task button and sets its properties
    let taskButton: UIButton = {
        let button = UIButton();
        button.setTitle("Tasks", for: .normal);
        button.setTitle("Tasks", for: .selected);
        button.backgroundColor = UIColor (red: 219/255.0, green: 103/255.0, blue: 103/255.0, alpha: 1);
        button.setTitleColor(.black, for: .normal);
        button.setTitleColor(.white, for: .selected);
        button.setTitleColor(.white, for: .highlighted);
        button.setTitleColor(.white, for: [.selected, .highlighted])
        button.addTarget(self, action: #selector (tappedTask), for: .touchDown);
        button.titleLabel?.font = UIFont (name: "SegoeUI-Bold", size: 20/812.0*UIScreen.main.bounds.height);
        return button;
    }()
    
    //initializes task button and sets its properties
    let eventButton: UIButton = {
        let button = UIButton();
        button.setTitle("Events", for: .normal);
        button.setTitle("Events", for: .selected);
        button.backgroundColor = .clear;
        button.setTitleColor(.black, for: .normal);
        button.setTitleColor(.white, for: .selected);
        button.setTitleColor(.white, for: .highlighted);
        button.setTitleColor(.white, for: [.selected, .highlighted])
        button.addTarget(self, action: #selector (tappedEvent), for: .touchDown);
        button.titleLabel?.font = UIFont (name: "SegoeUI-Bold", size: 20/812.0*UIScreen.main.bounds.height);
        return button;
    }()
    
    override init(frame: CGRect) {
        super.init (frame: frame);
        setup ();
    }
    required init?(coder: NSCoder) {
        super.init (coder: coder);
    }
    
    private func setup ()
    {
        //set background color to clear;
        backgroundColor = .clear;
        
        selectedFirst = true;
        addSubview (taskButton);
        addSubview(eventButton);
        
        //set constraints
        taskButton.translatesAutoresizingMaskIntoConstraints = false;
        eventButton.translatesAutoresizingMaskIntoConstraints = false;
        
        taskButton.leadingAnchor.constraint (equalTo: leadingAnchor).isActive = true;
        taskButton.widthAnchor.constraint (equalTo: widthAnchor, multiplier: 0.5).isActive = true;
        taskButton.heightAnchor.constraint (equalTo: heightAnchor).isActive = true;
        taskButton.centerYAnchor.constraint (equalTo: centerYAnchor).isActive = true;
        
        eventButton.trailingAnchor.constraint (equalTo: trailingAnchor).isActive = true;
        eventButton.widthAnchor.constraint (equalTo: widthAnchor, multiplier: 0.5).isActive = true;
        eventButton.heightAnchor.constraint (equalTo: heightAnchor).isActive = true;
        eventButton.centerYAnchor.constraint (equalTo: centerYAnchor).isActive = true;
    }
    
    @objc func tappedTask ()
    {
        selectedFirst = true;
    }
    
    @objc func tappedEvent ()
    {
        selectedFirst = false;
    }
    
    func roundCorners ()
    {
        taskButton.layoutIfNeeded()
        let maskLayer = CAShapeLayer()
        maskLayer.path = UIBezierPath(roundedRect: taskButton.bounds, byRoundingCorners: [.topLeft, .bottomLeft], cornerRadii: CGSize(width: taskButton.frame.height/2, height: taskButton.frame.height/2)).cgPath
        taskButton.layer.mask = maskLayer
        
        eventButton.layoutIfNeeded()
        let maskLayer2 = CAShapeLayer()
        maskLayer2.path = UIBezierPath(roundedRect: taskButton.bounds, byRoundingCorners: [.topRight, .bottomRight], cornerRadii: CGSize(width: eventButton.frame.height/2, height: eventButton.frame.height/2)).cgPath
        eventButton.layer.mask = maskLayer2
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
