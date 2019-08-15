//
//  SettingsSpecificNotifButtonView.swift
//  TimeStamp
//
//  Created by Jacky He on 2019-08-14.
//  Copyright © 2019 Baker Jackson. All rights reserved.
//

import UIKit

class SettingsSpecificNotifButtonView: UIView {

    let screenWidth = UIScreen.main.bounds.width;
    let screenHeight = UIScreen.main.bounds.height;
    
    let blueView = UIView ()
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.textColor = .white;
        label.font = UIFont(name: "SitkaBanner-Bold", size: 14/375.0*screenWidth);
        label.textAlignment = .center;
        label.baselineAdjustment = .alignCenters;
        label.backgroundColor = .clear;
        return label;
    }()
    
    override init(frame: CGRect) {
        super.init (frame: frame);
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init (coder: coder);
    }
    
    var blueViewHeight = NSLayoutConstraint()
    var blueViewWidth = NSLayoutConstraint()
    
    var text : String = "" {
        didSet {
            label.text = text;
        }
    }
    
    var isSelected: Bool = false {
        didSet {
            animate()
        }
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        blueView.layer.cornerRadius = blueView.frame.height/2;
    }
    
    private func setup ()
    {
        clipsToBounds = true;
        layer.masksToBounds = true;
        
        backgroundColor = UIColor.getColor(242, 242, 242);
        addSubview(blueView);
        blueView.translatesAutoresizingMaskIntoConstraints = false;
        blueView.centerXAnchor.constraint (equalTo: centerXAnchor).isActive = true;
        blueView.centerYAnchor.constraint (equalTo: centerYAnchor).isActive = true;
        blueViewHeight = blueView.heightAnchor.constraint (equalToConstant: 29/812.0*screenHeight);
        blueViewHeight.isActive = true;
        blueViewWidth = blueView.widthAnchor.constraint (equalToConstant: 120/375.0*screenWidth);
        blueViewWidth.isActive = true;
        blueView.backgroundColor = UIColor.getColor(40, 73, 164);
        
        addSubview(label);
        label.translatesAutoresizingMaskIntoConstraints = false;
        addConstraintsWithFormat("V:|[v0]|", views: label);
        addConstraintsWithFormat("H:|[v0]|", views: label);
    }
    
    private func animate ()
    {
        DispatchQueue.main.async {
            self.blueViewWidth.constant = self.isSelected ? 117/375.0*self.screenWidth : 0;
            self.blueViewHeight.constant = self.isSelected ? 29/812.0*self.screenHeight : 0;
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
                self.layoutIfNeeded()
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
