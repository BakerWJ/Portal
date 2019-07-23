//
//  AppEntryViewController.swift
//  TimeStamp
//
//  Created by Catherine He on 2019-07-22.
//  Copyright © 2019 Baker Jackson. All rights reserved.
//

import UIKit

class AppEntryViewController: UIViewController {

    
    let screenWidth = UIScreen.main.bounds.width;
    let screenHeight = UIScreen.main.bounds.height;
    
    lazy var letsgoButton: UIButton = {
        let button = UIButton();
        button.setTitle("Let's Go!", for: .normal);
        button.setTitle("Let's Go!", for: .highlighted);
        button.setTitleColor(UIColor(red: 40/255.0, green: 73/255.0, blue: 164/255.0, alpha: 1), for: .normal);
        button.setTitleColor(UIColor(red: 40/255.0, green: 73/255.0, blue: 164/255.0, alpha: 1), for: .highlighted);
        button.titleLabel?.font = UIFont(name: "SitkaBanner-Bold", size: 20/375.0*screenWidth);
        button.backgroundColor = .white;
        button.frame = CGRect(x: 34/375.0*screenWidth, y: 734/375.0*screenWidth, width: 307/375.0*screenWidth, height: 45/375.0*screenWidth);
        button.layer.cornerRadius = 15/375.0*screenWidth;
        button.addTarget(self, action: #selector (enterApp), for: .touchUpInside);
        button.dropShadow();
        return button;
    }()
    
    lazy var bottomBlue: UIView = {
        let view = UIView ();
        view.backgroundColor = UIColor(red: 40/255.0, green: 73/255.0, blue: 164/255.0, alpha: 1);
        return view;
    }()
    
    lazy var welcomeToPortalLabel: UILabel = {
        let label = UILabel ();
        //the extra space is just so that it shows welcome to on the same line and portal on a separate line
        label.text = "Welcome to Portal.     ";
        label.textColor = .white;
        label.backgroundColor = .clear;
        label.font = UIFont (name: "SitkaBanner", size: 42/812.0*screenHeight);
        label.textAlignment = .left;
        label.baselineAdjustment = .alignCenters;
        label.numberOfLines = 2;
        return label;
    }()
    
    let entryCampImage = UIImageView (image: UIImage(named: "entryScreenCampImage"));
    
    //helps animate the blueview up
    var blueViewBottom = NSLayoutConstraint()
  
    override func viewDidLoad() {
        super.viewDidLoad()
        setup ()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startAnimations ();
    }
    
    private func setup ()
    {
        view.backgroundColor = .white;
        view.addSubview (bottomBlue);
        bottomBlue.translatesAutoresizingMaskIntoConstraints = false;
        bottomBlue.leadingAnchor.constraint (equalTo: view.leadingAnchor).isActive = true;
        bottomBlue.trailingAnchor.constraint (equalTo: view.trailingAnchor).isActive = true;
        bottomBlue.heightAnchor.constraint (equalToConstant: 226/812.0*screenHeight).isActive = true;
        //this blue view is initially below the bottom
        blueViewBottom = bottomBlue.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 226/812.0*screenHeight);
        blueViewBottom.isActive = true;
        //sets the rounded corner of the top two corner
        bottomBlue.layoutIfNeeded()
        let maskLayer = CAShapeLayer()
        maskLayer.path = UIBezierPath(roundedRect: bottomBlue.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 30/812.0*screenHeight, height: 30/812.0*screenHeight)).cgPath
        bottomBlue.layer.mask = maskLayer
        bottomBlue.layer.masksToBounds = true;
        
        bottomBlue.addSubview(letsgoButton);
        letsgoButton.translatesAutoresizingMaskIntoConstraints = false;
        letsgoButton.centerXAnchor.constraint (equalTo: bottomBlue.centerXAnchor).isActive = true;
        letsgoButton.bottomAnchor.constraint(equalTo: bottomBlue.bottomAnchor, constant: -33/812.0*screenHeight).isActive = true;
        letsgoButton.widthAnchor.constraint (equalToConstant: 307/375.0*screenWidth).isActive = true;
        letsgoButton.heightAnchor.constraint (equalToConstant: 45/812.0*screenHeight).isActive = true;
        
        //adds welcome to portal label
        bottomBlue.addSubview(welcomeToPortalLabel);
        welcomeToPortalLabel.translatesAutoresizingMaskIntoConstraints = false;
        welcomeToPortalLabel.leadingAnchor.constraint (equalTo: bottomBlue.leadingAnchor, constant: 42/375.0*screenWidth).isActive = true;
        welcomeToPortalLabel.bottomAnchor.constraint (equalTo: bottomBlue.bottomAnchor, constant: -88/812.0*screenHeight).isActive = true;
        welcomeToPortalLabel.widthAnchor.constraint (equalToConstant: 295/812.0*screenHeight).isActive = true;
        welcomeToPortalLabel.heightAnchor.constraint (equalToConstant: 112/812.0*screenHeight).isActive = true;
        
        //adds the entryCamp image (initially hidden)
        view.addSubview(entryCampImage);
        entryCampImage.translatesAutoresizingMaskIntoConstraints = false;
        entryCampImage.topAnchor.constraint (equalTo: view.topAnchor, constant: -22/812.0*screenHeight).isActive = true;
        entryCampImage.leadingAnchor.constraint (equalTo: view.leadingAnchor, constant: -49/812.0*screenHeight).isActive = true;
        entryCampImage.heightAnchor.constraint (equalToConstant: 690/812.0*screenHeight).isActive = true;
        entryCampImage.widthAnchor.constraint (equalToConstant: 553/812.0*screenHeight).isActive = true;
        //hides the image at the start
        entryCampImage.isHidden = true;
        entryCampImage.layer.opacity = 0;
    }
    
    private func startAnimations ()
    {
        //being the bottomBlueview to the top
        view.bringSubviewToFront(bottomBlue);
        showBottomBlue()
        showEntryCampImage()
    }
    
    private func showEntryCampImage ()
    {
        entryCampImage.isHidden = false;
        DispatchQueue.main.async {
            UIView.animate (withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
                self.entryCampImage.layer.opacity = 1;
            }, completion: nil);
        }
    }
    
    private func showBottomBlue ()
    {
        DispatchQueue.main.async {
            self.blueViewBottom.constant = 0;
            UIView.animate (withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
                self.view.layoutIfNeeded();
            }, completion: nil);
        }
    }
    
    @objc func enterApp ()
    {
        performSegue(withIdentifier: "enterApp", sender: self);
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

