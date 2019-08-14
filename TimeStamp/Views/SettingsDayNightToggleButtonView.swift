//
//  SettingsDayNightToggleButtonView.swift
//  TimeStamp
//
//  Created by Jacky He on 2019-08-13.
//  Copyright © 2019 Baker Jackson. All rights reserved.
//

import UIKit

class SettingsDayNightToggleButtonView: UIView
{
    let screenWidth = UIScreen.main.bounds.width;
    let screenHeight = UIScreen.main.bounds.height;
    
    let nightImage = UIImageView(image: UIImage(named: "settingsNightImage"));
    let dayImage = UIImageView (image: UIImage (named: "settingsDayImage"));
    
    override init(frame: CGRect) {
        super.init (frame: frame);
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init (coder: coder);
    }
    
    var day: Bool = false {
        didSet {
            animate ()
        }
    }
    
    lazy var movingRect: UIView = {
        let view = UIView ()
        view.backgroundColor = .white;
        view.layer.opacity = 0.7
        view.layer.cornerRadius = 15/375.0*screenWidth;
        return view;
    }()
    
    var movingRectLeading = NSLayoutConstraint ()
    
    private func setup ()
    {
        layer.masksToBounds = true;
        clipsToBounds = true;
        
        addSubview(nightImage);
        nightImage.translatesAutoresizingMaskIntoConstraints = false;
        addConstraintsWithFormat("H:|[v0]|", views: nightImage);
        nightImage.topAnchor.constraint (equalTo: topAnchor, constant: -66/812.0*screenHeight).isActive = true;
        nightImage.heightAnchor.constraint(equalToConstant: 198.56/812.0*screenHeight).isActive = true;
        
        addSubview(dayImage);
        dayImage.translatesAutoresizingMaskIntoConstraints = false;
        addConstraintsWithFormat("H:|[v0]|", views: dayImage);
        dayImage.topAnchor.constraint (equalTo: topAnchor, constant: -66/812.0*screenHeight).isActive = true;
        dayImage.heightAnchor.constraint (equalToConstant: 200.1/812.0*screenHeight).isActive = true;
        
        addSubview(movingRect);
        movingRect.translatesAutoresizingMaskIntoConstraints = false;
        addConstraintsWithFormat("V:|[v0]|", views: movingRect);
        movingRect.widthAnchor.constraint (equalToConstant: 155/375.0*screenWidth).isActive = true;
        movingRectLeading = movingRect.leadingAnchor.constraint (equalTo: leadingAnchor);
        movingRectLeading.isActive = true;
    }
    
    private func animate ()
    {
        DispatchQueue.main.async {
            if (self.day)
            {
                self.movingRectLeading.constant = 154/375.0*self.screenWidth;
                self.dayImage.layer.opacity = 0;
                self.nightImage.layer.opacity = 1;
                UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
                    self.layoutIfNeeded()
                    self.dayImage.layer.opacity = 1;
                    self.nightImage.layer.opacity = 0;
                }, completion: nil)
            }
            else
            {
                self.movingRectLeading.constant = 0;
                self.dayImage.layer.opacity = 1;
                self.nightImage.layer.opacity = 0;
                UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
                    self.layoutIfNeeded()
                    self.dayImage.layer.opacity = 0;
                    self.nightImage.layer.opacity = 1;
                }, completion: nil)
            }
        }
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
