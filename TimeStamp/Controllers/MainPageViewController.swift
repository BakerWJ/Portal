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


class MainPageViewController: UIViewController {
   
    let screenWidth = UIScreen.main.bounds.width;
    let screenHeight = UIScreen.main.bounds.height;
    let calendar = Calendar.current;
    let formatter = DateFormatter()
    let changeTimetable = UserTimetable()
    //timer that keeps on refreshing the view each minute
    var timer: Timer?;
    
    //gets the user's name, if it's not available, then it just says hello
    lazy var helloLabel: UILabel = {
        let label = UILabel ();
        label.font = UIFont (name: "SitkaBanner", size: 40/375.0*screenWidth);
        label.text = "Hello!";
        if let username = UserDefaults.standard.string(forKey: "username")
        {
            label.text = "Hello,\n" + username + "!";
        }
        label.numberOfLines = 2;
        label.baselineAdjustment = .alignCenters;
        label.textAlignment = .left;
        label.adjustsFontSizeToFitWidth = true;
        label.backgroundColor = .clear
        return label;
    }()
    
    //gets the user's google image
    lazy var userImage: UIImageView = {
        var image = UIImageView()
        if let data = UserDefaults.standard.data(forKey: "userimage")
        {
            image.image = UIImage(data: data);
        }
        image.layer.masksToBounds = true;
        image.clipsToBounds = true;
        return image;
    }()
    
    //this view contains the next class label, and the time when it starts
    lazy var nextClassView: UIView = {
        let view = UIView ();
        view.backgroundColor = .clear
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 1;
        return view;
    }()
    
    //this shows what the next class is
    lazy var nextClassLabel: UILabel = {
        let label = UILabel();
        label.backgroundColor = .clear;
        label.textAlignment = .left;
        label.baselineAdjustment = .alignCenters;
        label.numberOfLines = 2;
        label.adjustsFontSizeToFitWidth = true;
        return label
    }()
    
    //this shows when the next class is
    lazy var nextClassTimeLabel: UILabel = {
        let label = UILabel();
        label.backgroundColor = .clear;
        label.textAlignment = .left;
        label.baselineAdjustment = .alignBaselines;
        return label;
    }()
    
