//
//  Events.swift
//  TimeStamp
//
//  Created by Jacky He on 2019-05-24.
//  Copyright © 2019 Baker Jackson. All rights reserved.
//

import UIKit
import FirebaseAuth
import GoogleSignIn
import GTMAppAuth
/*
//warning: do not try to add any height constraint to this, but any other constraints should be fine
//time, event, details
class EventView: UIStackView {
    
    var startTime = Date();
    var endTime = Date();
    let timeLabel = UILabel();
    let titleLabel = UILabel();
    let detailLabel = UILabel();
    
    weak var delegate: MainPageViewController?

    //gets the screenheight and width
    var screenHeight = UIScreen.main.bounds.size.height;
    var screenWidth = UIScreen.main.bounds.size.width;
    
    //the dot that separates every event
    let dot = UIImageView(image: UIImage (named: "Ellipse 17"));
    
    //formats date
    let formatter = DateFormatter()
    
    init (event: Event, delegate: MainPageViewController)
    {
        super.init (frame: CGRect())
        formatter.dateFormat = "h:mm a";
        self.startTime = event.startTime as Date;
        self.endTime = event.endTime as Date;
        self.titleLabel.text = event.title;
        self.detailLabel.text = event.detail;
        self.delegate = delegate;
        setup();
    }
    
    init (startTime: Date, endTime: Date, title: String, detail: String, delegate: MainPageViewController)
    {
        super.init (frame: CGRect())
        formatter.dateFormat = "h:mm a";
        self.startTime = startTime;
        self.endTime = endTime;
        self.titleLabel.text = title;
        self.detailLabel.text = detail;
        self.delegate = delegate;
        setup();
        
    }

    override init (frame: CGRect)
    {
        super.init (frame: frame);
    }
    required init (coder: NSCoder)
    {
        super.init(coder: coder);
    }
    
    private func setup()
    {
        isUserInteractionEnabled = true;
        //the gesturerecognizer that gets triggered when the user taps and gives other options for operation on the event
        //sets up the gesture recognizer
        let recognizer = UILongPressGestureRecognizer(target: self, action: #selector(pressed));
        recognizer.minimumPressDuration = 0.8;
        addGestureRecognizer(recognizer);
        
        //setup the stack view
        axis = .vertical;
        spacing = 2;
        distribution = .fill;
        alignment = .center
        
        //configure the labels
        titleLabel.font = UIFont (name: "SegoeUI", size: 16/812.0*screenHeight);
        titleLabel.textAlignment = .center;
        titleLabel.textColor = .black;
        titleLabel.numberOfLines = 0;
        
        detailLabel.font = UIFont (name: "SegoeUI-Italic", size: 14/812.0*screenHeight);
        detailLabel.textAlignment = .center;
        detailLabel.textColor = .black
        detailLabel.numberOfLines = 0;
        
        timeLabel.text = formatter.string(from: startTime) + " - " + formatter.string (from: endTime);
        timeLabel.font = UIFont (name: "SegoeUI", size: 14/812.0*screenHeight);
        timeLabel.textAlignment = .center;
        timeLabel.textColor = UIColor(red: 132/255.0, green: 132/255.0, blue: 132/255.0, alpha: 1);
        timeLabel.numberOfLines = 0;
        
        //add the views in order
        addArrangedSubview(titleLabel);
        addArrangedSubview(detailLabel);
        addArrangedSubview(timeLabel);
        addArrangedSubview(dot)
        
        //add constraints
        timeLabel.translatesAutoresizingMaskIntoConstraints = false;
        titleLabel.translatesAutoresizingMaskIntoConstraints = false;
        detailLabel.translatesAutoresizingMaskIntoConstraints = false;
        dot.translatesAutoresizingMaskIntoConstraints = false;
        
        titleLabel.widthAnchor.constraint (equalToConstant: 0.8*screenWidth).isActive = true;
        titleLabel.centerXAnchor.constraint (equalTo: centerXAnchor).isActive = true;
        
        detailLabel.widthAnchor.constraint (equalToConstant: 0.8*screenWidth).isActive = true;
        detailLabel.centerXAnchor.constraint (equalTo: centerXAnchor).isActive = true;
        
        timeLabel.widthAnchor.constraint (equalToConstant: 0.8*screenWidth).isActive = true;
        timeLabel.centerXAnchor.constraint (equalTo: centerXAnchor).isActive = true;
        
        dot.centerXAnchor.constraint (equalTo: centerXAnchor).isActive = true;
        dot.widthAnchor.constraint (equalToConstant: 12/812.0*screenHeight).isActive = true;
        dot.heightAnchor.constraint (equalToConstant: 12/812.0*screenHeight).isActive = true;
    }
    
    @objc func pressed (gesture: UILongPressGestureRecognizer)
    {
        if (gesture.state == .began)
        {
            let pressedLocation = gesture.location (in: delegate?.view);
            //delegate?.eventPressed(startTime: startTime, endTime: endTime, title: titleLabel.text, detail: detailLabel.text, xpos: pressedLocation.x, ypos: pressedLocation.y)
        }
    }
}
*/
