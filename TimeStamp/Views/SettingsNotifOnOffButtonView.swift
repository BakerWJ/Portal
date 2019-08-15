//
//  SettingsNotifOnOffButtonView.swift
//  TimeStamp
//
//  Created by Jacky He on 2019-08-14.
//  Copyright © 2019 Baker Jackson. All rights reserved.
//

import UIKit

class SettingsNotifOnOffButtonView: UIView {

    let screenWidth = UIScreen.main.bounds.width;
    let screenHeight = UIScreen.main.bounds.height;
    
    lazy var onLabel : UILabel = {
        let label = UILabel()
        label.text = "On";
        label.font = UIFont (name: "SitkaBanner-Bold", size: 14/375.0*screenWidth);
        label.textAlignment = .center;
        label.textColor = .white;
        label.backgroundColor = .clear;
        label.baselineAdjustment = .alignCenters;
        return label;
    }()
    
    lazy var offLabel : UILabel = {
        let label = UILabel()
        label.text = "Off";
        label.font = UIFont (name: "SitkaBanner-Bold", size: 14/375.0*screenWidth);
        label.textAlignment = .center;
        label.textColor = UIColor.getColor(130, 130, 130);
        label.baselineAdjustment = .alignCenters;
        label.backgroundColor = .clear;
        return label;
    }()
    
    let movingRect = UIView()
    
    override init(frame: CGRect) {
        super.init (frame: frame)
        setup()
    }
    
    required init?(coder : NSCoder) {
        super.init (coder: coder)
    }
    
    var on : Bool  = true {
        didSet {
            animate()
        }
    }
    
    var movingRectLeading = NSLayoutConstraint()
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        movingRect.layer.cornerRadius = movingRect.frame.height/2;
        movingRect.dropShadow();
    }
    
    private func setup()
    {
        backgroundColor = .white;
        clipsToBounds = false;
        layer.masksToBounds = false;
        
        addSubview(movingRect);
        movingRect.translatesAutoresizingMaskIntoConstraints = false;
        movingRectLeading = movingRect.leadingAnchor.constraint (equalTo: leadingAnchor);
        movingRectLeading.isActive = true;
        addConstraintsWithFormat("V:|[v0]|", views: movingRect);
        movingRect.widthAnchor.constraint (equalToConstant: 37/375.0*screenWidth).isActive = true;
        movingRect.backgroundColor = UIColor.getColor(40, 73, 164);
        
        addSubview (onLabel);
        onLabel.translatesAutoresizingMaskIntoConstraints = false;
        onLabel.leadingAnchor.constraint (equalTo: leadingAnchor).isActive = true;
        onLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5).isActive = true;
        addConstraintsWithFormat("V:|[v0]|", views: onLabel);
        
        addSubview(offLabel);
        offLabel.translatesAutoresizingMaskIntoConstraints = false;
        offLabel.widthAnchor.constraint (equalTo: widthAnchor, multiplier: 0.5).isActive = true;
        offLabel.trailingAnchor.constraint (equalTo: trailingAnchor).isActive = true;
        addConstraintsWithFormat("V:|[v0]|", views: offLabel);
    }
    
    private func animate ()
    {
        DispatchQueue.main.async {
            self.movingRectLeading.constant = self.on ? 0 : 33/375.0*self.screenWidth;
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
                self.layoutIfNeeded()
                self.backgroundColor = self.on ? .white : UIColor.getColor(242, 242, 242);
            }, completion: nil)
        }
        DispatchQueue.main.async {
            UIView.transition(with: self.onLabel, duration: 0.5, options: .transitionCrossDissolve, animations: {
                self.onLabel.textColor = self.on ? .white : UIColor.getColor(189, 189, 189);
            }, completion: nil)
        }
        DispatchQueue.main.async {
            UIView.transition(with: self.offLabel, duration: 0.5, options: .transitionCrossDissolve, animations: {
                self.offLabel.textColor = self.on ? UIColor.getColor(130, 130, 130) : .white;
            }, completion: nil)
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
