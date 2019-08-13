//
//  SignInViewController.swift
//  TimeStamp
//
//  Created by Jacky He on 2019-06-22.
//  Copyright © 2019 Baker Jackson. All rights reserved.
//

import UIKit
import GoogleSignIn

class SignInViewController: UIViewController, GIDSignInUIDelegate
{
    
    //creates an instance of a sign in button
    let warningLabel = UILabel ();
    
    let screenWidth = UIScreen.main.bounds.width;
    let screenHeight = UIScreen.main.bounds.height;

    //signin button
    lazy var signInButton: UIButton = {
        let button = UIButton ();
        button.backgroundColor = UIColor.getColor(40, 73, 164);
        button.addTarget(self, action: #selector (signIn), for: .touchUpInside);
        button.setTitle("Sign in with Google", for: .normal);
        button.setTitle("Sign in with Google", for: .highlighted);
        button.setTitleColor(.white, for: .normal);
        button.setTitleColor(.white, for: .highlighted);
        button.titleLabel?.font = UIFont (name: "SitkaBanner-Bold", size: 20/375.0*screenWidth);
        return button;
    }()
    
    lazy var getStartedLabel: UILabel = {
        let label = UILabel ();
        let text = NSMutableAttributedString (string: "Hi! ", attributes: [.font: UIFont(name: "SitkaBanner-Bold", size: 20/375.0*screenWidth) ?? UIFont.systemFont(ofSize: 20/375.0*screenWidth, weight: .bold)]);
        text.append(NSMutableAttributedString(string: "Let's get you Started!", attributes: [.font: UIFont(name: "SitkaBanner", size: 20/375.0*screenWidth) ?? UIFont.systemFont(ofSize: 20/375.0*screenWidth)]));
        label.attributedText = text;
        label.textColor = UIColor.getColor(40, 73, 164);
        label.backgroundColor = .clear;
        return label;
    }()
    
    let imageView = UIImageView (image: UIImage(named: "surfingImage"));
    
    let purpleCircle = UIImageView(image: UIImage(named: "purpleCircle"));
    
    lazy var movingRect: UIView = {
        let view = UIView ()
        view.backgroundColor = UIColor.getColor(223, 168, 144)
        return view;
    }()
    
    var getStartedLeading = NSLayoutConstraint()
    var imageWidth = NSLayoutConstraint();
    var circleHeight = NSLayoutConstraint();
    
    @objc func signIn ()
    {
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        // Do any additional setup after loading the view.
    }
    
    var signedIn = false;
    
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated);
        if (signedIn)
        {
            GIDSignIn.sharedInstance()?.signInSilently();
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        reset()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated);
        reset()
    }
    
    private func reset ()
    {
        //reset all the constraints to normal
        signInButton.layer.opacity = 1;
        purpleCircle.layer.opacity = 1;
        imageView.layer.opacity = 1;
        getStartedLeading.constant = 88/375.0*screenWidth;
        imageWidth.constant = 559/812.0*screenHeight;
        circleHeight.constant = 563/812.0*screenHeight;
    }
    
    private func setup ()
    {
        signedIn = UserDefaults.standard.bool(forKey: "loggedin");
        view.backgroundColor = .white;
        GIDSignIn.sharedInstance()?.uiDelegate = self;
        
        //add sign in button
        view.addSubview (signInButton);
        signInButton.translatesAutoresizingMaskIntoConstraints = false;
        signInButton.centerXAnchor.constraint (equalTo: view.centerXAnchor).isActive = true;
        signInButton.topAnchor.constraint (equalTo: view.topAnchor, constant: 696/812.0*screenHeight).isActive = true;
        signInButton.heightAnchor.constraint (equalToConstant: 45/812.0*screenHeight).isActive = true;
        signInButton.widthAnchor.constraint (equalToConstant: 307/375.0*screenWidth).isActive = true;
        signInButton.layoutIfNeeded();
        signInButton.layer.cornerRadius = signInButton.frame.height/3;
        signInButton.dropShadow()
        
        //add the let's get you started label
        view.addSubview(getStartedLabel);
        getStartedLabel.translatesAutoresizingMaskIntoConstraints = false;
        getStartedLeading = getStartedLabel.leadingAnchor.constraint (equalTo: view.leadingAnchor, constant: 88/375.0*screenWidth);
        getStartedLeading.isActive = true;
        getStartedLabel.topAnchor.constraint (equalTo: view.topAnchor, constant: 654/812.0*screenHeight).isActive = true;
        getStartedLabel.widthAnchor.constraint (equalToConstant: 199/375.0*screenWidth).isActive = true;
        getStartedLabel.heightAnchor.constraint (equalToConstant: 20/812.0*screenHeight).isActive = true;
        
        //add the moving rectangle (line)
        view.addSubview(movingRect);
        movingRect.translatesAutoresizingMaskIntoConstraints = false;
        movingRect.leadingAnchor.constraint (equalTo: getStartedLabel.leadingAnchor).isActive = true;
        movingRect.heightAnchor.constraint (equalToConstant: 2/812.0*screenHeight).isActive = true;
        movingRect.widthAnchor.constraint (equalToConstant: 287/375.0*screenWidth).isActive = true;
        movingRect.topAnchor.constraint (equalTo: getStartedLabel.bottomAnchor).isActive = true;
        
        //add the image
        view.addSubview(imageView);
        imageView.translatesAutoresizingMaskIntoConstraints = false;
        imageView.centerXAnchor.constraint (equalTo: view.leadingAnchor, constant: 151.5/375.0*screenWidth).isActive = true;
        imageView.centerYAnchor.constraint (equalTo: view.topAnchor, constant: 321.5/812.0*screenHeight).isActive = true;
        imageWidth = imageView.widthAnchor.constraint (equalToConstant: 559/812.0*screenHeight);
        imageWidth.isActive = true;
        imageView.heightAnchor.constraint (equalTo: imageView.widthAnchor).isActive = true;
        imageView.layoutIfNeeded()
        
        //add the purple circle
        view.addSubview (purpleCircle);
        purpleCircle.translatesAutoresizingMaskIntoConstraints = false;
        purpleCircle.centerXAnchor.constraint (equalTo: imageView.centerXAnchor).isActive = true;
        purpleCircle.centerYAnchor.constraint (equalTo: imageView.centerYAnchor, constant: 19/812.0*screenHeight).isActive = true;
        circleHeight = purpleCircle.heightAnchor.constraint (equalToConstant: 563/812.0*screenHeight);
        circleHeight.isActive = true;
        purpleCircle.widthAnchor.constraint (equalTo: purpleCircle.heightAnchor).isActive = true;
        view.bringSubviewToFront(imageView)
        
        view.addSubview (warningLabel);
        warningLabel.translatesAutoresizingMaskIntoConstraints = false;
        warningLabel.centerXAnchor.constraint (equalTo: view.centerXAnchor).isActive = true;
        warningLabel.topAnchor.constraint (equalTo: signInButton.bottomAnchor).isActive = true;
        warningLabel.heightAnchor.constraint (equalToConstant: 30).isActive = true;
        warningLabel.textColor = .red;
        warningLabel.font = UIFont(name: "SegoeUI", size: 15);
        warningLabel.text = "Sign in is restricted to UTS Students";
        warningLabel.layer.opacity = 0;
    }
    
    func showWarning ()
    {
        warningLabel.layer.opacity = 1;
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func returnFromTabBar (sender: UIStoryboardSegue) {}

}
