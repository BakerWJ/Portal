//
//  SecondViewController.swift
//  UTS APP
//
//  Created by Jacky He on 2019-04-03.
//  Copyright © 2019 Jacky He. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseFirestore
import CoreData

protocol KeyboardShiftingDelegate: class
{
    func didReceiveData (_ data: Float);
}

class ScheduleViewController: UIViewController, KeyboardShiftingDelegate, UIScrollViewDelegate
{
    //MARK: Properties
    //firebase real time database reference
    let ref = Database.database().reference();
    //firebase firestore reference
    let refstore = Firestore.firestore();
    //The top label that appears at the top of the screen
    var label = UILabel();
    var today = UILabel();
    //an array of schedules for the day.
    var schedules = [Schedule]()
    //an weekly schedule object
    var weeklySchedule: WeeklySchedule?
    //formates the date
    let formatter = DateFormatter ()
    //a timer that triggers an event every 2 seconds
    let timer = RepeatingTimer (timeInterval: 2);
    let calendar = Calendar.current;
    
    //constraint for keyboard shifting
    var topConstraint: NSLayoutConstraint!
    //outermost stackview
    let outerView = UIView();
    var tempView = UIScrollView()
    var keyboardHeight = 0.0;
    var textFieldCoordinateY = 0.0
    
