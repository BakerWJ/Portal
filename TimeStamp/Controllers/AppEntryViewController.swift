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
        button.backgroundColor = .white;
        button.frame = CGRect(x: 34/375.0*screenWidth, y: 734/375.0*screenWidth, width: 307/375.0*screenWidth, height: 45/375.0*screenWidth);
        button.layer.cornerRadius = button.frame.height/3;
        button.addTarget(self, action: #selector (enterApp), for: .touchUpInside);
        button.dropShadow();
        return button;
    }()
  
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 40/255.0, green: 73/255.0, blue: 164/255.0, alpha: 1);
        setup ()
        // Do any additional setup after loading the view.
    }
    
    private func setup ()
    {
        view.backgroundColor = UIColor(red: 40/255.0, green: 73/255.0, blue: 164/255.0, alpha: 1);
        view.addSubview(letsgoButton);
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
