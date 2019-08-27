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
import GoogleSignIn
import Nuke

class MainPageViewController: UIViewController {
    
   
    let screenWidth = UIScreen.main.bounds.width;
    let screenHeight = UIScreen.main.bounds.height;
    let calendar = Calendar.current;
    let formatter = DateFormatter()
    let changeTimetable = UserTimetable()
    //timer that keeps on refreshing the view each minute
    var timer: Timer?;
    
    let pipeline = ImagePipeline {
        $0.isProgressiveDecodingEnabled = true
    }
    
    let featureArticle: Article = {
        let articles = UserDataSettings.fetchAllArticles()
        var index = Article()
        var first = true
        for i in articles! {
            if (first) {
                first = false
                index = i
            }
            else if (i.likes > index.likes) {
                index = i
            }
        }
        return index
    }()
    
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
    
    lazy var topArticleLabel: UILabel = {
        let label = UILabel();
        label.font = UIFont (name: "SitkaBanner-Bold", size: 20/375.0*screenWidth);
        label.numberOfLines = 1
        label.textAlignment = .left;
        label.baselineAdjustment = .alignCenters;
        label.backgroundColor = .clear;
        label.text = "Top Article";
        label.adjustsFontSizeToFitWidth = true;
        return label;
    }()
    
    lazy var blueBubble: UIView = {
        let layer = UIView()
        layer.layer.cornerRadius = 15
        layer.backgroundColor = UIColor(red: 0.46, green: 0.75, blue: 0.85, alpha: 1)
        return layer
    }()
    
