//
//  Events.swift
//  TimeStamp
//
//  Created by Jacky He on 2019-05-24.
//  Copyright © 2019 Baker Jackson. All rights reserved.
//

import UIKit

//warning: do not try to add any height constraint to this, but any other constraints should be fine
class Event: UIView {

    let heading = UILabel();
    let subheading = UILabel();
    var screenHeight: CGFloat?
    let dot = UIImageView(image: UIImage (named: "Ellipse 17"));
    
    init (heading: String, subheading: String, screenHeight: CGFloat)
    {
        super.init(frame: CGRect());
        setup()
        self.heading.text = heading;
        self.subheading.text = subheading;
        self.screenHeight = screenHeight;
    }
    
    override init (frame: CGRect)
    {
        super.init (frame: frame);
    }
    required init?(coder: NSCoder)
    {
        super.init(coder: coder);
    }
    
    private func setup()
    {
        addSubview (heading);
        addSubview (subheading);
        addSubview (dot);
        heading.translatesAutoresizingMaskIntoConstraints = false;
        subheading.translatesAutoresizingMaskIntoConstraints = false;
        dot.translatesAutoresizingMaskIntoConstraints = false;
        heading.topAnchor.constraint (equalTo: topAnchor).isActive = true;
        heading.centerXAnchor.constraint (equalTo: centerXAnchor).isActive = true;
        heading.widthAnchor.constraint (equalTo: widthAnchor).isActive = true;
        heading.numberOfLines = 0;
        heading.textAlignment = .center
        heading.font = UIFont (name: "SegoeUI", size: 16.0/812.0*screenHeight!);
        heading.textColor = .black;
        
        subheading.topAnchor.constraint (equalTo: heading.bottomAnchor).isActive = true;
        subheading.centerXAnchor.constraint (equalTo: centerXAnchor).isActive = true;
        subheading.widthAnchor.constraint (equalTo: widthAnchor).isActive = true;
        subheading.numberOfLines = 0;
        subheading.textAlignment = .center;
        subheading.font = UIFont(name: "SegoeUI", size: 14.0/812.0*screenHeight!)
        subheading.textColor = UIColor (red: 132/255.0, green: 132.0/255, blue: 132.0/255, alpha: 1.0);
        
        dot.centerXAnchor.constraint (equalTo: centerXAnchor).isActive = true;
        dot.topAnchor.constraint (equalTo: subheading.bottomAnchor, constant: 9/812.0*screenHeight!);
        dot.widthAnchor.constraint (equalToConstant: 12.0/812*screenHeight!);
    }
}
