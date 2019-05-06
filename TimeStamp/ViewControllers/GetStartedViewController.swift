//
//  ViewController.swift
//  TimeStamp
//
//  Created by Baker Jackson on 2019-04-28.
//  Copyright © 2019 Baker Jackson. All rights reserved.
//

import UIKit
import CoreData

class GetStartedViewController: UIViewController {
    
    @IBOutlet weak var generalNotif: UIButton!
    @IBOutlet weak var houseNotif: UIButton!
    @IBOutlet weak var eventNotif: UIButton!
    @IBOutlet weak var done: UIButton!
    
    let appdelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*let context = appdelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Settings> (entityName: "Settings")
        do {
            let fetchedResults = try managedobjectContext!.fetch(fetchRequest)
            
        }*/
        
    }
    
    @IBAction func generalClick(_ sender: Any) {
        generalNotif.isSelected = !generalNotif.isSelected
    }
    
    @IBAction func houseClick(_ sender: Any) {
        houseNotif.isSelected = !houseNotif.isSelected
    }
    
    @IBAction func eventClick(_ sender: Any) {
        eventNotif.isSelected = !eventNotif.isSelected
    }
    
    
    
}