    //Some code is in viewWillAppear to avoid overcrowding viewDidLoad ()
    override func viewWillAppear (_ animated: Bool)
    {
        super.viewWillAppear (animated);
        //printFonts()
        //add observer of the keyboard showing
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    override func viewWillDisappear(_ animated: Bool)
    {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    override func viewDidLoad ()
    {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 243.0/255, green: 243.0/255, blue: 243.0/255, alpha: 1.0);
        //as the name suggests, fetches schedules from core Data and stores them in the array "schedules"
        fetchSchedules ()
        //setup the outerstackview and its constraints
        outerViewSetup();
        //as the name suggests, gets the information needed for the day
        updateSchedule()
    }
    
    //setup the outerstackview and its constraints
    func outerViewSetup ()
    {
        self.view.addSubview (outerView);
        outerView.frame = self.view.frame;
        outerView.translatesAutoresizingMaskIntoConstraints = false;
        topConstraint = NSLayoutConstraint (item: outerView, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1.0, constant: 0);
        topConstraint.isActive = true;
        outerView.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true;
        outerView.heightAnchor.constraint(equalToConstant: self.view.frame.height).isActive = true;
        outerView.leadingAnchor.constraint (equalTo: self.view.leadingAnchor).isActive = true;
        outerView.trailingAnchor.constraint (equalTo: self.view.trailingAnchor).isActive = true;
        self.view.addConstraints ([topConstraint]);
        
        //sets up the super big text on the top
        today.text = "TODAY";
        today.font = UIFont (name: "Arial-BoldMT", size: 32);
        today.textAlignment = .center;
        outerView.addSubview (today);
        today.translatesAutoresizingMaskIntoConstraints = false;
        today.leadingAnchor.constraint (equalTo: outerView.leadingAnchor).isActive = true;
        today.trailingAnchor.constraint (equalTo: outerView.trailingAnchor).isActive = true;
        today.topAnchor.constraint(equalTo: outerView.topAnchor, constant: 60/812.0*view.frame.height).isActive = true;
        today.heightAnchor.constraint (equalToConstant: 35/812.0*view.frame.height);

        
        //sets the frame and alignment for the label at the top of the page
        formatter.dateFormat = "MMMM";
        let tempstring = formatter.string(from: Date()).uppercased();
        formatter.dateFormat = "d";
        label.text = formatter.string (from: Date()) + " " + tempstring;
        label.font = UIFont (name: "SegoeUI", size: 14);
        label.textAlignment = .center
        label.textColor = UIColor (red: 132/255.0, green: 132.0/255, blue: 132.0/255, alpha: 1.0)
        outerView.addSubview (label);
        label.translatesAutoresizingMaskIntoConstraints = false;
        label.leadingAnchor.constraint (equalTo: outerView.leadingAnchor).isActive = true;
        label.trailingAnchor.constraint (equalTo: outerView.trailingAnchor).isActive = true;
        label.topAnchor.constraint(equalTo: outerView.topAnchor, constant: 95/812.0*view.frame.height).isActive = true;
        label.heightAnchor.constraint (equalToConstant: 25/812.0*view.frame.height);

    }
    
    //This method gives the timer an event handler (code to execute every time interval) and starts the timer.
    func constructTimer ()
    {
        if let schedule = view.viewWithTag (13) //gets the current schedule
        {
            let periods = schedule.subviews  //gets the periods in this schedule
            timer.eventHandler =
                {
                    let curr = Date()  //gets today's date and time, FOR TESTING AT HOME: just change this to some time that fits
                    //within one of the intervals and test the glowing animation
                    //loop through the periods in the schedule
                    for each in periods
                    {
                        if let period = each as? PeriodView //casts the Any object to periodView
                        {
                            //Compares the start time, current time and endtime of an period to see if the current time fits within
                            //The time interval
                            let interval1 = period.startTime.timeIntervalSince (self.calendar.startOfDay(for: period.startTime))
                            let interval2 = curr.timeIntervalSince(self.calendar.startOfDay(for: curr))
                            let interval3 = period.endTime.timeIntervalSince(self.calendar.startOfDay(for: period.endTime))
                            //if it fits, then make this period glow, if not, then make it unglow.
                            if (interval1 < interval2) && (interval2 < interval3)
                            {
                                //if it is already glowing, then don't do anything, otherwise, make it glow
                                if (period.glowing != true)
                                {
                                    //Cannot call the methods when using another thread or not the Main thread, so use dispatchqueue
                                    DispatchQueue.main.async {period.unglow(); period.glow()}
                                    period.glowing = true;
                                }
                                
                            }
                            else
                            {
                                DispatchQueue.main.async{period.unglow()}
                                period.glowing = false;
                            }
                        }
                    }
            }
            //starts the timer
            timer.resume()
        }
    }
    
    
    
    //This method uploads the schedules stored in core data into the "schedule" array.
    func fetchSchedules ()
    {
        //fetch data from core data
        let fetchRequest = NSFetchRequest<NSFetchRequestResult> (entityName: "Schedule");
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
        let fetchRequest2 = NSFetchRequest<NSFetchRequestResult> (entityName: "WeeklySchedule");
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
    
    //This method gets information necessary for the day and updates the view
    func updateSchedule ()
    {
        //gets the current date
        let date = Date();
        //Sunday is 1, Saturday is 7, gets today's weekday count
        let weekday = calendar.component(.weekday, from: date);
        print (schedules.count)
        //fetch data from firebase database about the daily schedules.
        if weeklySchedule?.typeOfDay [weekday - 1] == 4
        {
            //creates an image that says enjoy the weekend
            let image = UIImageView(image: UIImage (named: "enjoyWeekend"));
            //adds the image to the view to display
            self.outerView.addSubview (image);
            //sets layout constraints
            image.translatesAutoresizingMaskIntoConstraints = false;
            image.centerXAnchor.constraint(equalTo: self.outerView.centerXAnchor).isActive = true;
            image.centerYAnchor.constraint(equalTo: self.outerView.centerYAnchor).isActive = true;
            image.widthAnchor.constraint(equalToConstant: 320/812*view.frame.height).isActive = true;
            image.heightAnchor.constraint (equalToConstant: 360/812*view.frame.height).isActive = true;
        }
        else
        {
            //loops through all the possible schedules
            for each in self.schedules
            {
                //if the schedule has the same value as the value of the wanted schedule
                if each.value == Int32((weeklySchedule?.typeOfDay [weekday - 1])!)
                {
                    //The things/decorations on top of the actual schedule starts
                    //label that says schedule
                    let labelSchedule = UILabel ()
                    labelSchedule.textAlignment = .center;
                    labelSchedule.font = UIFont (name: "SegoeUI-Bold", size: 16);
                    labelSchedule.text = "Schedule";
                    labelSchedule.layer.opacity = 0;
                    self.outerView.addSubview (labelSchedule);
                    labelSchedule.translatesAutoresizingMaskIntoConstraints = false;
                    labelSchedule.leadingAnchor.constraint(equalTo: self.outerView.leadingAnchor).isActive = true;
                    labelSchedule.trailingAnchor.constraint(equalTo: self.outerView.trailingAnchor).isActive = true;
                    labelSchedule.heightAnchor.constraint(equalToConstant: 20/812.0*view.frame.height).isActive = true;
                    labelSchedule.topAnchor.constraint (equalTo: self.label.topAnchor, constant: 50.0/812*view.frame.height).isActive = true;
                    //make an image for the title on top
                    let image = UIImageView (image: UIImage (named: "Rectangle 1028"));
                    let biggerview = UIView();
                    biggerview.layer.opacity = 0;
                    self.outerView.addSubview (biggerview);
                    //set constraint for the outerview
                    biggerview.translatesAutoresizingMaskIntoConstraints = false;
                    biggerview.trailingAnchor.constraint (equalTo: self.outerView.trailingAnchor).isActive = true;
                    biggerview.leadingAnchor.constraint (equalTo: self.outerView.leadingAnchor).isActive = true;
                    biggerview.heightAnchor.constraint (equalToConstant: 43/812.0*view.frame.height).isActive = true;
                    biggerview.topAnchor.constraint (equalTo: labelSchedule.topAnchor, constant: 26/812.0*view.frame.height).isActive = true;
                    biggerview.addSubview (image);
                    //set constraints for the image
                    image.translatesAutoresizingMaskIntoConstraints = false;
                    image.leadingAnchor.constraint (equalTo: biggerview.leadingAnchor).isActive = true;
                    image.trailingAnchor.constraint (equalTo: biggerview.trailingAnchor).isActive = true;
                    image.topAnchor.constraint (equalTo: biggerview.topAnchor).isActive = true;
                    image.bottomAnchor.constraint (equalTo: biggerview.bottomAnchor).isActive = true;
                    //set up the label for what kind of day today is
                    let dayLabel = UILabel();
                    dayLabel.textAlignment = .center;
                    dayLabel.font = UIFont(name: "SegoeUI", size: 16);
                    dayLabel.textColor = .white;
                    dayLabel.text = "It's " + each.kind;
                    biggerview.addSubview (dayLabel);
                    dayLabel.translatesAutoresizingMaskIntoConstraints = false;
                    dayLabel.centerXAnchor.constraint(equalTo: biggerview.centerXAnchor).isActive = true;
                    dayLabel.centerYAnchor.constraint(equalTo: biggerview.centerYAnchor).isActive = true;
                    //The things/decorations on top of the actual schedule ends
                    
                    //then create a scheduleView with the schedule
                    let currentSchedule = ScheduleView(schedule: each, ADay: (weeklySchedule?.abDay [weekday - 1])!, flipped: (weeklySchedule?.flipOrNot [weekday - 1])!, delegate: self);
                    //The tag is set to 13 so that you can access this object from anywhere else in the program
                    currentSchedule.tag = 13;
                    
                    //Embeds the scheduleView into another UIView so that the borders are even
                    self.outerView.addSubview (self.tempView);
                    //add currentSchedule to tempView
                    self.tempView.addSubview (currentSchedule)
                    
                    //sets layout constraints for currentSchedule
                    currentSchedule.translatesAutoresizingMaskIntoConstraints = false;
                    currentSchedule.centerXAnchor.constraint(equalTo: self.outerView.centerXAnchor).isActive = true;
                    currentSchedule.topAnchor.constraint (equalTo: self.tempView.topAnchor).isActive = true;
                    currentSchedule.bottomAnchor.constraint (equalTo: self.tempView.bottomAnchor).isActive = true;
                    currentSchedule.leadingAnchor.constraint (equalTo: self.tempView.leadingAnchor).isActive = true;
                    currentSchedule.trailingAnchor.constraint (equalTo: self.tempView.trailingAnchor).isActive = true;
                    currentSchedule.spacing = 6;
                    currentSchedule.backgroundColor = .clear

                    //sets layoutConstraints for tempView
                    self.tempView.translatesAutoresizingMaskIntoConstraints = false;
                    self.tempView.topAnchor.constraint (equalTo: biggerview.bottomAnchor).isActive = true;
                    self.tempView.centerXAnchor.constraint(equalTo: self.outerView.centerXAnchor).isActive = true;
                    self.tempView.widthAnchor.constraint (equalTo: self.outerView.widthAnchor).isActive = true;
                    self.tempView.heightAnchor.constraint (equalToConstant: 450/812.0*view.frame.height).isActive = true;
                    
                    //sets the border opacity to 0
                    self.tempView.layer.opacity = 0;
                    
                    //set scrollview stuff
                    tempView.isScrollEnabled = true;
                    tempView.alwaysBounceVertical = true;
                    
                    //makes the schedule and everything fade in
                    UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseInOut, animations: {
                        self.tempView.layer.opacity = 1;
                        biggerview.layer.opacity = 1;
                        labelSchedule.layer.opacity = 1;
                    }, completion: nil)
                    
                    //breaks out of the loop
                    break;
                }
            }
            //after all of that, the timer is constructed and will begin to track the current period
            self.constructTimer()
        }
    }
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    /*
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    //When the keyboard will show, get the keyboard height and animate the textfield to the appropriate position by changing the top constraint of the outerView
    @objc func keyboardWillShow (notification: NSNotification)
    {
        if let keyboardSize = (notification.userInfo? [UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        {
            keyboardHeight = Double(keyboardSize.height)
            if let schedule = self.view.viewWithTag(13) as? ScheduleView
            {
                let targetY = CGFloat(Double(self.view.frame.height) - self.keyboardHeight - 60);
                let textFieldY = self.topConstraint.constant + CGFloat(self.textFieldCoordinateY) + self.tempView.convert(schedule.frame.origin, to: self.view).y;
                let difference = targetY - textFieldY;
                let targetOffset = self.topConstraint.constant + difference;
                if (difference < 0)
                {
                    DispatchQueue.main.async
                    {
                        UIView.animate(withDuration: 0.3, animations: {
                            self.topConstraint.constant = targetOffset;
                            self.view.layoutIfNeeded();
                        }, completion: nil)
                    }
                }
            }
        }
    }
    
    //When the keyboard hides, then animate back to the normal position
    @objc func keyboardWillHide (notification: NSNotification)
    {
        DispatchQueue.main.async
        {
            UIView.animate (withDuration: 0.3, animations: {
                self.topConstraint.constant = 0;
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    //conform to protocol
    func didReceiveData(_ data: Float)
    {
        textFieldCoordinateY = Double(data);
    }
}
