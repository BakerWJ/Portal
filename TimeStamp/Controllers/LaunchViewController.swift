//
//  LaunchViewController.swift
//  TimeStamp
//
//  Created by Jacky He on 2019-09-01.
//  Copyright © 2019 Baker Jackson. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {
    
    let screenHeight = UIScreen.main.bounds.height;
    let screenWidth = UIScreen.main.bounds.width;
    
    let gradientImage = UIImageView(image: UIImage(named: "gradientImage"));
    let cityFront = UIImageView (image: UIImage(named: "cityFront"));
    let cityBack = UIImageView(image: UIImage(named: "cityBack"));
    let appLogo = UIImageView (image: UIImage(named: "logo"))
    var first = true;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if (first)
        {
            first = false;
            animate()
        }
    }
    
    var cityFrontTop = NSLayoutConstraint()
    var cityBackTop = NSLayoutConstraint()
    var cityFrontHeight = NSLayoutConstraint()
    var cityBackHeight = NSLayoutConstraint()
    
    private func setup ()
    {
        //no resizing according to phone size
        
        view.addSubview(gradientImage);
        gradientImage.translatesAutoresizingMaskIntoConstraints = false;
        view.addConstraintsWithFormat("H:|[v0]|", views: gradientImage);
        view.addConstraintsWithFormat("V:|[v0]|", views: gradientImage);
        
        view.addSubview(cityBack);
        cityBack.translatesAutoresizingMaskIntoConstraints = false;
        cityBack.centerXAnchor.constraint (equalTo: view.centerXAnchor).isActive = true;
        cityBackHeight = cityBack.heightAnchor.constraint (equalToConstant: 853.0/812.0*screenHeight);
        cityBackHeight.isActive = true;
        cityBack.widthAnchor.constraint (equalTo: cityBack.heightAnchor, multiplier: 8.1/7.19).isActive = true;
        cityBack.layoutIfNeeded()
        cityBackTop = cityBack.topAnchor.constraint (equalTo: view.topAnchor, constant: screenHeight - cityBack.frame.height)
        cityBackTop.isActive = true;
        
        view.addSubview (cityFront);
        cityFront.translatesAutoresizingMaskIntoConstraints = false;
        cityFront.centerXAnchor.constraint (equalTo: view.centerXAnchor).isActive = true;
        cityFrontHeight = cityFront.heightAnchor.constraint (equalToConstant: 554.4/812*screenHeight)
        cityFrontHeight.isActive = true;
        cityFront.widthAnchor.constraint (equalTo: cityFront.heightAnchor, multiplier: 14.86/10.62).isActive = true;
        cityFront.layoutIfNeeded();
        cityFrontTop = cityFront.topAnchor.constraint (equalTo: view.topAnchor, constant: screenHeight - cityFront.frame.height);
        cityFrontTop.isActive = true;
        
        view.addSubview (appLogo);
        appLogo.translatesAutoresizingMaskIntoConstraints = false;
        appLogo.widthAnchor.constraint (equalToConstant: 147/375.0*screenWidth).isActive = true;
        appLogo.heightAnchor.constraint (equalTo: appLogo.widthAnchor).isActive = true;
        appLogo.centerXAnchor.constraint (equalTo: view.centerXAnchor).isActive = true;
        appLogo.topAnchor.constraint (equalTo: view.topAnchor, constant: 129/812.0*screenHeight).isActive = true;
        appLogo.layer.opacity = 0;
    }
    
    private func animate ()
    {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.view.layoutIfNeeded()
            self.cityBackTop.constant += 62/812.0*self.screenHeight;
            self.cityFrontTop.constant += 20/812.0*self.screenHeight;
            self.cityBackHeight.constant = 965/812.0*self.screenHeight;
            self.cityFrontHeight.constant = 740.9/812.0*self.screenHeight;
            UIView.animate(withDuration: 1, delay: 0, options: .curveEaseIn, animations: {
                self.view.layoutIfNeeded()
                self.appLogo.layer.opacity = 1;
            }, completion: nil)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.performSegue(withIdentifier: "toApp", sender: self);
        }
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
