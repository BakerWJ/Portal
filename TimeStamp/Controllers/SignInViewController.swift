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
    let signInButton = GIDSignInButton();
    let warningLabel = UILabel ();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 243.0/255, green: 243.0/255, blue: 243.0/255, alpha: 1.0);
        GIDSignIn.sharedInstance()?.uiDelegate = self;
        GIDSignIn.sharedInstance()?.signInSilently();
        setup ()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated);
        if (UserDefaults.standard.bool(forKey: "loggedin"))
        {
            if (!UserDefaults.standard.bool (forKey: "notFirstTimeLaunch"))
            {
                performSegue(withIdentifier: "toGetStarted", sender: self)
            }
            else
            {
                performSegue(withIdentifier: "toTabBar", sender: self)
            }
        }
    }
    
    private func setup ()
    {
        view.addSubview (signInButton);
        signInButton.translatesAutoresizingMaskIntoConstraints = false;
        signInButton.heightAnchor.constraint (equalToConstant: 50/812.0*view.frame.height).isActive = true;
        signInButton.widthAnchor.constraint (equalToConstant: 100/812.0*view.frame.height).isActive = true;
        signInButton.centerXAnchor.constraint (equalTo: view.centerXAnchor).isActive = true;
        signInButton.centerYAnchor.constraint (equalTo: view.centerYAnchor).isActive = true;
        
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
