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

    @IBOutlet weak var settingsLabel: UILabel!
    @IBOutlet weak var upperSection: UIImageView!
    @IBOutlet weak var lowerSection: UIImageView!
    @IBOutlet weak var generalNotifLabel: UILabel!
    @IBOutlet weak var generalNotifExplain: UILabel!
    @IBOutlet weak var houseLabel: UILabel!
    @IBOutlet weak var houseExplainLabel: UILabel!
    @IBOutlet weak var eventLabel: UILabel!
    @IBOutlet weak var eventExplainLabel: UILabel!
    @IBOutlet weak var reminderLabel: UILabel!
    @IBOutlet weak var daysBeforeExplainLabel: UILabel!
    @IBOutlet weak var timeOfDayExplainLabel: UILabel!
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
        setUp()
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
        
        self.tabBarController?.tabBar
        // Do any additional setup after loading the view.
    }
    
    @IBAction func generalClick(_ sender: Any) {
        generalButton.isSelected = !generalButton.isSelected
        settings?.generalNotifications = generalButton.isSelected
        CoreDataStack.saveContext()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.setNotifications()
    }
    
    @IBAction func houseClick(_ sender: Any) {
        houseButton.isSelected = !houseButton.isSelected
        settings?.houseNotifications = houseButton.isSelected
        CoreDataStack.saveContext()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.setNotifications()
    }
    
    @IBAction func eventClick(_ sender: Any) {
        eventButton.isSelected = !eventButton.isSelected
        settings?.eventNotifications = eventButton.isSelected
        CoreDataStack.saveContext()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.setNotifications()
    }
    
    @IBAction func oneClick(_ sender: Any) {
        clearDay()
        oneDay.isSelected = true
        oneLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        settings?.daysBefore = 1;
        CoreDataStack.saveContext()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.setNotifications()
    }
    
    @IBAction func twoClick(_ sender: Any) {
        clearDay()
        twoDay.isSelected = true
        twoLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        settings?.daysBefore = 2;
        CoreDataStack.saveContext()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.setNotifications()
    }
    
    @IBAction func threeClick(_ sender: Any) {
        clearDay()
        threeDay.isSelected = true
        threeLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        settings?.daysBefore = 3;
        CoreDataStack.saveContext()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.setNotifications()
    }
    
    @IBAction func fourClick(_ sender: Any) {
        clearDay()
        fourDay.isSelected = true
        fourLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        settings?.daysBefore = 4;
        CoreDataStack.saveContext()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.setNotifications()
    }
    
    @IBAction func fiveClick(_ sender: Any) {
        clearDay()
        fiveDay.isSelected = true
        fiveLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        settings?.daysBefore = 5;
        CoreDataStack.saveContext()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.setNotifications()
    }
    
    @IBAction func morningClick(_ sender: Any) {
        clearTime()
        morningButton.isSelected = true
        morningLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        settings?.notificationTime = 1;
        CoreDataStack.saveContext()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.setNotifications()
    }
    
    @IBAction func afternoonClick(_ sender: Any) {
        clearTime()
        afternoonButton.isSelected = true
        afternoonLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        settings?.notificationTime = 2;
        CoreDataStack.saveContext()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.setNotifications()
    }
    
    @IBAction func eveningClick(_ sender: Any) {
        clearTime()
        eveningButton.isSelected = true
        eveningLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        settings?.notificationTime = 3;
        CoreDataStack.saveContext()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.setNotifications()
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
    
    private func setUp ()
    {
        settingsLabel.font = UIFont(name: "Arial-BoldMT", size: 32/812.0*view.frame.height);
        generalNotifLabel.font = UIFont (name: "SegoeUI", size: 15/812.0*view.frame.height);
        generalNotifExplain.font = UIFont (name: "SegoeUI", size: 12/812.0*view.frame.height);
        houseLabel.font = UIFont (name: "SegoeUI", size: 15/812.0*view.frame.height);
        houseExplainLabel.font = UIFont (name: "SegoeUI", size: 12/812.0*view.frame.height);
        eventLabel.font = UIFont (name: "SegoeUI", size: 15/812.0*view.frame.height);
        eventExplainLabel.font = UIFont (name: "SegoeUI", size: 12/812.0*view.frame.height);
        reminderLabel.font = UIFont (name: "SegoeUI", size: 15/812.0*view.frame.height)
        daysBeforeExplainLabel.font = UIFont (name: "SegoeUI", size: 12/812.0*view.frame.height);
        timeOfDayExplainLabel.font = UIFont (name: "SegoeUI", size: 12/812.0*view.frame.height);
        oneLabel.font = UIFont (name: "SegoeUI", size: 15/812.0*view.frame.height);
        twoLabel.font = UIFont (name: "SegoeUI", size: 15/812.0*view.frame.height);
        threeLabel.font = UIFont (name: "SegoeUI", size: 15/812.0*view.frame.height);
        fourLabel.font = UIFont (name: "SegoeUI", size: 15/812.0*view.frame.height);
        fiveLabel.font = UIFont (name: "SegoeUI", size: 15/812.0*view.frame.height);
        morningLabel.font = UIFont (name: "SegoeUI", size: 16/812.0*view.frame.height);
        afternoonLabel.font = UIFont (name: "SegoeUI", size: 16/812.0*view.frame.height);
        eveningLabel.font = UIFont (name: "SegoeUI", size: 16/812.0*view.frame.height);
        setConstraints()

    }
    
    //172 lines of constraints 😵
    private func setConstraints ()
    {
        settingsLabel.translatesAutoresizingMaskIntoConstraints = false;
        upperSection.translatesAutoresizingMaskIntoConstraints = false;
        lowerSection.translatesAutoresizingMaskIntoConstraints = false;
        generalNotifLabel.translatesAutoresizingMaskIntoConstraints = false;
        houseLabel.translatesAutoresizingMaskIntoConstraints = false;
        eventLabel.translatesAutoresizingMaskIntoConstraints = false;
        generalNotifExplain.translatesAutoresizingMaskIntoConstraints = false;
        houseExplainLabel.translatesAutoresizingMaskIntoConstraints = false;
        eventExplainLabel.translatesAutoresizingMaskIntoConstraints = false;
        generalButton.translatesAutoresizingMaskIntoConstraints = false;
        houseButton.translatesAutoresizingMaskIntoConstraints = false;
        eventButton.translatesAutoresizingMaskIntoConstraints = false;
        reminderLabel.translatesAutoresizingMaskIntoConstraints = false;
        daysBeforeExplainLabel.translatesAutoresizingMaskIntoConstraints = false;
        oneDay.translatesAutoresizingMaskIntoConstraints = false;
        twoDay.translatesAutoresizingMaskIntoConstraints = false;
        threeDay.translatesAutoresizingMaskIntoConstraints = false;
        fourDay.translatesAutoresizingMaskIntoConstraints = false;
        fiveDay.translatesAutoresizingMaskIntoConstraints = false;
        oneLabel.translatesAutoresizingMaskIntoConstraints = false;
        twoLabel.translatesAutoresizingMaskIntoConstraints = false;
        threeLabel.translatesAutoresizingMaskIntoConstraints = false;
        fourLabel.translatesAutoresizingMaskIntoConstraints = false;
        fiveLabel.translatesAutoresizingMaskIntoConstraints = false;
        timeOfDayExplainLabel.translatesAutoresizingMaskIntoConstraints = false;
        morningButton.translatesAutoresizingMaskIntoConstraints = false;
        afternoonButton.translatesAutoresizingMaskIntoConstraints = false;
        eveningButton.translatesAutoresizingMaskIntoConstraints = false;
        morningLabel.translatesAutoresizingMaskIntoConstraints = false;
        afternoonLabel.translatesAutoresizingMaskIntoConstraints = false;
        eveningLabel.translatesAutoresizingMaskIntoConstraints = false;
        
        settingsLabel.centerXAnchor.constraint (equalTo: view.centerXAnchor).isActive = true;
        settingsLabel.widthAnchor.constraint (equalTo: view.widthAnchor).isActive = true;
        settingsLabel.heightAnchor.constraint (equalTo: view.heightAnchor, multiplier: 37.0/812.0).isActive = true;
        settingsLabel.topAnchor.constraint (equalTo: view.topAnchor, constant: 77/812.0*view.frame.height).isActive = true;
        
        upperSection.widthAnchor.constraint (equalTo: view.widthAnchor).isActive = true;
        upperSection.heightAnchor.constraint (equalTo: view.heightAnchor, multiplier: 342.0/812).isActive = true;
        upperSection.topAnchor.constraint (equalTo: view.topAnchor, constant: 126/812.0*view.frame.height).isActive = true;
        upperSection.centerXAnchor.constraint (equalTo: view.centerXAnchor).isActive = true;
        view.sendSubviewToBack(upperSection)
        
        lowerSection.widthAnchor.constraint (equalTo: view.widthAnchor).isActive = true;
        lowerSection.heightAnchor.constraint (equalTo: view.heightAnchor, multiplier: 317.0/812).isActive = true;
        lowerSection.topAnchor.constraint (equalTo: view.topAnchor, constant: 487/812.0*view.frame.height).isActive = true;
        lowerSection.centerXAnchor.constraint (equalTo: view.centerXAnchor).isActive = true;
        view.sendSubviewToBack(lowerSection)
        
        generalNotifLabel.leadingAnchor.constraint (equalTo: view.leadingAnchor, constant: 46/375.0*view.frame.width).isActive = true;
        generalNotifLabel.widthAnchor.constraint (equalToConstant: 283/375.0*view.frame.width).isActive = true;
        generalNotifLabel.heightAnchor.constraint (equalToConstant: 25/812.0*view.frame.height).isActive = true;
        generalNotifLabel.topAnchor.constraint (equalTo: view.topAnchor, constant: 150/812.0*view.frame.height).isActive = true;
        
        houseLabel.leadingAnchor.constraint (equalTo: view.leadingAnchor, constant: 46/375.0*view.frame.width).isActive = true;
        houseLabel.widthAnchor.constraint (equalToConstant: 283/375.0*view.frame.width).isActive = true;
        houseLabel.heightAnchor.constraint (equalToConstant: 25/812.0*view.frame.height).isActive = true;
        houseLabel.topAnchor.constraint (equalTo: view.topAnchor, constant: 258/812.0*view.frame.height).isActive = true;
        
        eventLabel.leadingAnchor.constraint (equalTo: view.leadingAnchor, constant: 46/375.0*view.frame.width).isActive = true;
        eventLabel.widthAnchor.constraint (equalToConstant: 283/375.0*view.frame.width).isActive = true;
        eventLabel.heightAnchor.constraint (equalToConstant: 25/812.0*view.frame.height).isActive = true;
        eventLabel.topAnchor.constraint (equalTo: view.topAnchor, constant: 365/812.0*view.frame.height).isActive = true;
        
        generalNotifExplain.leadingAnchor.constraint (equalTo: generalNotifLabel.leadingAnchor).isActive = true;
        generalNotifExplain.topAnchor.constraint (equalTo: generalNotifLabel.bottomAnchor).isActive = true;
        generalNotifExplain.widthAnchor.constraint (equalToConstant: 179/375.0*view.frame.width).isActive = true;
        generalNotifExplain.heightAnchor.constraint (equalToConstant: 66/812.0*view.frame.height).isActive = true;
        
        houseExplainLabel.leadingAnchor.constraint (equalTo: houseLabel.leadingAnchor).isActive = true;
        houseExplainLabel.topAnchor.constraint (equalTo: houseLabel.bottomAnchor).isActive = true;
        houseExplainLabel.widthAnchor.constraint (equalToConstant: 179/375.0*view.frame.width).isActive = true;
        houseExplainLabel.heightAnchor.constraint (equalToConstant: 65/812.0*view.frame.height).isActive = true;
        
        eventExplainLabel.leadingAnchor.constraint (equalTo: eventLabel.leadingAnchor).isActive = true;
        eventExplainLabel.topAnchor.constraint (equalTo: eventLabel.bottomAnchor).isActive = true;
        eventExplainLabel.widthAnchor.constraint (equalToConstant: 179/375.0*view.frame.width).isActive = true;
        eventExplainLabel.heightAnchor.constraint (equalToConstant: 65/812.0*view.frame.height).isActive = true;
        
        generalButton.topAnchor.constraint (equalTo: generalNotifLabel.bottomAnchor).isActive = true;
        generalButton.heightAnchor.constraint (equalTo: view.heightAnchor, multiplier: 40/812.0).isActive = true;
        generalButton.trailingAnchor.constraint (equalTo: view.trailingAnchor, constant: -46/375.0*view.frame.width).isActive = true;
        
        houseButton.topAnchor.constraint (equalTo: houseLabel.bottomAnchor).isActive = true;
        houseButton.heightAnchor.constraint (equalTo: view.heightAnchor, multiplier: 40/812.0).isActive = true;
        houseButton.trailingAnchor.constraint (equalTo: view.trailingAnchor, constant: -46/375.0*view.frame.width).isActive = true;
        
        eventButton.topAnchor.constraint (equalTo: eventLabel.bottomAnchor).isActive = true;
        eventButton.heightAnchor.constraint (equalTo: view.heightAnchor, multiplier: 40/812.0).isActive = true;
        eventButton.trailingAnchor.constraint (equalTo: view.trailingAnchor, constant: -46/375.0*view.frame.width).isActive = true;
        
        reminderLabel.leadingAnchor.constraint (equalTo: generalNotifLabel.leadingAnchor).isActive = true;
        reminderLabel.topAnchor.constraint (equalTo: view.topAnchor, constant: 502/812.0*view.frame.height).isActive = true;
        reminderLabel.heightAnchor.constraint (equalToConstant: 25/812.0*view.frame.height).isActive = true;
        reminderLabel.widthAnchor.constraint (equalToConstant: 283/375.0*view.frame.width).isActive = true;
        
        daysBeforeExplainLabel.topAnchor.constraint (equalTo: reminderLabel.bottomAnchor).isActive = true;
        daysBeforeExplainLabel.leadingAnchor.constraint (equalTo: reminderLabel.leadingAnchor).isActive = true;
        daysBeforeExplainLabel.heightAnchor.constraint (equalToConstant: 18/812.0*view.frame.height).isActive = true;
        daysBeforeExplainLabel.widthAnchor.constraint (equalToConstant: 241.0/375.0*view.frame.width).isActive = true;
        
        oneDay.leadingAnchor.constraint (equalTo: view.leadingAnchor, constant: 47/375.0*view.frame.width).isActive = true;
        oneDay.heightAnchor.constraint (equalToConstant: 34/812.0*view.frame.height).isActive = true;
        oneDay.topAnchor.constraint (equalTo: view.topAnchor, constant: 561/812.0*view.frame.height).isActive = true;
        
        twoDay.leadingAnchor.constraint (equalTo: view.leadingAnchor, constant: 107/375.0*view.frame.width).isActive = true;
        twoDay.heightAnchor.constraint (equalToConstant: 34/812.0*view.frame.height).isActive = true;
        twoDay.topAnchor.constraint (equalTo: view.topAnchor, constant: 561/812.0*view.frame.height).isActive = true;
        
        threeDay.leadingAnchor.constraint (equalTo: view.leadingAnchor, constant: 167/375.0*view.frame.width).isActive = true;
        threeDay.heightAnchor.constraint (equalToConstant: 34/812.0*view.frame.height).isActive = true;
        threeDay.topAnchor.constraint (equalTo: view.topAnchor, constant: 561/812.0*view.frame.height).isActive = true;
        
        fourDay.leadingAnchor.constraint (equalTo: view.leadingAnchor, constant: 227/375.0*view.frame.width).isActive = true;
        fourDay.heightAnchor.constraint (equalToConstant: 34/812.0*view.frame.height).isActive = true;
        fourDay.topAnchor.constraint (equalTo: view.topAnchor, constant: 561/812.0*view.frame.height).isActive = true;
        
        fiveDay.leadingAnchor.constraint (equalTo: view.leadingAnchor, constant: 287/375.0*view.frame.width).isActive = true;
        fiveDay.heightAnchor.constraint (equalToConstant: 34/812.0*view.frame.height).isActive = true;
        fiveDay.topAnchor.constraint (equalTo: view.topAnchor, constant: 561/812.0*view.frame.height).isActive = true;
        
        
        oneLabel.centerXAnchor.constraint (equalTo: oneDay.centerXAnchor).isActive
            = true;
        oneLabel.centerYAnchor.constraint (equalTo: oneDay.centerYAnchor).isActive = true;
        
        twoLabel.centerXAnchor.constraint (equalTo: twoDay.centerXAnchor).isActive
            = true;
        twoLabel.centerYAnchor.constraint (equalTo: twoDay.centerYAnchor).isActive = true;
        
        threeLabel.centerXAnchor.constraint (equalTo: threeDay.centerXAnchor).isActive
            = true;
        threeLabel.centerYAnchor.constraint (equalTo: threeDay.centerYAnchor).isActive = true;
        
        fourLabel.centerXAnchor.constraint (equalTo: fourDay.centerXAnchor).isActive
            = true;
        fourLabel.centerYAnchor.constraint (equalTo: fourDay.centerYAnchor).isActive = true;
        
        fiveLabel.centerXAnchor.constraint (equalTo: fiveDay.centerXAnchor).isActive
            = true;
        fiveLabel.centerYAnchor.constraint (equalTo: fiveDay.centerYAnchor).isActive = true;
        
        timeOfDayExplainLabel.leadingAnchor.constraint (equalTo: reminderLabel.leadingAnchor).isActive = true;
        timeOfDayExplainLabel.topAnchor.constraint (equalTo: view.topAnchor, constant: 610/812.0*view.frame.height).isActive = true;
        timeOfDayExplainLabel.heightAnchor.constraint (equalToConstant: 20/812.0*view.frame.height).isActive = true;
        timeOfDayExplainLabel.widthAnchor.constraint (equalToConstant: 241/375.0*view.frame.width).isActive = true;
        
        morningButton.centerXAnchor.constraint (equalTo: view.centerXAnchor).isActive = true;
        morningButton.heightAnchor.constraint (equalToConstant: 32/812.0*view.frame.height).isActive = true;
        morningButton.widthAnchor.constraint (equalToConstant: 280/375.0*view.frame.width).isActive = true;
        morningButton.topAnchor.constraint (equalTo: view.topAnchor, constant: 646/812.0*view.frame.height).isActive = true;
        
        afternoonButton.centerXAnchor.constraint (equalTo: view.centerXAnchor).isActive = true;
        afternoonButton.heightAnchor.constraint (equalToConstant: 32/812.0*view.frame.height).isActive = true;
        afternoonButton.widthAnchor.constraint (equalToConstant: 280/375.0*view.frame.width).isActive = true;
        afternoonButton.topAnchor.constraint (equalTo: view.topAnchor, constant: 691/812.0*view.frame.height).isActive = true;
        
        eveningButton.centerXAnchor.constraint (equalTo: view.centerXAnchor).isActive = true;
        eveningButton.heightAnchor.constraint (equalToConstant: 32/812.0*view.frame.height).isActive = true;
        eveningButton.widthAnchor.constraint (equalToConstant: 280/375.0*view.frame.width).isActive = true;
        eveningButton.topAnchor.constraint (equalTo: view.topAnchor, constant: 736/812.0*view.frame.height).isActive = true;
        
        morningLabel.centerXAnchor.constraint (equalTo: view.centerXAnchor).isActive = true;
        morningLabel.centerYAnchor.constraint (equalTo: morningButton.centerYAnchor).isActive = true;
        
        afternoonLabel.centerXAnchor.constraint (equalTo: view.centerXAnchor).isActive = true;
        afternoonLabel.centerYAnchor.constraint (equalTo: afternoonButton.centerYAnchor).isActive = true;
        
        eveningLabel.centerXAnchor.constraint (equalTo: view.centerXAnchor).isActive = true;
        eveningLabel.centerYAnchor.constraint (equalTo: eveningButton.centerYAnchor).isActive = true;
        
    }
    
    @IBAction func triggerUnwind ()
    {
        performSegue(withIdentifier: "returnFromSettings", sender: self)
    }
}
