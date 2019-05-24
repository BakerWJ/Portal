//
//  MainPageViewController.swift
//  TimeStamp
//
//  Created by Baker Jackson on 2019-04-29.
//  Copyright © 2019 Baker Jackson. All rights reserved.
//

import UIKit
import Firebase
import CoreData
class MainPageViewController: UIViewController {
    
    //the top label that appears at the top of the screen
   
    @IBOutlet weak var todayLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var redImage: UIImageView!
    @IBOutlet weak var typeOfDayLabel: UILabel!
    @IBOutlet weak var schoolStartTimeLabel: UILabel!
    
    
    //formates the date
    let formatter = DateFormatter()
    //user calendar
    let calendar = Calendar.current
    //outermost stackview
    let stackview = UIStackView();
    //a weekly schedule object
    var weeklySchedule: WeeklySchedule?
    //an array of schedules for the day
    var schedules = [Schedule] ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setup()
        setConstraints()
    }
    
    private func fetchSchedules()
    {
        //fetch data from core data
        let fetchRequest = NSFetchRequest <NSFetchRequestResult> (entityName: "Schedule");
        do
        {
            if let results = try CoreDataStack.managedObjectContext.fetch (fetchRequest) as? [Schedule]
            {
                schedules = results;
            }
        }
        catch
        {
            fatalError ("There was an error fetching the list of schedules!")
        }
        let fetchRequest2 = NSFetchRequest <NSFetchRequestResult> (entityName: "WeeklySchedule");
        do
        {
            if let results = try CoreDataStack.managedObjectContext.fetch (fetchRequest2) as? [WeeklySchedule]
            {
                weeklySchedule = results [0]
            }
        }
        catch
        {
            fatalError("There was an error fetching the list of weeklySchedules!")
        }

    }
    private func setup ()
    {
        //sets the date format of today
        formatter.dateFormat = "MMMM";
        let tempstring = formatter.string (from: Date()).uppercased();
        formatter.dateFormat = "d";
        dateLabel.text = formatter.string (from: Date()) + " " + tempstring;
        fetchSchedules();
        //gets the current date
        let date = Date();
        //Sunday is 1, Saturday is 7, gets today's weekday count
        let weekday = calendar.component (.weekday, from: date);
        if weeklySchedule?.typeOfDay [weekday - 1] == 4
        {
            typeOfDayLabel.text = "No School Today!";
            schoolStartTimeLabel.text = "school closed";
        }
        else
        {
            formatter.dateFormat = "h mm";
            for each in self.schedules
            {
                if each.value == Int32 ((weeklySchedule?.typeOfDay [weekday - 1])!)
                {
                    typeOfDayLabel.text = "Today is " + each.kind;
                    for period in each.periods!
                    {
                        if let period = period as? Period
                        {
                            if period.correspond != 0
                            {
                                schoolStartTimeLabel.text = "SCHOOL STARTS AT " + formatter.string(from: period.startTime as Date)
                                break;
                            }
                        }
                    }
                    break;
                }
            }
        }
    }
    private func setConstraints ()
    {
        todayLabel.translatesAutoresizingMaskIntoConstraints = false;
        dateLabel.translatesAutoresizingMaskIntoConstraints = false;
        redImage.translatesAutoresizingMaskIntoConstraints = false;
        typeOfDayLabel.translatesAutoresizingMaskIntoConstraints = false;
        schoolStartTimeLabel.translatesAutoresizingMaskIntoConstraints = false;
        
        todayLabel.leadingAnchor.constraint (equalTo: view.leadingAnchor).isActive = true;
        todayLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true;
        todayLabel.topAnchor.constraint (equalTo: view.topAnchor, constant: 60/812.0*view.frame.height).isActive = true;
        todayLabel.heightAnchor.constraint (equalToConstant: 35/812.0*view.frame.height);
        
        dateLabel.leadingAnchor.constraint (equalTo: view.leadingAnchor).isActive = true;
        dateLabel.trailingAnchor.constraint (equalTo: view.trailingAnchor).isActive = true;
        dateLabel.topAnchor.constraint (equalTo: view.topAnchor, constant: 95/812.0*view.frame.height).isActive = true;
        dateLabel.heightAnchor.constraint (equalToConstant: 25/812.0*view.frame.height);
        
        redImage.heightAnchor.constraint (equalToConstant: 59/812.0*view.frame.height).isActive = true;
        redImage.topAnchor.constraint (equalTo: view.topAnchor, constant: 213/812.0*view.frame.height).isActive = true;
        redImage.centerXAnchor.constraint (equalTo: view.centerXAnchor).isActive = true;
        
        typeOfDayLabel.topAnchor.constraint (equalTo: view.topAnchor, constant: 221/812.0*view.frame.height).isActive = true;
        typeOfDayLabel.centerXAnchor.constraint (equalTo: view.centerXAnchor).isActive = true;
        typeOfDayLabel.heightAnchor.constraint (equalToConstant: 23/812.0*view.frame.height).isActive = true;
        schoolStartTimeLabel.topAnchor.constraint (equalTo: view.topAnchor, constant: 245/812.0*view.frame.height).isActive = true;
        schoolStartTimeLabel.centerXAnchor.constraint (equalTo: view.centerXAnchor).isActive = true;
        schoolStartTimeLabel.heightAnchor.constraint (equalToConstant: 11/812.0*view.frame.height).isActive = true;
    }

}
