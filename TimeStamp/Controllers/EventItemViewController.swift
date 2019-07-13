//
//  ToDoListItemViewController.swift
//  TimeStamp
//
//  Created by Jacky He on 2019-06-22.
//  Copyright © 2019 Baker Jackson. All rights reserved.
//

import UIKit

class EventItemViewController: UIViewController {

    let cancelButton: UIButton = {
        let button = UIButton();
        button.setBackgroundImage(UIImage(named: "cancelIcon"), for: .normal);
        button.backgroundColor = .clear;
        return button;
    }()
    
    let screenHeight = UIScreen.main.bounds.height;
    let screenWidth = UIScreen.main.bounds.width;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup ()
    }
    
    private func setup ()
    {
        view.backgroundColor = UIColor(red: 243.0/255, green: 243.0/255, blue: 243.0/255, alpha: 1.0);
        cancelButton.addTarget(self, action: #selector (back), for: .touchUpInside);
        view.addSubview (cancelButton);
        cancelButton.translatesAutoresizingMaskIntoConstraints = false;
        cancelButton.heightAnchor.constraint (equalToConstant: 20/812.0*screenHeight).isActive = true;
        cancelButton.widthAnchor.constraint (equalTo: cancelButton.heightAnchor).isActive = true;
        cancelButton.topAnchor.constraint (equalTo: view.topAnchor, constant: 60/812.0*screenHeight).isActive = true;
        cancelButton.leadingAnchor.constraint (equalTo: view.leadingAnchor, constant: 60/812.0*screenWidth).isActive = true;
    }
    
    @objc func back()
    {
        performSegue(withIdentifier: "fromEventItem", sender: self);
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
