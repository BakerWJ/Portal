//
//  SettingsViewController.swift
//  TimeStamp
//
//  Created by Baker Jackson on 2019-04-29.
//  Copyright © 2019 Baker Jackson. All rights reserved.
//

import UIKit
import CoreData

class SettingsViewController: UIViewController {

    @IBOutlet weak var generalButton: UIButton!
    @IBOutlet weak var houseButton: UIButton!
    @IBOutlet weak var eventButton: UIButton!
    @IBOutlet weak var oneDay: UIButton!
    @IBOutlet weak var twoDay: UIButton!
    @IBOutlet weak var threeDay: UIButton!
    @IBOutlet weak var fourDay: UIButton!
    @IBOutlet weak var fiveDay: UIButton!
    @IBOutlet weak var morningButton: UIButton!
    @IBOutlet weak var afternoonButton: UIButton!
    @IBOutlet weak var eveningButton: UIButton!
    @IBOutlet weak var oneLabel: UILabel!
    @IBOutlet weak var twoLabel: UILabel!
    @IBOutlet weak var threeLabel: UILabel!
    @IBOutlet weak var fourLabel: UILabel!
    @IBOutlet weak var fiveLabel: UILabel!
    @IBOutlet weak var morningLabel: UILabel!
    @IBOutlet weak var afternoonLabel: UILabel!
    @IBOutlet weak var eveningLabel: UILabel!
    
    var settings: Settings?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        clearDay()
        clearTime()
        let fetchRequest = NSFetchRequest <NSFetchRequestResult> (entityName: "Settings");
        do {
            if let results = try CoreDataStack.managedObjectContext.fetch(fetchRequest) as? [Settings] {
                generalButton.isSelected = results[0].generalNotifications
                houseButton.isSelected = results[0].houseNotifications
                eventButton.isSelected = results[0].eventNotifications
                switch results[0].daysBefore{
                    case 1:
                        oneClick(1)
                    case 2:
                        twoClick(1)
                    case 3:
                        threeClick(1)
                    case 4:
                        fourClick(1)
                    case 5:
                        fiveClick(1)
                    default:
                        oneClick(1)
                }
                switch results[0].notificationTime {
                case 1:
                    morningClick(1)
                case 2:
                    afternoonClick(1)
                default:
                    eveningClick(1)
                }
                settings = results[0];
            }
        }
        catch {
            fatalError("There was an error fetching the list of timetables");
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func generalClick(_ sender: Any) {
        generalButton.isSelected = !generalButton.isSelected
        settings?.generalNotifications = generalButton.isSelected
    }
    
    @IBAction func houseClick(_ sender: Any) {
        houseButton.isSelected = !houseButton.isSelected
        settings?.houseNotifications = houseButton.isSelected
    }
    
    @IBAction func eventClick(_ sender: Any) {
        eventButton.isSelected = !eventButton.isSelected
        settings?.eventNotifications = eventButton.isSelected
    }
    
    @IBAction func oneClick(_ sender: Any) {
        clearDay()
        oneDay.isSelected = true
        oneLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        settings?.daysBefore = 1;
    }
    
    @IBAction func twoClick(_ sender: Any) {
        clearDay()
        twoDay.isSelected = true
        twoLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        settings?.daysBefore = 2;
    }
    
    @IBAction func threeClick(_ sender: Any) {
        clearDay()
        threeDay.isSelected = true
        threeLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        settings?.daysBefore = 3;
    }
    
    @IBAction func fourClick(_ sender: Any) {
        clearDay()
        fourDay.isSelected = true
        fourLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        settings?.daysBefore = 4;
    }
    
    @IBAction func fiveClick(_ sender: Any) {
        clearDay()
        fiveDay.isSelected = true
        fiveLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        settings?.daysBefore = 5;
    }
    
    @IBAction func morningClick(_ sender: Any) {
        clearTime()
        morningButton.isSelected = true
        morningLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        settings?.notificationTime = 1;
    }
    
    @IBAction func afternoonClick(_ sender: Any) {
        clearTime()
        afternoonButton.isSelected = true
        afternoonLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        settings?.notificationTime = 2;
    }
    
    @IBAction func eveningClick(_ sender: Any) {
        clearTime()
        eveningButton.isSelected = true
        eveningLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        settings?.notificationTime = 3;
    }
    
    
    func clearDay() {
        oneDay.isSelected = false
        twoDay.isSelected = false
        threeDay.isSelected = false
        fourDay.isSelected = false
        fiveDay.isSelected = false
        oneLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        twoLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        threeLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        fourLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        fiveLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
    
    func clearTime() {
        morningButton.isSelected = false
        afternoonButton.isSelected = false
        eveningButton.isSelected = false
        morningLabel.textColor = #colorLiteral(red: 0.5888373256, green: 0.5888516307, blue: 0.5888439417, alpha: 1)
        afternoonLabel.textColor = #colorLiteral(red: 0.5888373256, green: 0.5888516307, blue: 0.5888439417, alpha: 1)
        eveningLabel.textColor = #colorLiteral(red: 0.5888373256, green: 0.5888516307, blue: 0.5888439417, alpha: 1)
    }
    

}
