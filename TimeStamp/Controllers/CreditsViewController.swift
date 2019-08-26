//
//  CreditsViewController.swift
//  TimeStamp
//
//  Created by Jacky He on 2019-08-25.
//  Copyright © 2019 Baker Jackson. All rights reserved.
//

import UIKit

class CreditsViewController: UIViewController {

    let screenWidth = UIScreen.main.bounds.width;
    let screenHeight = UIScreen.main.bounds.height;
    
    lazy var cancelButton: UIImageView = {
        let view = UIImageView(image: UIImage(named: "Exit"));
        let tg = UITapGestureRecognizer(target: self, action: #selector(cancel));
        view.addGestureRecognizer(tg);
        return view;
    }()
    
    lazy var creditsLabel : UILabel = {
        let label = UILabel ()
        label.text = "Credits";
        label.textColor = .black;
        label.font = UIFont(name: "SitkaBanner", size: 40/375.0*screenWidth);
        label.textAlignment = .center;
        label.baselineAdjustment = .alignCenters
        label.backgroundColor = .clear;
        return label;
    }()
    
    lazy var contentLabel : UILabel = {
        let label = UILabel()
        let text = NSMutableAttributedString(string: "Built by:\n\n", attributes: [.font : UIFont(name: "SitkaBanner", size: 30/375.0*screenWidth) ?? UIFont.systemFont(ofSize: 30/375.0*screenWidth)]);
        text.append(NSMutableAttributedString(string: "Jacky He\nBaker Jackson\nVincent Song\nJason Xiong", attributes: [.font : UIFont(name: "SitkaBanner", size: 20/375.0*screenWidth) ?? UIFont.systemFont(ofSize: 20/375.0*screenWidth)]));
        text.append(NSMutableAttributedString(string: "\n\nImages Designed by:\n\n", attributes: [.font : UIFont(name: "SitkaBanner", size: 30/375.0*screenWidth) ?? UIFont.systemFont(ofSize: 30/375.0*screenWidth)]));
        text.append(NSMutableAttributedString(string: "pikisuperstar/Freepik\nEmma Jenkin", attributes: [.font : UIFont(name: "SitkaBanner", size: 20/375.0*screenWidth) ?? UIFont.systemFont(ofSize: 20/375.0*screenWidth)]));
        label.attributedText = text;
        label.numberOfLines = 0;
        label.textAlignment = .center;
        label.baselineAdjustment = .alignCenters;
        return label;
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        // Do any additional setup after loading the view.
    }
    
    private func setup ()
    {
        view.addSubview(cancelButton);
        cancelButton.translatesAutoresizingMaskIntoConstraints = false;
        cancelButton.widthAnchor.constraint (equalToConstant: 30/375.0*screenWidth).isActive = true;
        cancelButton.heightAnchor.constraint (equalTo: cancelButton.widthAnchor).isActive = true;
        cancelButton.topAnchor.constraint (equalTo: view.topAnchor, constant: 67/812.0*screenHeight).isActive = true;
        cancelButton.trailingAnchor.constraint (equalTo: view.trailingAnchor, constant: -67/812.0*screenHeight).isActive = true;
        
        view.addSubview (creditsLabel);
        creditsLabel.translatesAutoresizingMaskIntoConstraints = false;
        creditsLabel.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true;
        creditsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true;
        creditsLabel.centerYAnchor.constraint (equalTo: cancelButton.centerYAnchor).isActive = true;
        creditsLabel.heightAnchor.constraint(equalToConstant: 50/812.0*screenHeight).isActive = true;
        
        view.addSubview(contentLabel);
        contentLabel.translatesAutoresizingMaskIntoConstraints = false;
        contentLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 137/812.0*screenHeight).isActive = true;
        contentLabel.centerXAnchor.constraint (equalTo: view.centerXAnchor).isActive = true;
        contentLabel.widthAnchor.constraint (equalTo: view.widthAnchor).isActive = true;
        
        view.bringSubviewToFront(cancelButton);
    }
    
    @objc func cancel ()
    {
        performSegue(withIdentifier: "fromCredit", sender: self);
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
