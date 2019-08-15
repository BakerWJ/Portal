//
//  SettingsDaysBeforeSlider.swift
//  TimeStamp
//
//  Created by Jacky He on 2019-08-14.
//  Copyright © 2019 Baker Jackson. All rights reserved.
//

import UIKit

class SettingsDaysBeforeSlider: UIView {
    
    let screenWidth = UIScreen.main.bounds.width;
    let screenHeight = UIScreen.main.bounds.height;
    
    override init(frame: CGRect) {
        super.init (frame: frame);
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init (coder: coder);
    }
    
    let blueToggle = UIView()
    lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal;
        view.alignment = .center
        view.distribution = .equalSpacing
        return view;
    }()
    
    lazy var numLabel : UILabel = {
        let label = UILabel()
        label.text = "1";
        label.font = UIFont(name: "SimSun", size: 40/812.0*screenHeight);
        label.textAlignment = .center;
        label.baselineAdjustment = .alignCenters;
        label.baselineAdjustment = .alignBaselines;
        label.textColor = UIColor.getColor(130, 130, 130);
        label.backgroundColor = .clear;
        return label;
    }()
    
    lazy var dayLabel : UILabel = {
        let label = UILabel()
        label.text = "Day(s)";
        label.font = UIFont(name: "SimSun", size: 20/812.0*screenHeight);
        label.textAlignment = .center;
        label.baselineAdjustment = .alignBaselines;
        label.textColor = UIColor.getColor(130, 130, 130);
        label.backgroundColor = .clear;
        return label;
    }()
    
    let orangeLine = UIView()

    var blueCenter = NSLayoutConstraint()
    
    private func setup ()
    {
        clipsToBounds = false;
        layer.masksToBounds = false;
        
        addSubview(stackView);
        stackView.translatesAutoresizingMaskIntoConstraints = false;
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true;
        stackView.widthAnchor.constraint (equalToConstant: 231/375.0*screenWidth).isActive = true;
        stackView.bottomAnchor.constraint (equalTo: bottomAnchor).isActive = true;
        stackView.heightAnchor.constraint(equalToConstant: 24/375.0*screenWidth).isActive = true;
        
        for _ in 1...3
        {
            let dot = UIView()
            stackView.addArrangedSubview(dot);
            dot.translatesAutoresizingMaskIntoConstraints = false;
            dot.widthAnchor.constraint(equalToConstant: 10/375.0*screenWidth).isActive = true;
            dot.heightAnchor.constraint(equalToConstant: 10/375.0*screenWidth).isActive = true;
            dot.layer.cornerRadius = 5/375.0*screenWidth;
            dot.backgroundColor = UIColor.getColor(223, 168, 144);
        }
        
        addSubview(orangeLine);
        orangeLine.translatesAutoresizingMaskIntoConstraints = false;
        addConstraintsWithFormat("H:|[v0]|", views: orangeLine);
        orangeLine.backgroundColor = UIColor.getColor(223, 168, 144);
        orangeLine.heightAnchor.constraint (equalToConstant: 2/375.0*screenWidth).isActive = true;
        orangeLine.centerYAnchor.constraint(equalTo: stackView.centerYAnchor).isActive = true;
        
        addSubview(blueToggle);
        blueToggle.translatesAutoresizingMaskIntoConstraints = false;
        blueToggle.heightAnchor.constraint(equalToConstant: 24/375.0*screenWidth).isActive = true;
        blueToggle.widthAnchor.constraint(equalTo: blueToggle.heightAnchor).isActive = true;
        blueCenter = blueToggle.centerXAnchor.constraint (equalTo: leadingAnchor, constant: 5/375.0*screenWidth);
        blueCenter.isActive = true;
        blueToggle.centerYAnchor.constraint (equalTo: orangeLine.centerYAnchor).isActive = true;
        let panG = UIPanGestureRecognizer(target: self, action: #selector(panned));
        blueToggle.addGestureRecognizer(panG);
        blueToggle.layoutIfNeeded();
        blueToggle.layer.cornerRadius = blueToggle.frame.height/2;
        blueToggle.backgroundColor = UIColor.getColor(40, 73, 164);
        blueToggle.dropShadow()
        
        addSubview(numLabel);
        numLabel.translatesAutoresizingMaskIntoConstraints = false;
        numLabel.centerXAnchor.constraint (equalTo: centerXAnchor).isActive = true;
        numLabel.topAnchor.constraint (equalTo: topAnchor).isActive = true;
        numLabel.heightAnchor.constraint (equalToConstant: 38/812.0*screenHeight).isActive = true;
        numLabel.widthAnchor.constraint(equalToConstant: 21/375.0*screenWidth).isActive = true;
        
        addSubview(dayLabel);
        dayLabel.translatesAutoresizingMaskIntoConstraints = false;
        dayLabel.leadingAnchor.constraint (equalTo: numLabel.trailingAnchor).isActive = true;
        dayLabel.bottomAnchor.constraint (equalTo: numLabel.bottomAnchor, constant: -5/812.0*screenHeight).isActive = true;
        dayLabel.widthAnchor.constraint(equalToConstant: 80/375.0*screenWidth).isActive = true;
        dayLabel.heightAnchor.constraint(equalToConstant: 20/812.0*screenHeight).isActive = true;
        
        loadData ()
    }
    
    func mode(off: Bool)
    {
        DispatchQueue.main.async {
            self.isUserInteractionEnabled = !off;
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
                self.blueToggle.backgroundColor = off ?  UIColor.getColor(149, 149, 149): UIColor.getColor(40, 73, 164);
            }, completion: nil)
        }
    }
    
    private func loadData ()
    {
        guard let setting = UserDataSettings.fetchSettings() else {return}
        let segment = (226 - 5)/375.0*screenWidth/4;
        let mini = 5/375.0*screenWidth;
        numLabel.text = "\(Int(setting.daysBefore))";
        blueCenter.constant = mini + (CGFloat(setting.daysBefore) - 1.0)*2.0*segment;
    }
    
    @objc func panned (sender: UIPanGestureRecognizer)
    {
        if (sender.state == .ended)
        {
            let segment = (226 - 5)/375.0*screenWidth/4;
            let mini = 5/375.0*screenWidth;
            let settings = UserDataSettings.fetchSettings()!
            if (blueCenter.constant >= mini && blueCenter.constant <= mini + segment) //one day
            {
                blueCenter.constant = mini;
                settings.daysBefore = 1;
                if (numLabel.text != "1")
                {
                    numLabel.pushTransition(0.5);
                    numLabel.text = "1";
                }
            }
            else if (blueCenter.constant >= mini + 3*segment && blueCenter.constant <= mini + 4*segment) //three days
            {
                blueCenter.constant = mini + 4*segment;
                settings.daysBefore = 3;
                if (numLabel.text != "3")
                {
                    numLabel.pushTransition(0.5);
                    numLabel.text = "3";
                }
            }
            else //two day
            {
                blueCenter.constant = mini + 2*segment;
                settings.daysBefore = 2;
                if (numLabel.text != "2")
                {
                    numLabel.pushTransition(0.5);
                    numLabel.text = "2";
                }
            }
            CoreDataStack.saveContext()
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
                    self.layoutIfNeeded();
                }, completion: nil)
            }
        }
        else if (sender.state == .changed)
        {
            let xpos = sender.translation(in: self).x;
            blueCenter.constant = min(226/375.0*screenWidth, max (5/375.0*screenWidth, xpos + blueCenter.constant));
            sender.setTranslation(.zero, in: self)
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