    lazy var distortion: UIView = {
        let layer = UIView()
        var transform = CGAffineTransform.identity
        transform = transform.rotated(by: -2.007128639793479)
        layer.transform = transform
        layer.layer.cornerRadius = 0
        layer.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.18)
        return layer
    }()
    
    lazy var genreLabel: UILabel = {
        let textLayer = UILabel()
        textLayer.font = UIFont(name: "SitkaBanner", size: 20/375 * screenWidth)
        textLayer.textColor = UIColor.white
        textLayer.translatesAutoresizingMaskIntoConstraints = false
        textLayer.numberOfLines = 1
        textLayer.adjustsFontSizeToFitWidth = true
        textLayer.minimumScaleFactor = 0.7
        textLayer.text = featureArticle.genre.uppercased()
        return textLayer
    }()
    
    lazy var titleLabel: UILabel = {
        let textLayer = UILabel()
        textLayer.font = UIFont(name: "SitkaBanner-Bold", size: 20/375 * screenWidth)
        textLayer.textColor = UIColor.white
        textLayer.translatesAutoresizingMaskIntoConstraints = false
        textLayer.numberOfLines = 2
        textLayer.adjustsFontSizeToFitWidth = true
        textLayer.minimumScaleFactor = 0.5
        textLayer.text = featureArticle.title
        return textLayer
    }()
    
    lazy var readMoreBubble: UIView = {
        let layer = UIView()
        layer.layer.cornerRadius = 15
        layer.layer.borderWidth = 2
        layer.layer.borderColor = UIColor.white.cgColor
        return layer
    }()
    
    lazy var readMoreLabel: UILabel = {
        let textLayer = UILabel()
        textLayer.font = UIFont(name: "SitkaBanner-Bold", size: 14/375 * screenWidth)
        textLayer.textColor = UIColor.white
        textLayer.translatesAutoresizingMaskIntoConstraints = false
        textLayer.numberOfLines = 1
        textLayer.adjustsFontSizeToFitWidth = true
        textLayer.layer.borderColor = UIColor.white.cgColor;
        textLayer.layer.borderWidth = 2/375.0*screenWidth;
        textLayer.textAlignment = .center;
        textLayer.baselineAdjustment = .alignCenters;
        textLayer.minimumScaleFactor = 0.5
        textLayer.text = "READ MORE"
        return textLayer
    }()

    lazy var featuredImage: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.translatesAutoresizingMaskIntoConstraints = false
        img.layer.cornerRadius = 15/375 * UIScreen.main.bounds.width
        img.clipsToBounds = true
        img.backgroundColor = #colorLiteral(red: 0.2038967609, green: 0.3737305999, blue: 0.7035349607, alpha: 1)
        let pipeline = ImagePipeline {
            $0.isProgressiveDecodingEnabled = true
        }
        Nuke.loadImage(with: URL(string: featureArticle.img)!, into: img)
        return img
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
    
    let nextClassView = NextPeriodView()
    
    lazy var profileView: UIView = {
        let view = UIView();
        view.backgroundColor = .clear;
        return view
    }()
    
    lazy var nextFewDaysView: UpcomingDaysView = {
        let view = UpcomingDaysView(numDays: 3, delegate: self);
        return view;
    }()
    
    //temporary image placeholder for te todolist
    /*let toDoIcon: UIButton = {
        let button = UIButton ()
        button.setBackgroundImage(UIImage(named: "toDoIcon"), for: .normal);
        button.addTarget(self, action: #selector (goToToDo), for: .touchUpInside);
        return button;
    }()*/
    
    //for animation between tab bar items
    var nextClassCenter = NSLayoutConstraint()
    var profileTop = NSLayoutConstraint()
    var profileLeading = NSLayoutConstraint()
    var nextDaysCenter = NSLayoutConstraint()
    
    override func viewDidLoad ()
    {
        super.viewDidLoad()
        setup ()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        self.refresh()
        timer = Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector (fireTimer), userInfo: nil, repeats: true);
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
        
        view.addSubview(profileView);
        profileView.translatesAutoresizingMaskIntoConstraints = false;
        profileLeading = profileView.leadingAnchor.constraint (equalTo: view.leadingAnchor);
        profileLeading.isActive = true;
        profileTop = profileView.topAnchor.constraint (equalTo: view.topAnchor);
        profileTop.isActive = true;
        profileView.widthAnchor.constraint (equalToConstant: screenWidth).isActive = true;
        profileView.heightAnchor.constraint (equalToConstant: 120/812.0*screenHeight).isActive = true;
        
        profileView.addSubview(helloLabel);
        helloLabel.translatesAutoresizingMaskIntoConstraints = false;
        helloLabel.topAnchor.constraint (equalTo: profileView.topAnchor, constant: 54/812.0*screenHeight).isActive = true;
        helloLabel.leadingAnchor.constraint (equalTo: profileView.leadingAnchor, constant: 34/375.0*screenWidth).isActive = true;
        helloLabel.trailingAnchor.constraint (equalTo: profileView.trailingAnchor, constant: -100/375.0*screenWidth).isActive = true;
        helloLabel.heightAnchor.constraint (equalToConstant: 90/812.0*screenHeight).isActive = true;
        
        profileView.addSubview(userImage);
        userImage.translatesAutoresizingMaskIntoConstraints = false;
        userImage.heightAnchor.constraint (equalToConstant: 45/375.0*screenWidth).isActive = true;
        userImage.widthAnchor.constraint (equalTo: userImage.heightAnchor).isActive = true;
        userImage.topAnchor.constraint (equalTo: helloLabel.topAnchor).isActive = true;
        userImage.trailingAnchor.constraint (equalTo: profileView.trailingAnchor, constant: -20/375.0*screenWidth).isActive = true;

        //set the image rounded corner
        userImage.layoutIfNeeded();
        userImage.layer.cornerRadius = userImage.frame.height/2;
        
        //set up next class view
        view.addSubview(nextClassView);
        nextClassView.translatesAutoresizingMaskIntoConstraints = false;
        nextClassCenter = nextClassView.centerXAnchor.constraint (equalTo: view.centerXAnchor)
        nextClassCenter.isActive = true;
        nextClassView.topAnchor.constraint (equalTo: view.topAnchor, constant: 171/812.0*screenHeight).isActive = true;
        nextClassView.heightAnchor.constraint(equalToConstant: 54/812.0*screenHeight).isActive = true;
        nextClassView.widthAnchor.constraint (equalToConstant: 334/375.0*screenWidth).isActive = true;
        nextClassView.layoutIfNeeded();
        nextClassView.layer.cornerRadius = nextClassView.frame.height/3;
        
        //the top article label
        view.addSubview(topArticleLabel);
        topArticleLabel.translatesAutoresizingMaskIntoConstraints = false;
        topArticleLabel.topAnchor.constraint (equalTo: view.topAnchor, constant: 260/812.0*screenHeight).isActive = true;
        topArticleLabel.leadingAnchor.constraint (equalTo: view.leadingAnchor, constant: 27/375.0*screenWidth).isActive = true;
        topArticleLabel.heightAnchor.constraint (equalToConstant: 40/812.0*screenHeight).isActive = true;
        topArticleLabel.widthAnchor.constraint (equalToConstant: 93/375.0*screenHeight).isActive = true;
        
        view.addSubview(nextFewDaysView);
        nextFewDaysView.translatesAutoresizingMaskIntoConstraints = false;
        nextDaysCenter = nextFewDaysView.centerXAnchor.constraint (equalTo: view.centerXAnchor)
        nextDaysCenter.isActive = true;
        nextFewDaysView.topAnchor.constraint (equalTo: view.topAnchor, constant: 499/812.0*screenHeight).isActive = true;
        nextFewDaysView.heightAnchor.constraint (equalToConstant: 207/812.0*screenHeight).isActive = true;
        nextFewDaysView.widthAnchor.constraint (equalToConstant: 335/375.0*screenWidth).isActive = true;
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(featured))
        view.addSubview(blueBubble)
        blueBubble.addGestureRecognizer(tap)
        blueBubble.translatesAutoresizingMaskIntoConstraints = false;
        blueBubble.widthAnchor.constraint(equalToConstant: 194/375.0*screenWidth).isActive = true
        blueBubble.heightAnchor.constraint(equalToConstant: 144/812.0*screenHeight).isActive = true
        blueBubble.topAnchor.constraint(equalTo: view.topAnchor, constant: 302/812.0*screenHeight).isActive = true
        blueBubble.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20/375.0*screenWidth).isActive = true
        
        blueBubble.addSubview(distortion)
        distortion.translatesAutoresizingMaskIntoConstraints = false;
        distortion.widthAnchor.constraint(equalToConstant: 73.27/375*screenWidth).isActive = true
        distortion.heightAnchor.constraint(equalToConstant: 90.47/812*screenHeight).isActive = true
        distortion.topAnchor.constraint(equalTo: view.topAnchor, constant: 355.53/812*screenHeight).isActive = true
        distortion.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 140.73/375*screenWidth).isActive = true
        
        blueBubble.addSubview(genreLabel)
        genreLabel.translatesAutoresizingMaskIntoConstraints = false;
        genreLabel.widthAnchor.constraint(equalToConstant: 150/375*screenWidth).isActive = true
        genreLabel.heightAnchor.constraint(equalToConstant: 22/812*screenHeight).isActive = true
        genreLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 325/812*screenHeight).isActive = true
        genreLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 46/375.0*screenWidth).isActive = true
        
        blueBubble.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false;
        titleLabel.widthAnchor.constraint(equalToConstant: 122/375.0*screenWidth).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 36/812.0*screenHeight).isActive = true
        titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 350/812.0*screenHeight).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 44/375.0*screenWidth).isActive = true
        
        blueBubble.addSubview(readMoreLabel)
        readMoreLabel.translatesAutoresizingMaskIntoConstraints = false;
        readMoreLabel.widthAnchor.constraint(equalToConstant: 121/375.0*screenWidth).isActive = true
        readMoreLabel.heightAnchor.constraint(equalToConstant: 27/375.0*screenWidth).isActive = true
        readMoreLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 400/812.0*screenHeight).isActive = true
        readMoreLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40/375.0*screenWidth).isActive = true
        
        //set the corner radius
        readMoreLabel.layoutIfNeeded();
        readMoreLabel.layer.cornerRadius = readMoreLabel.frame.height/2;
        
        view.addSubview(featuredImage)
        featuredImage.translatesAutoresizingMaskIntoConstraints = false;
        featuredImage.widthAnchor.constraint(equalToConstant: 134/375.0*screenWidth).isActive = true
        featuredImage.heightAnchor.constraint(equalToConstant: 144/812.0*screenHeight).isActive = true
        featuredImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 302/812.0*screenHeight).isActive = true
        featuredImage.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 224/375.0*screenWidth).isActive = true
        
    }
    
    //delegate method for upcoming days view (called when one of the days is pressed to go to the corresponding day in the schedule tab
    //idx: the index in the collection view that needs to be shifted to
    func goCheckDay (date: Date)
    {
        guard let scheduleNavControll = self.tabBarController?.viewControllers? [1] as? UINavigationController else {return}
        guard let scheduleTab = scheduleNavControll.topViewController as? ScheduleViewController else {return}
        scheduleTab.defaultIndex = (date, true);
        tabBarController?.selectedIndex = 1; //goes to the schedule tab
    }
    
    //the timer refreshes the view after a certain interval
    @objc func fireTimer ()
    {
        self.refresh()
    }
    
    private func refresh ()
    {
        nextClassView.refresh()
        nextFewDaysView.refresh();
    }
    
    //MARK: Navigations
    
    @IBAction func returnFromToDoList (_ sender: UIStoryboardSegue){}
    
    @objc func goToToDo ()
    {
        performSegue (withIdentifier: "toToDo", sender: self);
    }
    
    @objc func featured() {
        performSegue(withIdentifier: "mainToArticle", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? ArticleViewController {
            destinationVC.article = featureArticle
            destinationVC.source = 2
        }
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
    @IBAction func returnToMain (sender: UIStoryboardSegue) {}
}
