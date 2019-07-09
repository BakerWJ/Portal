//
//  ToDoListItemViewController.swift
//  TimeStamp
//
//  Created by Jacky He on 2019-06-22.
//  Copyright © 2019 Baker Jackson. All rights reserved.
//

import UIKit

class ToDoListItemViewController: UIViewController {

    let backButton = UIButton ();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 243.0/255, green: 243.0/255, blue: 243.0/255, alpha: 1.0);
        setConstraints ();
        // Do any additional setup after loading the view.
    }
    
    private func setConstraints ()
    {
        backButton.setTitleColor(.black, for: .normal);
        backButton.setTitle("Dismiss", for: .normal);
        backButton.titleLabel?.font = UIFont (name: "SegoeUI-Bold", size: 20/812.0*view.frame.height);
        backButton.backgroundColor = .clear
        backButton.addTarget(self, action: #selector(backToList), for: .touchUpInside);
        view.addSubview(backButton);
        backButton.translatesAutoresizingMaskIntoConstraints = false;
        backButton.heightAnchor.constraint (equalToConstant: 20/812.0*view.frame.height).isActive = true;
        backButton.widthAnchor.constraint (equalToConstant: 100/812.0*view.frame.height).isActive = true;
        backButton.leadingAnchor.constraint (equalTo: view.leadingAnchor, constant: 40/375.0*view.frame.width).isActive = true;
        backButton.topAnchor.constraint (equalTo: view.topAnchor, constant: 60/812.0*view.frame.height).isActive = true;
        
    }
    
    @objc func backToList ()
    {
        performSegue (withIdentifier: "fromItem", sender: self);
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
