//
//  AnimatingButtonView.swift
//  TimeStamp
//
//  Created by Jacky He on 2019-08-12.
//  Copyright © 2019 Baker Jackson. All rights reserved.
//

import UIKit

class AnimatingButtonView: UIView
{
    
    let screenHeight = UIScreen.main.bounds.height;
    let screenWidth = UIScreen.main.bounds.width;
    
    lazy var blueView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.getColor(40, 73, 164);
        return view;
    }()
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear;
        label.textColor = .black;
        label.textAlignment = .center;
        label.font = UIFont(name: "Georgia", size: 20/375.0*screenWidth);
        label.numberOfLines = 1;
        return label;
    }()
    
    override init(frame: CGRect)
    {
        super.init(frame: frame);
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder);
    }
    
    var isSelected: Bool = true {
        didSet {
            animate ()
        }
    }
    
    var text : String = "" {
        didSet {
            label.text = text;
        }
    }
    
    var blueViewWidth = NSLayoutConstraint()
    
    private func setup()
    {
        backgroundColor = UIColor.getColor(242, 242, 242);
        clipsToBounds = true;
        layer.cornerRadius = 10/375.0*screenWidth;
        
        addSubview(blueView);
        blueView.translatesAutoresizingMaskIntoConstraints = false;
        blueView.leadingAnchor.constraint (equalTo: leadingAnchor).isActive = true;
        blueView.topAnchor.constraint (equalTo: topAnchor).isActive = true;
        blueView.bottomAnchor.constraint (equalTo: bottomAnchor).isActive = true;
        blueViewWidth = blueView.widthAnchor.constraint (equalToConstant: 231/375.0*screenWidth);
        blueViewWidth.isActive = true;
        
        addSubview (label);
        label.translatesAutoresizingMaskIntoConstraints = false;
        label.textColor = .white;
        addConstraintsWithFormat("H:|[v0]|", views: label);
        addConstraintsWithFormat("V:|[v0]|", views: label);
    }
    
    private func animate ()
    {
        DispatchQueue.main.async {
            self.layoutIfNeeded();
            self.blueViewWidth.constant = (self.isSelected ? self.frame.width : 0.5/375.0*self.screenWidth);
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
                self.layoutIfNeeded()
            }, completion: nil);
        }
        DispatchQueue.main.async {
            UIView.transition(with: self.label, duration: 0.3, options: .transitionCrossDissolve, animations: {
                self.label.textColor = (self.isSelected ? .white : .black);
            }, completion: nil);
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