    override func viewDidLoad ()
    {
        super.viewDidLoad()
        setup ()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        self.refresh()
        timer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector (fireTimer), userInfo: nil, repeats: true);
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated);
        //stops the timer when the view disappears
        timer?.invalidate()
    }
    
    private func setup ()
    {
        //makes navigation bar transparent
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default);
        self.navigationController?.navigationBar.shadowImage = UIImage();
        self.navigationController?.navigationBar.isTranslucent = true;
        
        view.backgroundColor = .white;
        view.addSubview(helloLabel);
        helloLabel.translatesAutoresizingMaskIntoConstraints = false;
        helloLabel.topAnchor.constraint (equalTo: view.topAnchor, constant: 54/812.0*screenHeight).isActive = true;
        helloLabel.leadingAnchor.constraint (equalTo: view.leadingAnchor, constant: 34/375.0*screenWidth).isActive = true;
        helloLabel.trailingAnchor.constraint (equalTo: view.trailingAnchor, constant: -100/375.0*screenWidth).isActive = true;
        helloLabel.heightAnchor.constraint (equalToConstant: 90/812.0*screenHeight).isActive = true;
        
        view.addSubview(userImage);
        userImage.translatesAutoresizingMaskIntoConstraints = false;
        userImage.heightAnchor.constraint (equalToConstant: 45/375.0*screenWidth).isActive = true;
        userImage.widthAnchor.constraint (equalTo: userImage.heightAnchor).isActive = true;
        userImage.topAnchor.constraint (equalTo: helloLabel.topAnchor).isActive = true;
        userImage.trailingAnchor.constraint (equalTo: view.trailingAnchor, constant: -20/375.0*screenWidth).isActive = true;
        
        //set the image rounded corner
        userImage.layoutIfNeeded();
        userImage.layer.cornerRadius = userImage.frame.height/2;
        
        setUpNextClassView ()
    }
    
    private func setUpNextClassView ()
    {
        view.addSubview(nextClassView);
        nextClassView.translatesAutoresizingMaskIntoConstraints = false;
        nextClassView.centerXAnchor.constraint (equalTo: view.centerXAnchor).isActive = true;
        nextClassView.topAnchor.constraint (equalTo: view.topAnchor, constant: 160/812.0*screenHeight).isActive = true;
        nextClassView.heightAnchor.constraint(equalToConstant: 54/812.0*screenHeight).isActive = true;
        nextClassView.widthAnchor.constraint (equalToConstant: 334/375.0*screenWidth).isActive = true;
        nextClassView.layoutIfNeeded();
        nextClassView.layer.cornerRadius = nextClassView.frame.height/3;
        
        nextClassView.addSubview(nextClassLabel);
        nextClassLabel.translatesAutoresizingMaskIntoConstraints = false;
        nextClassLabel.leadingAnchor.constraint (equalTo: nextClassView.leadingAnchor, constant: 20.54/375.0*screenWidth).isActive = true;
        nextClassLabel.centerYAnchor.constraint (equalTo: nextClassView.centerYAnchor).isActive = true;
        nextClassLabel.widthAnchor.constraint (equalToConstant: 138/375.0*screenWidth).isActive = true;
        nextClassLabel.heightAnchor.constraint (equalTo: nextClassView.heightAnchor).isActive = true;
    
        nextClassView.addSubview(nextClassTimeLabel);
        nextClassTimeLabel.translatesAutoresizingMaskIntoConstraints = false;
        nextClassTimeLabel.trailingAnchor.constraint (equalTo: nextClassView.trailingAnchor, constant: -20.54/375.0*screenWidth).isActive = true;
        nextClassTimeLabel.heightAnchor.constraint (equalTo: nextClassView.heightAnchor).isActive = true;
        nextClassTimeLabel.centerYAnchor.constraint (equalTo: nextClassView.centerYAnchor).isActive = true;
        nextClassTimeLabel.widthAnchor.constraint (equalToConstant: 138.35/375.0*screenWidth).isActive = true;
    }
    
    //the timer refreshes the view after a certain interval
    @objc func fireTimer ()
    {
        self.refresh()
    }
    
    private func refresh ()
    {
        var text = NSMutableAttributedString()
        var time = NSMutableAttributedString()
        //if today there is a next period
        if let nextPeriod = getNextPeriod()
        {
            text = NSMutableAttributedString(string: nextPeriod.0 + "\n", attributes: [.font : UIFont(name: "SitkaBanner-Bold", size: 20/375.0*screenWidth) ?? UIFont.systemFont(ofSize: 20/375.0*screenWidth, weight: .bold)])
            text.append(NSMutableAttributedString(string: "is next. Starts at...", attributes: [.font : UIFont (name: "SitkaBanner", size: 14/375.0*screenWidth) ?? UIFont.systemFont(ofSize: 14/375.0*screenWidth)]))
            
            formatter.dateFormat = "hh:mm";
            time = NSMutableAttributedString(string: formatter.string(from: nextPeriod.1) + " ", attributes: [.font: UIFont (name: "SimSun", size: 40/375.0*screenWidth) ?? UIFont.systemFont(ofSize: 40/375.0*screenWidth)]);
            formatter.dateFormat = "a";
            time.append (NSMutableAttributedString(string: formatter.string (from: nextPeriod.1).uppercased(), attributes: [.font: UIFont(name: "SitkaBanner", size: 14/375.0*screenWidth) ?? UIFont.systemFont(ofSize: 14/375.0*screenWidth)]))
        }
        else if let nextSchoolDay = getNextSchoolDay() //if there isn't a next period in today, then find the next school day there is
        {
            var displayed = "";
            if nextSchoolDay.1 == Util.nextDay() as Date
            {
                displayed = "Tomorrow";
            }
            else
            {
                formatter.dateFormat = "EEEE"
                displayed = formatter.string (from: nextSchoolDay.1)
            }
            text = NSMutableAttributedString(string: displayed + "\n", attributes: [.font : UIFont(name: "SitkaBanner-Bold", size: 20/375.0*screenWidth) ?? UIFont.systemFont(ofSize: 20/375.0*screenWidth, weight: .bold)])
            text.append(NSMutableAttributedString(string: "School starts at...", attributes: [.font : UIFont (name: "SitkaBanner", size: 14/375.0*screenWidth) ?? UIFont.systemFont(ofSize: 14/375.0*screenWidth)]))
            
            formatter.dateFormat = "hh:mm";
            time = NSMutableAttributedString(string: formatter.string(from: nextSchoolDay.0) + " ", attributes: [.font: UIFont (name: "SimSun", size: 40/375.0*screenWidth) ?? UIFont.systemFont(ofSize: 40/375.0*screenWidth)]);
            formatter.dateFormat = "a";
            time.append (NSMutableAttributedString(string: formatter.string (from: nextSchoolDay.0).uppercased(), attributes: [.font: UIFont(name: "SitkaBanner", size: 14/375.0*screenWidth) ?? UIFont.systemFont(ofSize: 14/375.0*screenWidth)]))
        }
        nextClassLabel.attributedText = text;
        nextClassTimeLabel.attributedText = time;
    }
    
    private func getNextSchoolDay () -> (Date, Date)?
    {
        if let schedules = UserDataSettings.fetchAllSchedules(),
        let weeklySchedule = UserDataSettings.fetchWeeklySchedule()
        {
            for x in 1..<5
            {
                let day = Util.next(days: x);
                let weekday = calendar.component(.weekday, from: day as Date);
                if (weeklySchedule.typeOfDay [weekday - 1] != 4)
                {
                    for schedule in schedules
                    {
                        if (schedule.value == weeklySchedule.typeOfDay [weekday - 1])
                        {
                            if let period = schedule.periods?.object(at: 0) as? Period
                            {
                                return (period.startTime as Date, day as Date);
                            }
                        }
                    }
                }
            }
        }
        return nil;
    }
    
    private func getNextPeriod () -> (String, Date)?
    {
        //get the schedules and weeklySchedules
        if let schedules = UserDataSettings.fetchAllSchedules(),
            let weeklySchedule = UserDataSettings.fetchWeeklySchedule()
        {
            //get the schedule for today
            let today = Util.next(days: 0);
            let weekday = calendar.component(.weekday, from: today as Date);
            var todaySchedule: Schedule?
            var flipped: Bool?
            var ADay: Bool?
            for schedule in schedules
            {
                if (schedule.value == weeklySchedule.typeOfDay [weekday - 1])
                {
                    todaySchedule = schedule;
                    flipped = weeklySchedule.flipOrNot [weekday - 1];
                    ADay = weeklySchedule.abDay[weekday - 1]
                    break;
                }
            }
            //if there is a schedule for today
            if let todaySchedule = todaySchedule,
                let flipped = flipped,
                let ADay = ADay
            {
                if let todayPeriods = todaySchedule.periods
                {
                    //loop through the periods in today (orderd in time of date)
                    for period in todayPeriods
                    {
                        if let period = period as? Period
                        {
                            if period.startTime as Date > Date()
                            {
                                //finds what the name of this period should be after accounting for flipped day, a day, or irregular days as well as what the user inputed
                                if Int(period.correspond) == 0
                                {
                                    return (period.periodName, period.startTime as Date);
                                }
                                var userInput = "";
                                if (period.additionalNotes == "A")
                                {
                                    userInput = changeTimetable.query (ADay: true, flipped: flipped, classnumber: Int (period.correspond));
                                }
                                else if (period.additionalNotes == "B")
                                {
                                    userInput = changeTimetable.query (ADay: false, flipped: flipped, classnumber: Int (period.correspond));
                                }
                                else
                                {
                                    userInput = changeTimetable.query (ADay: ADay, flipped: flipped, classnumber: Int(period.correspond))
                                }
                                if userInput == ""
                                {
                                    return (period.periodName, period.startTime as Date);
                                }
                                return (userInput, period.startTime as Date)
                            }
                        }
                    }
                }
            }
        }
        return nil;
    }

    
    
    /*
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
 */
}
