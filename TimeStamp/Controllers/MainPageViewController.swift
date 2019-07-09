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
import GoogleAPIClientForREST
import GoogleSignIn


class MainPageViewController: UIViewController, EventPressedDelegate {
   
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
    
    //a weekly schedule object
    var weeklySchedule: WeeklySchedule?
    //an array of schedules for the day
    var schedules = [Schedule] ()
    let Q_AIcon = UIButton ();
    let ToDoIcon = UIButton ();
    let calendarService = GTLRCalendarService ()
    
    //get the screenwidth and height;
    let screenWidth = UIScreen.main.bounds.size.width;
    let screenHeight = UIScreen.main.bounds.size.height;
    
    let addEventButton = UIButton();
    
    var startTime = Date()
    var endTime = Date();
    var detail = "";
    var eventTitle = "";
    
    //pads the view when the addEventButton is shown
    let paddingView = UIView()
    
    //an array of future events
    var events = [Event] ();
    
    var slideout = UIView();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setup()
        setConstraints()
    }
    
    private func fetchSchedulesAndEvents()
    {
        //fetch schedules from core data
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
        
        //fetches weeklyschedule
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
        
        //fetches events
        let fetchRequest3 = NSFetchRequest <NSFetchRequestResult> (entityName: "Event");
        do
        {
            if let res = try CoreDataStack.managedObjectContext.fetch(fetchRequest3) as? [Event]
            {
                //sorts the events in ascending order first by their start time and then by their end time
                events = res.sorted(by: { (a, b) -> Bool in
                    return !(a.startTime as Date > b.startTime as Date || (a.startTime as Date == b.startTime as Date && a.endTime as Date > b.endTime as Date))
                });
            }
        }
        catch
        {
            fatalError ("There was an error fetching the list of events")
        }
        
    }
    
    private func setup ()
    {
        //sets the date format of today
        formatter.dateFormat = "MMMM";
        let tempstring = formatter.string (from: Date()).uppercased();
        formatter.dateFormat = "d";
        dateLabel.text = formatter.string (from: Date()) + " " + tempstring;
        fetchSchedulesAndEvents();
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
            formatter.dateFormat = "h:mm";
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
        
        typeOfDayLabel.font = UIFont(name: "SegoeUI", size: 16/812.0*view.frame.height);
        todayLabel.font = UIFont (name: "Arial-BoldMT", size: 32.0/812.0*view.frame.height);
        schoolStartTimeLabel.font = UIFont (name: "SegoeUI", size: 14/812.0*view.frame.height);
        dateLabel.font = UIFont (name: "SegoeUI", size: 14/812.0*view.frame.height);

        //makes navigation bar transparent
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default);
        self.navigationController?.navigationBar.shadowImage = UIImage();
        self.navigationController?.navigationBar.isTranslucent = true;
        
        //MARK: setup the scrolling through events of the day
        slideout = SlideOutView(events: events, delegate: self);
        view.addSubview (slideout)
        
        setUpAddEventButton()
        setUpAndAddPadding ()
    }
    private func setConstraints ()
    {
        todayLabel.translatesAutoresizingMaskIntoConstraints = false;
        dateLabel.translatesAutoresizingMaskIntoConstraints = false;
        redImage.translatesAutoresizingMaskIntoConstraints = false;
        typeOfDayLabel.translatesAutoresizingMaskIntoConstraints = false;
        schoolStartTimeLabel.translatesAutoresizingMaskIntoConstraints = false;
        slideout.translatesAutoresizingMaskIntoConstraints = false;
        
        todayLabel.leadingAnchor.constraint (equalTo: view.leadingAnchor).isActive = true;
        todayLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true;
        todayLabel.topAnchor.constraint (equalTo: view.topAnchor, constant: 100/812.0*view.frame.height).isActive = true;
        todayLabel.heightAnchor.constraint (equalToConstant: 35/812.0*view.frame.height);
        
        dateLabel.leadingAnchor.constraint (equalTo: view.leadingAnchor).isActive = true;
        dateLabel.trailingAnchor.constraint (equalTo: view.trailingAnchor).isActive = true;
        dateLabel.topAnchor.constraint (equalTo: view.topAnchor, constant: 135/812.0*view.frame.height).isActive = true;
        dateLabel.heightAnchor.constraint (equalToConstant: 25/812.0*view.frame.height);
        
        redImage.heightAnchor.constraint (equalToConstant: 59/812.0*view.frame.height).isActive = true;
        redImage.topAnchor.constraint (equalTo: view.topAnchor, constant: 200/812.0*view.frame.height).isActive = true;
        redImage.centerXAnchor.constraint (equalTo: view.centerXAnchor).isActive = true;
        
        typeOfDayLabel.topAnchor.constraint (equalTo: view.topAnchor, constant: 208/812.0*view.frame.height).isActive = true;
        typeOfDayLabel.centerXAnchor.constraint (equalTo: view.centerXAnchor).isActive = true;
        typeOfDayLabel.heightAnchor.constraint (equalToConstant: 23/812.0*view.frame.height).isActive = true;
        typeOfDayLabel.leadingAnchor.constraint (equalTo: view.leadingAnchor).isActive = true;
        typeOfDayLabel.trailingAnchor.constraint (equalTo: view.trailingAnchor).isActive = true;
        
        schoolStartTimeLabel.topAnchor.constraint (equalTo: view.topAnchor, constant: 232/812.0*view.frame.height).isActive = true;
        schoolStartTimeLabel.centerXAnchor.constraint (equalTo: view.centerXAnchor).isActive = true;
        schoolStartTimeLabel.heightAnchor.constraint (equalToConstant: 15/812.0*view.frame.height).isActive = true;
        schoolStartTimeLabel.leadingAnchor.constraint (equalTo: view.leadingAnchor).isActive = true;
        schoolStartTimeLabel.trailingAnchor.constraint (equalTo: view.trailingAnchor).isActive = true;
        
        //sets up the two icons that appear at the top in the navigation bar
        Q_AIcon.setBackgroundImage (UIImage(named: "Q&AIcon"), for: .normal);
        Q_AIcon.addTarget(self, action: #selector (goToQ_A), for: .touchUpInside);
        let barItem = UIBarButtonItem (customView: Q_AIcon);
        navigationItem.leftBarButtonItem = barItem;
        Q_AIcon.translatesAutoresizingMaskIntoConstraints = false;
        Q_AIcon.heightAnchor.constraint (equalToConstant: 30/812.0*view.frame.height).isActive = true;
        Q_AIcon.widthAnchor.constraint (equalToConstant: 30/812.0*view.frame.height).isActive = true;
        
        ToDoIcon.setBackgroundImage (UIImage (named: "toDoIcon"), for: .normal);
        ToDoIcon.addTarget (self, action: #selector (goToToDo), for: .touchUpInside);
        let barItem2 = UIBarButtonItem(customView: ToDoIcon);
        navigationItem.rightBarButtonItem = barItem2;
        ToDoIcon.translatesAutoresizingMaskIntoConstraints = false;
        ToDoIcon.heightAnchor.constraint (equalToConstant: 30/812.0*view.frame.height).isActive = true;
        ToDoIcon.widthAnchor.constraint (equalToConstant: 30/812.0*view.frame.height).isActive = true;
        
        slideout.topAnchor.constraint (equalTo: view.topAnchor, constant: 285/812.0*view.frame.height).isActive = true;
        slideout.widthAnchor.constraint (equalTo: view.widthAnchor).isActive = true;
        slideout.centerXAnchor.constraint (equalTo: view.centerXAnchor).isActive = true;
        slideout.heightAnchor.constraint(equalToConstant: 450/812.0*view.frame.height).isActive = true;
        
        view.bringSubviewToFront(addEventButton)
    }
    
    private func setUpAddEventButton ()
    {
        view.addSubview (addEventButton);
        addEventButton.backgroundColor = UIColor (red: 219/255.0, green: 103/255.0, blue: 103/255.0, alpha: 1);
        addEventButton.addTarget(self, action: #selector(addEventToCalendar), for: .touchUpInside)
        addEventButton.frame = CGRect(x: 0, y: 0, width: 150/812.0*view.frame.height, height: 40/812.0*view.frame.height)
        addEventButton.layer.opacity = 1;
        addEventButton.setTitle("Add Event to Calendar", for: .normal);
        addEventButton.isHidden = true;
        addEventButton.isUserInteractionEnabled = false;
        addEventButton.setTitleColor(.white, for: .normal)
        addEventButton.titleLabel?.font = UIFont(name: "SegoeUI", size: 14/812.0*view.frame.height);
        addEventButton.layer.cornerRadius = addEventButton.frame.height/2;
        
        //creates a shadow
        let shadowLayer = CAShapeLayer();
        shadowLayer.path = UIBezierPath(roundedRect: addEventButton.bounds, cornerRadius: addEventButton.frame.height/2).cgPath;
        shadowLayer.borderColor = UIColor.black.cgColor;
        shadowLayer.borderWidth = 1;
        shadowLayer.fillColor = UIColor (red: 219/255.0, green: 103/255.0, blue: 103/255.0, alpha: 1).cgColor;
        shadowLayer.shadowPath = shadowLayer.path;
        shadowLayer.shadowOffset = CGSize(width: 0.0, height: 1.0);
        shadowLayer.shadowOpacity = 0.5;
        shadowLayer.shadowRadius = 3;
        
        //adds the layer;
        addEventButton.layer.insertSublayer(shadowLayer, at: 0);
    }
    
    private func setUpAndAddPadding ()
    {
        view.addSubview (paddingView);
        paddingView.backgroundColor = .clear;
        paddingView.frame = view.frame;
        paddingView.isHidden = true;
        paddingView.isUserInteractionEnabled = false;
        paddingView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector (paddingTapped)));
    }
    
    //this adds the current selected event to the user's google calendar
    @objc func addEventToCalendar ()
    {
        if (GIDSignIn.sharedInstance()?.currentUser) == nil
        {
            GIDSignIn.sharedInstance()?.signInSilently()
        }
        //this might throw an error when there is no internet, so need to handle it later
        calendarService.authorizer = GIDSignIn.sharedInstance()?.currentUser.authentication.fetcherAuthorizer();
        calendarService.apiKey = "AIzaSyCcGNgTcpC2_a5ITEhYa5fcql1qbGLKn-U"; //this can be found in google cloud platform
        
        //creates new event with the clicked event's title and detail/description
        let newEvent = GTLRCalendar_Event()
        newEvent.summary = eventTitle
        newEvent.descriptionProperty = detail;
        
        //get the start time and end time
        let offsetMinutes = NSTimeZone.local.secondsFromGMT()/60
        
        let startDateTime = GTLRDateTime(date: startTime, offsetMinutes: offsetMinutes);
        let endDateTme = GTLRDateTime(date: endTime, offsetMinutes: offsetMinutes);
        
        //set the event start and end time
        newEvent.start = GTLRCalendar_EventDateTime();
        newEvent.start?.dateTime = startDateTime;
        
        newEvent.end = GTLRCalendar_EventDateTime();
        newEvent.end?.dateTime = endDateTme;
        
        //create a reminder object
        let reminder = GTLRCalendar_EventReminder()
        reminder.minutes = 10;
        reminder.method = "email";
        
        //adds the reminder
        newEvent.reminders = GTLRCalendar_Event_Reminders()
        newEvent.reminders?.overrides = [reminder];
        newEvent.reminders?.useDefault = false;
        
        //be careful not to type anything wrong with the strings, these things are very sensitive 🙄
        let pathParam = ["calendarId"];
        let URItemplate = "calendars/{calendarId}/events"
        let query = GTLRCalendarQuery_EventsInsert(pathURITemplate: URItemplate, httpMethod: "POST", pathParameterNames: pathParam);
        query.calendarId = "primary";
        query.bodyObject = newEvent;
        query.expectedObjectClass = GTLRCalendar_Event.self
        query.loggingName = "calendar.events.insert";
        
        //executes the query
        calendarService.executeQuery(query) { (callbackTicket, event, callBackError) in
            if (callBackError == nil)
            {
                print ("eventAdded");
            }
            else
            {
                print ("Add Failed");
                print (callBackError?.localizedDescription as Any);
            }
        }
        
        //makes the AddEventButton disappear
        cancelAddEvent()
    }
    
    //called by EventViews when they are pressed and pass in the event properties for animation
    func eventPressed(startTime: Date, endTime: Date, title: String?, detail: String?, xpos: CGFloat, ypos: CGFloat) {
        //sets the current event properties to those passed in
        self.startTime = startTime;
        self.endTime = endTime;
        self.eventTitle = title ?? "";
        self.detail = detail ?? "";
        //moves the addEventButton to the appropriate place and let it fade quickly in
        addEventButton.transform = CGAffineTransform(translationX: xpos - addEventButton.frame.width/2, y: ypos - addEventButton.frame.height/2)
        prepareAddEvent()
    }
    
    //makes the addEventButton appear;
    func prepareAddEvent ()
    {
        view.bringSubviewToFront(paddingView);
        view.bringSubviewToFront(addEventButton)
        addEventButton.isHidden = false;
        paddingView.isHidden = false;
        addEventButton.isUserInteractionEnabled = true;
        paddingView.isUserInteractionEnabled = true;
        UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseIn, animations: {
            self.addEventButton.layer.opacity = 1;
        }, completion: nil)
    }
    
    //make the addEventButton disappear
    func cancelAddEvent ()
    {
        UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseIn, animations: {
            self.addEventButton.layer.opacity = 0;
        }) { (Finished) in
            self.addEventButton.isHidden = true;
            self.addEventButton.isUserInteractionEnabled = false;
            self.paddingView.isHidden = true;
            self.paddingView.isUserInteractionEnabled = false;
        }
    }
    
    //When user taps anything other than the AddEventButton, the button will then be hidden
    @objc func paddingTapped ()
    {
        cancelAddEvent()
    }
    
    @objc func goToQ_A ()
    {
        performSegue(withIdentifier: "toQ&A", sender: self);
    }
    
    @objc func goToToDo ()
    {
        performSegue(withIdentifier: "toToDoList", sender: self);
    }
}
