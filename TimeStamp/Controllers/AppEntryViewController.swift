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
        button.layer.cornerRadius = 15/375.0*screenWidth;
        button.addTarget(self, action: #selector (enterApp), for: .touchUpInside);
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
    
    lazy var holdOnLabel: UILabel = {
        let label = UILabel ();
        label.text = "Hold On..."
        label.textColor = UIColor(red: 40/255.0, green: 73/255.0, blue: 164/255.0, alpha: 1);//blue
        label.backgroundColor = .clear;
        label.textAlignment = .left;
        label.baselineAdjustment = .alignCenters;
        label.font = UIFont (name: "SitkaBanner", size: 42/812.0*screenHeight);
        return label;
    }()
    
    lazy var gettingReady: UILabel = {
        let label = UILabel ();
        label.text = "We're Getting Things Ready..."
        label.textColor = UIColor(red: 40/255.0, green: 73/255.0, blue: 164/255.0, alpha: 1);//blue
        label.backgroundColor = .clear;
        label.textAlignment = .left;
        label.baselineAdjustment = .alignCenters;
        label.numberOfLines = 0;
        label.font = UIFont (name: "SitkaBanner", size: 42/812.0*screenHeight);
        return label;
    }()
    
    lazy var worldAwait: UILabel = {
        let label = UILabel ();
        label.text = "A World Awaits..."
        label.textColor = UIColor(red: 40/255.0, green: 73/255.0, blue: 164/255.0, alpha: 1);//blue
        label.backgroundColor = .clear;
        label.textAlignment = .left;
        label.baselineAdjustment = .alignCenters;
        label.font = UIFont (name: "SitkaBanner", size: 42/812.0*screenHeight);
        return label;
    }()
    
    //this is the window through which the label will animate
    let rectangle: UIView = {
        let view = UIView ();
        view.backgroundColor = .clear;
        view.clipsToBounds = true;
        view.layer.masksToBounds = true;
        return view;
    }()
    
    let trainImage = UIImageView(image: UIImage(named: "trainImage"));
    
    let whiteWavyImage : UIImageView = {
        let image = UIImage(named: "whiteWavyImage");
        let view = UIImageView(image: image);
        view.isUserInteractionEnabled = true
        return view;
    }()
    
    let blueImage : UIImage = {
        var image = UIImage(named: "whiteWavyImage");
        image = image?.imageWithColor(newColor: UIColor(red: 40/255.0, green: 73/255.0, blue: 164/255.0, alpha: 0.95));
        if (image == nil)
        {
            image = UIImage(named: "whiteWavyImage")
        }
        return image!
    }()
    
    lazy var welcomeLabel : UILabel = {
        let label = UILabel()
        label.text = "Welcome to\nPortal.";
        label.numberOfLines = 2;
        label.font = UIFont(name: "SitkaBanner", size: 40/375.0*screenWidth);
        label.textColor = .white;
        label.backgroundColor = .clear;
        label.textAlignment = .left;
        return label;
    }()
    
    let whiteImage = UIImage(named: "whiteWavyImage");
    
    var trainLeading = NSLayoutConstraint ()
    var whiteTop = NSLayoutConstraint()
    var whiteHeight = NSLayoutConstraint()
    var holdOnTop = NSLayoutConstraint()
    var awaitsTop = NSLayoutConstraint()
    var readyTop = NSLayoutConstraint()
    
    var animateExecuted = false;
    
    override func viewDidLoad()
    {
        super.viewDidLoad();
        setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        if (!animateExecuted)
        {
            animateExecuted = true;
            startSequence()
        }
    }
    private func setup ()
    {
        self.setNeedsStatusBarAppearanceUpdate()
        
        view.clipsToBounds = true;
        view.layer.masksToBounds = true;
        
        view.addSubview(trainImage);
        trainImage.translatesAutoresizingMaskIntoConstraints = false;
        trainLeading = trainImage.leadingAnchor.constraint (equalTo: view.leadingAnchor, constant: -33/375.0*screenWidth);
        trainLeading.isActive = true;
        trainImage.topAnchor.constraint (equalTo: view.topAnchor, constant: -74/812.0*screenHeight).isActive = true;
        trainImage.widthAnchor.constraint(equalToConstant: 1264/375.0*screenWidth).isActive = true;
        trainImage.heightAnchor.constraint(equalToConstant: 843/812.0*screenHeight).isActive = true;
        
        view.addSubview (whiteWavyImage);
        whiteWavyImage.translatesAutoresizingMaskIntoConstraints = false;
        whiteWavyImage.leadingAnchor.constraint (equalTo: view.leadingAnchor, constant: -112/375.0*screenWidth).isActive = true;
        whiteTop = whiteWavyImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 511.99/812.0*screenHeight);
        whiteTop.isActive = true;
        whiteHeight = whiteWavyImage.heightAnchor.constraint(equalToConstant: 900.01/812.0*screenHeight);
        whiteHeight.isActive = true;
        whiteWavyImage.widthAnchor.constraint(equalToConstant: 535.31/375.0*screenWidth).isActive = true;
        
        view.addSubview(rectangle);
        rectangle.translatesAutoresizingMaskIntoConstraints = false;
        rectangle.topAnchor.constraint (equalTo: view.topAnchor, constant: 612/812.0*screenHeight).isActive = true;
        rectangle.leadingAnchor.constraint (equalTo: view.leadingAnchor, constant: 42/375.0*screenWidth).isActive = true;
        rectangle.widthAnchor.constraint(equalToConstant: 295/375.0*screenWidth).isActive = true;
        rectangle.heightAnchor.constraint(equalToConstant: 112/812.0*screenHeight).isActive = true;
        
        //add the hold on label
        rectangle.addSubview(holdOnLabel);
        holdOnLabel.translatesAutoresizingMaskIntoConstraints = false;
        holdOnTop = holdOnLabel.topAnchor.constraint (equalTo: rectangle.topAnchor);
        holdOnTop.isActive = true;
        holdOnLabel.leadingAnchor.constraint (equalTo: rectangle.leadingAnchor).isActive = true;
        holdOnLabel.heightAnchor.constraint (equalTo: rectangle.heightAnchor).isActive = true;
        holdOnLabel.widthAnchor.constraint (equalTo: rectangle.widthAnchor).isActive = true;
        
        //add the gettinReady label (initially hidden)
        rectangle.addSubview(gettingReady);
        gettingReady.translatesAutoresizingMaskIntoConstraints = false;
        //initially the topAnchor is below the window
        readyTop = gettingReady.topAnchor.constraint (equalTo: rectangle.topAnchor, constant: 112/812.0*screenHeight);
        readyTop.isActive = true;
        gettingReady.leadingAnchor.constraint (equalTo: rectangle.leadingAnchor).isActive = true;
        gettingReady.heightAnchor.constraint (equalTo: rectangle.heightAnchor).isActive = true;
        gettingReady.widthAnchor.constraint (equalTo: rectangle.widthAnchor).isActive = true;
        
        //add the a world awaits label (initially hidden)
        rectangle.addSubview(worldAwait);
        worldAwait.translatesAutoresizingMaskIntoConstraints = false;
        //initially the topAnchor is below the window
        awaitsTop = worldAwait.topAnchor.constraint (equalTo: rectangle.topAnchor, constant: 112/812.0*screenHeight);
        awaitsTop.isActive = true;
        worldAwait.leadingAnchor.constraint (equalTo: rectangle.leadingAnchor).isActive = true;
        worldAwait.heightAnchor.constraint (equalTo: rectangle.heightAnchor).isActive = true;
        worldAwait.widthAnchor.constraint (equalTo: rectangle.widthAnchor).isActive = true;
        
        whiteWavyImage.addSubview(welcomeLabel);
        whiteWavyImage.clipsToBounds = true;
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false;
        welcomeLabel.centerXAnchor.constraint (equalTo: view.centerXAnchor).isActive = true;
        welcomeLabel.topAnchor.constraint (equalTo: view.topAnchor, constant: 323.5/812.0*screenHeight).isActive = true;
        welcomeLabel.widthAnchor.constraint(equalToConstant: 281/375.0*screenWidth).isActive = true;
        welcomeLabel.heightAnchor.constraint(equalToConstant: 110/812.0*screenHeight).isActive = true;
        welcomeLabel.layer.opacity = 0;
        
        whiteWavyImage.addSubview(letsgoButton);
        letsgoButton.translatesAutoresizingMaskIntoConstraints = false;
        letsgoButton.centerXAnchor.constraint (equalTo: welcomeLabel.centerXAnchor).isActive = true;
        letsgoButton.topAnchor.constraint (equalTo: view.topAnchor, constant: 453/812.0*screenHeight).isActive = true;
        letsgoButton.widthAnchor.constraint(equalToConstant: 307/375.0*screenWidth).isActive = true;
        letsgoButton.heightAnchor.constraint(equalToConstant: 45/812.0*screenHeight).isActive = true;
        letsgoButton.layer.opacity = 0;
        letsgoButton.layoutIfNeeded()
        letsgoButton.dropShadow()
    }
    
    private func startSequence ()
    {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.toReady()
        }
    }
    
    
    private func toReady()
    {
        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseIn, animations: {
            self.trainLeading.constant = -315/375.0*self.screenWidth;
            self.holdOnTop.constant = -112/812.0*self.screenHeight;
            self.readyTop.constant = 0
            self.view.layoutIfNeeded();
        }, completion: { (Finished) in
            self.toAwait()
        })
    }
    
    private func toAwait()
    {
        UIView.animate(withDuration: 1, delay: 1.5, options: .curveEaseIn, animations: {
            self.trainLeading.constant = -519/375.0*self.screenWidth;
            self.readyTop.constant = -112/812.0*self.screenHeight;
            self.awaitsTop.constant = 0
            self.view.layoutIfNeeded()
        }, completion: { (Finished) in
            self.toEnd()
        })
    }
    
    private func toEnd()
    {
        self.gettingReady.layer.opacity = 1;
        UIView.animate(withDuration: 1.5, delay: 0, options: .curveLinear, animations: {
            self.gettingReady.layer.opacity = 0;
        }) { (Finished) in
            UIView.transition(with: self.whiteWavyImage, duration: 1, options: [.transitionCrossDissolve, .curveEaseIn], animations:
                {
                    self.whiteWavyImage.image = self.blueImage;
            }, completion: nil)
            UIView.animate(withDuration: 1, delay: 0, options: .curveEaseIn, animations: {
                self.trainLeading.constant = -889/375.0*self.screenWidth;
                self.awaitsTop.constant = -112/812.0*self.screenHeight;
                self.whiteHeight.constant += 300/812.0*self.screenHeight;
                self.whiteTop.constant = -350/812.0*self.screenHeight;
                self.view.layoutIfNeeded()
                self.letsgoButton.layer.opacity = 1;
                self.welcomeLabel.layer.opacity = 1;
            }, completion: nil)
        }
    }
    
    @objc func enterApp ()
    {
        performSegue(withIdentifier: "enterApp", sender: self);
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent;
    }
    
    /*
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
    
    lazy var holdOnLabel: UILabel = {
        let label = UILabel ();
        label.text = "Hold On..."
        label.textColor = UIColor(red: 40/255.0, green: 73/255.0, blue: 164/255.0, alpha: 1);//blue
        label.backgroundColor = .clear;
        label.textAlignment = .left;
        label.baselineAdjustment = .alignCenters;
        label.font = UIFont (name: "SitkaBanner", size: 42/812.0*screenHeight);
        return label;
    }()
    
    lazy var gettingReady: UILabel = {
        let label = UILabel ();
        label.text = "We're Getting Things Ready..."
        label.textColor = UIColor(red: 40/255.0, green: 73/255.0, blue: 164/255.0, alpha: 1);//blue
        label.backgroundColor = .clear;
        label.textAlignment = .left;
        label.baselineAdjustment = .alignCenters;
        label.numberOfLines = 0;
        label.font = UIFont (name: "SitkaBanner", size: 42/812.0*screenHeight);
        return label;
    }()
    
    lazy var worldAwait: UILabel = {
        let label = UILabel ();
        label.text = "A World Awaits..."
        label.textColor = UIColor(red: 40/255.0, green: 73/255.0, blue: 164/255.0, alpha: 1);//blue
        label.backgroundColor = .clear;
        label.textAlignment = .left;
        label.baselineAdjustment = .alignCenters;
        label.font = UIFont (name: "SitkaBanner", size: 42/812.0*screenHeight);
        return label;
    }()
    
    lazy var circle: UIView = {
        let view = UIView ();
        view.backgroundColor = .white;
        let maskLayer = CAShapeLayer();
        
        //this draws a path with a circle
        var path = CGMutablePath()
        let radius = 465.0/812.0*screenHeight;
        path.addArc(center: CGPoint (x: radius, y: radius), radius: radius, startAngle: 0.0, endAngle: 2.0*CGFloat.pi, clockwise: false);
        //and a rectangle
        path.addRect(CGRect(origin: .zero, size: CGSize (width: 2*radius, height: 2*radius)));
        
        //the fill rule makes the overlapping part transparent and the rest white
        maskLayer.backgroundColor = UIColor.white.cgColor
        maskLayer.path = path;
        maskLayer.fillRule = .evenOdd;
        
        //adds the mask
        view.layer.mask = maskLayer;
        view.clipsToBounds = false;
        view.layer.masksToBounds = false;
        return view;
    }()
    
    //this is the window through which the label will animate
    lazy var rectangle: UIView = {
        let view = UIView ();
        view.backgroundColor = .white;
        let maskLayer = CAShapeLayer();
        //this draws a path for two rectangles
        var path = CGMutablePath()
        path.addRect(CGRect(origin: .zero, size: CGSize (width: screenWidth, height: screenHeight)));
        path.addRect(CGRect(origin: CGPoint (x: 42/812.0*screenHeight, y: 612/812.0*screenHeight), size: CGSize(width: 295/812.0*screenHeight, height: 112/812.0*screenHeight)));
        maskLayer.backgroundColor = UIColor.white.cgColor
        maskLayer.path = path;
        maskLayer.fillRule = .evenOdd;
        //adds the mask
        view.layer.mask = maskLayer;
        view.clipsToBounds = true;
        return view;
    }()
    
    let entryCampImage = UIImageView (image: UIImage(named: "entryScreenCampImage"));
    let entryAirplaneImage = UIImageView (image: UIImage(named: "entryScreenAirportImage"));
    let entryClimbingImage = UIImageView (image: UIImage (named: "entryScreenClimbingImage"));
    let entryMountainImage = UIImageView (image: UIImage(named: "entryScreenMountainImage"));
    
    //helps animate the blueview up
    var blueViewBottom = NSLayoutConstraint()
    //helps animation of labels
    var holdOnTop = NSLayoutConstraint();
    var readyTop = NSLayoutConstraint();
    var awaitsTop = NSLayoutConstraint();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup ()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.startAnimations ();
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent;
    }
    
    private func setup ()
    {
        self.setNeedsStatusBarAppearanceUpdate()
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
        bottomBlue.layer.opacity = 0;
        
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
        entryCampImage.heightAnchor.constraint (equalToConstant: 689.5/812.0*screenHeight).isActive = true;
        entryCampImage.widthAnchor.constraint (equalToConstant: 553/812.0*screenHeight).isActive = true;
        //hides the image at the start
        entryCampImage.layer.opacity = 0;
        
        //add the airplane image (initially not hidden)
        view.addSubview(entryAirplaneImage);
        entryAirplaneImage.translatesAutoresizingMaskIntoConstraints = false;
        entryAirplaneImage.topAnchor.constraint(equalTo: view.topAnchor, constant: -56/812.0*screenHeight).isActive = true;
        entryAirplaneImage.leadingAnchor.constraint (equalTo: view.leadingAnchor, constant: -90/812.0*screenHeight).isActive = true;
        entryAirplaneImage.widthAnchor.constraint (equalToConstant: 892/812.0*screenHeight).isActive = true;
        entryAirplaneImage.heightAnchor.constraint (equalToConstant: 667.5/812.0*screenHeight).isActive = true;
        entryAirplaneImage.layer.opacity = 1;
        
        //add the circle
        view.addSubview (circle);
        circle.translatesAutoresizingMaskIntoConstraints = false;
        circle.topAnchor.constraint (equalTo: view.topAnchor, constant: -318/812.0*screenHeight).isActive = true;
        circle.leadingAnchor.constraint (equalTo: view.leadingAnchor, constant: -128/812.0*screenHeight).isActive = true;
        circle.widthAnchor.constraint (equalToConstant: 930/812.0*screenHeight).isActive = true;
        circle.heightAnchor.constraint (equalToConstant: 930/812.0*screenHeight).isActive = true;
        circle.layoutIfNeeded();
        
        //add the hold on label
        view.addSubview(holdOnLabel);
        holdOnLabel.translatesAutoresizingMaskIntoConstraints = false;
        holdOnTop = holdOnLabel.topAnchor.constraint (equalTo: view.topAnchor, constant: 612/812.0*screenHeight);
        holdOnTop.isActive = true;
        holdOnLabel.leadingAnchor.constraint (equalTo: view.leadingAnchor, constant: 42/812.0*screenHeight).isActive = true;
        holdOnLabel.heightAnchor.constraint (equalToConstant: 112/812.0*screenHeight).isActive = true;
        holdOnLabel.widthAnchor.constraint (equalToConstant: 295/812.0*screenHeight).isActive = true;
        
        //add the gettinReady label (initially hidden)
        view.addSubview(gettingReady);
        gettingReady.translatesAutoresizingMaskIntoConstraints = false;
        //initially the topAnchor is below the window
        readyTop = gettingReady.topAnchor.constraint (equalTo: view.topAnchor, constant: 724/812.0*screenHeight);
        readyTop.isActive = true;
        gettingReady.leadingAnchor.constraint (equalTo: view.leadingAnchor, constant: 42/812.0*screenHeight).isActive = true;
        gettingReady.heightAnchor.constraint (equalToConstant: 112/812.0*screenHeight).isActive = true;
        gettingReady.widthAnchor.constraint (equalToConstant: 295/812.0*screenHeight).isActive = true;
        
        //add the a world awaits label (initially hidden)
        view.addSubview(worldAwait);
        worldAwait.translatesAutoresizingMaskIntoConstraints = false;
        //initially the topAnchor is below the window
        awaitsTop = worldAwait.topAnchor.constraint (equalTo: view.topAnchor, constant: 724/812.0*screenHeight);
        awaitsTop.isActive = true;
        worldAwait.leadingAnchor.constraint (equalTo: view.leadingAnchor, constant: 42/812.0*screenHeight).isActive = true;
        worldAwait.heightAnchor.constraint (equalToConstant: 112/812.0*screenHeight).isActive = true;
        worldAwait.widthAnchor.constraint (equalToConstant: 295/812.0*screenHeight).isActive = true;
        
        //add the climbing image (initially hidden)
        view.addSubview(entryClimbingImage);
        entryClimbingImage.translatesAutoresizingMaskIntoConstraints = false;
        entryClimbingImage.topAnchor.constraint (equalTo: view.topAnchor, constant: -30/812.0*screenHeight).isActive = true;
        entryClimbingImage.leadingAnchor.constraint (equalTo: view.leadingAnchor, constant: -175/812.0*screenHeight).isActive = true;
        entryClimbingImage.widthAnchor.constraint(equalToConstant: 870/812.0*screenHeight).isActive = true;
        entryClimbingImage.heightAnchor.constraint (equalToConstant: 641.5/812.0*screenHeight).isActive = true;
        entryClimbingImage.layer.opacity = 0;
        
        //add the mountain image (initailly hidden)
        view.addSubview(entryMountainImage);
        entryMountainImage.translatesAutoresizingMaskIntoConstraints = false;
        entryMountainImage.topAnchor.constraint (equalTo: view.topAnchor, constant: -90/812.0*screenHeight).isActive = true;
        entryMountainImage.leadingAnchor.constraint (equalTo: view.leadingAnchor).isActive = true;
        entryMountainImage.widthAnchor.constraint (equalToConstant: 468/812.0*screenHeight).isActive = true;
        entryMountainImage.heightAnchor.constraint (equalToConstant: 701.5/812.0*screenHeight).isActive = true;
        entryMountainImage.layer.opacity = 0;
        
        //adds the window of opportunity
        view.addSubview(rectangle);
        rectangle.translatesAutoresizingMaskIntoConstraints = false;
        rectangle.leadingAnchor.constraint (equalTo: view.leadingAnchor).isActive = true;
        rectangle.trailingAnchor.constraint (equalTo: view.trailingAnchor).isActive = true;
        rectangle.bottomAnchor.constraint (equalTo: view.bottomAnchor).isActive = true;
        rectangle.topAnchor.constraint (equalTo: view.topAnchor).isActive = true;
        
        self.view.layoutIfNeeded()
    }
    
    private func startAnimations ()
    {
        //being the bottomBlueview to the top get the proper sequence
        view.bringSubviewToFront(rectangle);
        view.bringSubviewToFront(entryMountainImage);
        view.bringSubviewToFront(entryClimbingImage);
        view.bringSubviewToFront(entryCampImage);
        view.bringSubviewToFront(entryAirplaneImage);
        view.bringSubviewToFront(circle);
        view.bringSubviewToFront(bottomBlue);
        startSequence ();
    }
    
    private func startSequence ()
    {
        holdOnTop.constant = 500/812.0*screenHeight;
        readyTop.constant = 612/812.0*screenHeight;
        
        //remake a path for the circle's mask
        let maskLayer = CAShapeLayer();
            
        //this draws a path with a circle
        let path1 = CGMutablePath()
        let radius1 = 465.0/812.0*self.screenHeight;
        path1.addArc(center: CGPoint (x: radius1, y: radius1), radius: radius1, startAngle: 0.0, endAngle: 2.0*CGFloat.pi, clockwise: false);
        //and a rectangle
        path1.addRect(CGRect(origin: .zero, size: CGSize (width: 2*radius1, height: 2*radius1)));
        
        let path = CGMutablePath()
        let radius = 418.0/812.0*self.screenHeight;
        path.addArc(center: CGPoint (x: radius-191.0/812.0*screenHeight, y: 94.0/812.0*screenHeight+radius), radius: radius, startAngle: 0.0, endAngle: 2.0*CGFloat.pi, clockwise: false);
        //and a rectangle
        path.addRect(CGRect(origin: .zero, size: CGSize (width: 2*radius1, height: 2*radius1)));
        let animation = CABasicAnimation(keyPath: "path");
        animation.fromValue = path1;
        animation.toValue = path;
        animation.duration = 0.8;
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false;
        animation.timingFunction = CAMediaTimingFunction(name: .easeIn);
        animation.beginTime = CACurrentMediaTime() + 1.9;
        animation.autoreverses = false;
        //the fill rule makes the overlapping part transparent and the rest white
        maskLayer.backgroundColor = UIColor.white.cgColor
        maskLayer.fillRule = .evenOdd;
        maskLayer.path = path1;
        maskLayer.bounds = self.circle.layer.mask!.bounds;

        self.circle.layer.mask = maskLayer;
        CATransaction.begin()
        maskLayer.add(animation, forKey: "path");
        CATransaction.commit()
        
        let checkTime = Date().addingTimeInterval(0.9);
        UIView.animate (withDuration: 1.0, delay: 2.1, options: .curveEaseIn, animations: {
            self.entryMountainImage.layer.opacity = 1;
            self.entryAirplaneImage.layer.opacity = 0;
            self.view.layoutIfNeeded();
        }) {
            (Finished) in
            if (Date() > checkTime)
            {
                self.toAwait()
            }
        }
    }
    
    private func toAwait ()
    {
        readyTop.constant = 500/812.0*screenHeight;
        awaitsTop.constant = 612/812.0*screenHeight;
        
        //remake a path for the circle's mask
        let maskLayer = CAShapeLayer();
        
        let radius1 = 465.0/812.0*self.screenHeight;
        
        let path1 = CGMutablePath()
        let radius = 418.0/812.0*self.screenHeight;
        path1.addArc(center: CGPoint (x: radius-191.0/812.0*screenHeight, y: 94.0/812.0*screenHeight+radius), radius: radius, startAngle: 0.0, endAngle: 2.0*CGFloat.pi, clockwise: false);
        //and a rectangle
        path1.addRect(CGRect(origin: .zero, size: CGSize (width: 2*radius1, height: 2*radius1)));
        
        let path = CGMutablePath ()
        let radius2 = 330/812.0*self.screenHeight;
        let p = view.convert(view.center, to: circle)
        path.addArc(center: CGPoint (x: p.x, y: radius2+214/812.0*screenHeight), radius: radius2, startAngle: 0.0, endAngle: 2.0*CGFloat.pi, clockwise: false);
        //and a rectangle
        path.addRect(CGRect(origin: .zero, size: CGSize (width: 2*radius1, height: 2*radius1)));
        
        let animation = CABasicAnimation(keyPath: "path");
        animation.fromValue = path1;
        animation.toValue = path;
        animation.duration = 0.8;
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false;
        animation.beginTime = CACurrentMediaTime() + 1.9;
        animation.timingFunction = CAMediaTimingFunction(name: .easeIn);
        animation.autoreverses = false;
        //the fill rule makes the overlapping part transparent and the rest white
        maskLayer.backgroundColor = UIColor.white.cgColor
        maskLayer.fillRule = .evenOdd;
        maskLayer.path = path1;
        maskLayer.bounds = self.circle.layer.mask!.bounds;
        
        self.circle.layer.mask = maskLayer;
        CATransaction.begin()
        maskLayer.add(animation, forKey: "path");
        CATransaction.commit()
        
        let checkTime = Date().addingTimeInterval(0.8);
        UIView.animate (withDuration: 0.9, delay: 2, options: .curveEaseIn, animations: {
            self.entryClimbingImage.layer.opacity = 1;
            self.entryMountainImage.layer.opacity = 0;
            self.view.layoutIfNeeded();
        }) {
            (Finished) in
            if (Date() > checkTime)
            {
                self.toEnd()
            }
        }
    }
    
    private func toEnd ()
    {
        awaitsTop.constant = 500/812.0*screenHeight;
        self.blueViewBottom.constant = 0;
        
        //remake a path for the circle's mask
        let maskLayer = CAShapeLayer();
        
        let radius1 = 465.0/812.0*self.screenHeight;
        let p = view.convert(view.center, to: circle)

        let path1 = CGMutablePath ()
        let radius2 = 330/812.0*self.screenHeight;
        path1.addArc(center: CGPoint (x: p.x, y: radius2+214/812.0*screenHeight), radius: radius2, startAngle: 0.0, endAngle: 2.0*CGFloat.pi, clockwise: false);
        //and a rectangle
        path1.addRect(CGRect(origin: .zero, size: CGSize (width: 2*radius1, height: 2*radius1)));
        
        let path = CGMutablePath()
        let radius = 1000.0/812.0*self.screenHeight;
        path.addArc(center: CGPoint (x: p.x, y: radius2+214/812.0*screenHeight), radius: radius, startAngle: 0.0, endAngle: 2.0*CGFloat.pi, clockwise: false);
        //and a rectangle
        path.addRect(CGRect(origin: .zero, size: CGSize (width: 2*radius, height: 2*radius)));
        
        let animation = CABasicAnimation(keyPath: "path");
        animation.fromValue = path1;
        animation.toValue = path;
        
        let animation2 = CABasicAnimation(keyPath: "opacity");
        animation2.fromValue = 1;
        animation2.toValue = 0;
        
        let group = CAAnimationGroup();
        group.animations = [animation, animation2];
        group.duration = 1.0;
        group.fillMode = .forwards
        group.timingFunction = CAMediaTimingFunction(name: .easeIn)
        group.autoreverses = false;
        group.beginTime = CACurrentMediaTime() + 2;
        group.isRemovedOnCompletion = false;

        //the fill rule makes the overlapping part transparent and the rest white
        maskLayer.backgroundColor = UIColor.white.cgColor
        maskLayer.fillRule = .evenOdd;
        maskLayer.path = path1;
        maskLayer.bounds = self.circle.layer.mask!.bounds;
        
        self.circle.layer.mask = maskLayer;
        CATransaction.begin()
        maskLayer.add(group, forKey: "path");
        CATransaction.commit()
        
        UIView.animate(withDuration: 1, delay: 2, options: .curveEaseIn, animations: {
            self.entryClimbingImage.layer.opacity = 0;
            self.entryCampImage.layer.opacity = 1;
            self.bottomBlue.layer.opacity = 1;
            self.view.layoutIfNeeded();
        }, completion: nil)
    }
    
    @objc func enterApp ()
    {
        performSegue(withIdentifier: "enterApp", sender: self);
    }
*/
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

