//
//  UtilityViewController.swift
//  TimeStamp
//
//  Created by Jacky He on 2019-06-22.
//  Copyright © 2019 Baker Jackson. All rights reserved.
//

import UIKit

class UtilityViewController: UIViewController {

    var buttons: [UIButton] = [UIButton] ();
    let stackView = UIStackView ();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 243.0/255, green: 243.0/255, blue: 243.0/255, alpha: 1.0);
        // Do any additional setup after loading the view.
        setUp ()
    }
    
    private func setUp ()
    {
        //makes navigation bar transparent
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default);
        self.navigationController?.navigationBar.shadowImage = UIImage();
        self.navigationController?.navigationBar.isTranslucent = true;
        
        //sets up for the stackview
        stackView.axis = .vertical;
        stackView.spacing = 1;
        stackView.backgroundColor = .clear;
        stackView.distribution = .fillEqually;
        view.addSubview(stackView);
        stackView.translatesAutoresizingMaskIntoConstraints = false;
        stackView.widthAnchor.constraint (equalTo: view.widthAnchor).isActive = true;
        stackView.centerXAnchor.constraint (equalTo: view.centerXAnchor).isActive = true;
        stackView.centerYAnchor.constraint (equalTo: view.centerYAnchor).isActive = true;

        for _ in 0..<5
        {
            let button = UIButton();
            button.titleLabel?.font = UIFont (name: "SegoeUI", size: 14/812.0*view.frame.height);
            button.setTitleColor(.black, for: .normal);
            button.backgroundColor = .clear;
            stackView.addArrangedSubview(button);
            button.translatesAutoresizingMaskIntoConstraints = false;
            button.heightAnchor.constraint (equalToConstant: 20/812.0*view.frame.height).isActive = true;
            button.widthAnchor.constraint (equalTo: view.widthAnchor).isActive = true;
            buttons.append (button);
        }
        
        //set the buttons to what they correspond to
        buttons [0].setTitle ("Notification Settings", for: .normal);
        buttons [0].addTarget(self, action: #selector(toNotifSettings), for: .touchUpInside);
        buttons [1].setTitle ("House Information", for: .normal);
        buttons [1].addTarget (self, action: #selector (toHouseInfo), for: .touchUpInside);
        buttons [2].setTitle ("Custom Theme", for: .normal);
        buttons [2].addTarget(self, action: #selector (toCustomTheme), for: .touchUpInside);
        buttons [3].setTitle ("Room Booking", for: .normal);
        buttons [3].addTarget(self, action: #selector (toRoomBooking), for: .touchUpInside);
        buttons [4].setTitle("Lost and Found", for: .normal);
        buttons [4].addTarget(self, action: #selector (toLostAndFound), for: .touchUpInside);
        
    }
    
    @objc func toNotifSettings () {performSegue (withIdentifier: "toNotifSettings", sender: self);}
    
    @objc func toHouseInfo () {performSegue (withIdentifier: "toHouseInfo", sender: self);}
    
    @objc func toCustomTheme () {performSegue (withIdentifier: "toCustomTheme", sender: self);}
    
    @objc func toRoomBooking () {performSegue (withIdentifier: "toRoomBooking", sender: self);}
    
    @objc func toLostAndFound () {performSegue (withIdentifier: "toLostAndFound", sender: self);}
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
