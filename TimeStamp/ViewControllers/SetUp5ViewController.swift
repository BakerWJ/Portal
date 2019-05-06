//
//  SetUp5ViewController.swift
//  TimeStamp
//
//  Created by Baker Jackson on 2019-04-28.
//  Copyright © 2019 Baker Jackson. All rights reserved.
//

import UIKit

class SetUp5ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var monday: UITextField!
    @IBOutlet weak var tuesday: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        monday.delegate = self
        tuesday.delegate = self

        // Do any additional setup after loading the view.
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    @IBAction func isClicked(_ sender: Any) {
        let variableName = UserTimetable()
        variableName.update(ADay: true, flipped: false, classnumber: 5, newValue: monday.text ?? "Period 5")
        variableName.update(ADay: false, flipped: false, classnumber: 5, newValue: tuesday.text ?? "Period 5")
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
