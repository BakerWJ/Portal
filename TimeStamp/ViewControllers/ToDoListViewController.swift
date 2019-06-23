//
//  ToDoListViewController.swift
//  TimeStamp
//
//  Created by Jacky He on 2019-06-22.
//  Copyright © 2019 Baker Jackson. All rights reserved.
//

import UIKit

class ToDoListViewController: UIViewController {

    
    let addButton = UIButton ();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 243.0/255, green: 243.0/255, blue: 243.0/255, alpha: 1.0);
        setConstraints ()
        // Do any additional setup after loading the view.
    }
    
    private func setConstraints ()
    {
        addButton.setBackgroundImage (UIImage (named: "addItem"), for: .normal);
        addButton.addTarget(self, action: #selector (toItem), for: .touchUpInside);
        view.addSubview(addButton);
        addButton.translatesAutoresizingMaskIntoConstraints = false;
        addButton.heightAnchor.constraint (equalToConstant: 80/812.0*view.frame.height).isActive = true;
        addButton.widthAnchor.constraint (equalToConstant: 80/812.0*view.frame.height).isActive = true;
        addButton.bottomAnchor.constraint (equalTo: view.bottomAnchor, constant: -140/812.0*view.frame.height).isActive = true;
        addButton.centerXAnchor.constraint (equalTo: view.centerXAnchor).isActive = true;
    }
    
    @objc func toItem ()
    {
        performSegue (withIdentifier: "toToDoListItem", sender: self);
    }
    
    @IBAction func returnFromItem (sender: UIStoryboardSegue) {}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
