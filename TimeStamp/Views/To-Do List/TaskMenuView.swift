//
//  TaskMenuView.swift
//  TimeStamp
//
//  Created by Jacky He on 2019-07-09.
//  Copyright © 2019 Baker Jackson. All rights reserved.
//

import UIKit

class TaskMenuView: UIView
{
    let screenHeight = UIScreen.main.bounds.height;
    let screenWidth = UIScreen.main.bounds.width;
    
    override init (frame: CGRect)
    {
        super.init (frame: frame);
        setup ();
    }
    
    required init?(coder: NSCoder) {
        super.init (coder: coder);
    }
    
    //initialize label that contains user name
    lazy var userName: UILabel = {
        let l = UILabel()
        l.text = UserDefaults.standard.string(forKey: "username");
        l.font = UIFont(name: "SegoeUI-Bold", size: 18/375.0*screenWidth);
        l.numberOfLines = 1;
        l.adjustsFontSizeToFitWidth = true;
        l.backgroundColor = .clear;
        l.textAlignment = .center;
        l.textColor = .black;
        return l;
    }()
    
    //initialize image that contains user image
    lazy var userImage: UIImageView = {
        var image: UIImageView?
        if let data = UserDefaults.standard.data(forKey: "userimage")
        {
            image = UIImageView (image: UIImage (data: data));
            return image!;
        }
        image = UIImageView();
        return image!;
    }()
    
    private func setup ()
    {
        backgroundColor = UIColor(red: 243.0/255, green: 243.0/255, blue: 243.0/255, alpha: 1.0);
        addSubview (userName);
        addSubview (userImage);
        
        //set constraints
        userName.translatesAutoresizingMaskIntoConstraints = false;
        userImage.translatesAutoresizingMaskIntoConstraints = false;
        
        userName.widthAnchor.constraint (equalToConstant: 140/375.0*screenWidth).isActive = true;
        userName.topAnchor.constraint (equalTo: topAnchor, constant: 60/812.0*screenHeight).isActive = true;
        userName.leadingAnchor.constraint (equalTo: leadingAnchor, constant: 40/375.0*screenWidth).isActive = true;
        userName.heightAnchor.constraint (equalToConstant: 60/812.0*screenHeight).isActive = true;
        
        userImage.centerYAnchor.constraint (equalTo: userName.centerYAnchor).isActive = true;
        userImage.heightAnchor.constraint (equalTo: userName.heightAnchor).isActive = true;
        userImage.widthAnchor.constraint (equalTo: userImage.heightAnchor).isActive = true;
        userImage.trailingAnchor.constraint (equalTo: trailingAnchor, constant: -30/375*screenWidth).isActive = true;
        
        //set rounded corner
        userImage.contentMode = .center;
        userImage.layer.cornerRadius = 30/812.0*screenHeight;
        userImage.clipsToBounds = true;
        //caches the image (better performance > worse memory) in this case
        userImage.layer.shouldRasterize = true;
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
