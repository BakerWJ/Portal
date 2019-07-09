//
//  TodayView.swift
//  TimeStamp
//
//  Created by Jacky He on 2019-07-09.
//  Copyright © 2019 Baker Jackson. All rights reserved.
//

import UIKit

class TodayTomorrowView: UICollectionViewCell
{
    var schedules = [Schedule]();
    var todaynottomo = true;
    var weeklySchedule: WeeklySchedule?
    
    var tempView = UIScrollView()
    //The top label that appears at the top of the screen
    var label = UILabel();
    var today = UILabel();
    var tomorrow = UILabel();
    
    //gets the current user calendar
    let calendar = Calendar.current;
    
    //a timer that triggers an event every 2 seconds
    let timer = RepeatingTimer (timeInterval: 2);
    
    let formatter = DateFormatter ()
    
    let screenWidth = UIScreen.main.bounds.width;
    let screenHeight = UIScreen.main.bounds.height;
    
    let leftarrow = UIImageView (image: UIImage.gifImageWithName("swipetoleft"));
    let rightarrow = UIImageView (image: UIImage.gifImageWithName("swipetoright"));

    let noDataLabel = UILabel ();
    
    var delegate : KeyboardShiftingDelegate?
    
    var loaded = false;
    
    override init(frame: CGRect) {
        super.init (frame: frame)
    }
    required init? (coder: NSCoder)
    {
        super.init (coder: coder);
    }
    init (schedules: [Schedule], today: Bool, weeklySchedule: WeeklySchedule)
    {
        super.init (frame: CGRect());
        self.schedules = schedules;
        self.weeklySchedule = weeklySchedule;
        self.todaynottomo = today;
    }
    
    private func setup ()
    {
        if (todaynottomo)
        {
            //sets up the super big text on the top
            today.text = "TODAY";
            today.font = UIFont (name: "Arial-BoldMT", size: 32.0/812.0*screenHeight);
            today.numberOfLines = 1;
            today.adjustsFontSizeToFitWidth = true;
            today.textAlignment = .center;
            addSubview (today);
            today.translatesAutoresizingMaskIntoConstraints = false;
            today.centerXAnchor.constraint (equalTo: centerXAnchor).isActive = true;
            today.widthAnchor.constraint (equalToConstant: 100/812.0*screenHeight).isActive = true;
            today.topAnchor.constraint(equalTo: topAnchor, constant: 60/812.0*screenHeight).isActive = true;
            today.heightAnchor.constraint (equalToConstant: 35/812.0*screenHeight);
            
            //sets up the left arrow
            addSubview(leftarrow);
            leftarrow.translatesAutoresizingMaskIntoConstraints = false;
            leftarrow.centerYAnchor.constraint (equalTo: today.centerYAnchor).isActive = true;
            leftarrow.leadingAnchor.constraint (equalTo: today.trailingAnchor).isActive = true;
            leftarrow.heightAnchor.constraint (equalToConstant: 35/812.0*screenHeight).isActive = true;
            leftarrow.widthAnchor.constraint (equalToConstant: 55/812.0*screenHeight).isActive = true;
        }
        else
        {
            //sets up the super big text on the top
            tomorrow.text = "TOMORROW";
            tomorrow.font = UIFont (name: "Arial-BoldMT", size: 32/812.0*screenHeight);
            tomorrow.adjustsFontSizeToFitWidth = true;
            tomorrow.numberOfLines = 1;
            tomorrow.textAlignment = .center;
            addSubview (tomorrow);
            tomorrow.translatesAutoresizingMaskIntoConstraints = false;
            tomorrow.centerXAnchor.constraint (equalTo: centerXAnchor).isActive = true;
            tomorrow.widthAnchor.constraint (equalToConstant: 180/812.0*screenHeight).isActive = true;
            tomorrow.topAnchor.constraint(equalTo: topAnchor, constant: 60/812.0*screenHeight).isActive = true;
            tomorrow.heightAnchor.constraint (equalToConstant: 35/812.0*screenHeight);
            
            
            //sets up the right arrow
            addSubview(rightarrow);
            rightarrow.translatesAutoresizingMaskIntoConstraints = false;
            rightarrow.centerYAnchor.constraint (equalTo: tomorrow.centerYAnchor).isActive = true;
            rightarrow.trailingAnchor.constraint (equalTo: tomorrow.leadingAnchor).isActive = true;
            rightarrow.heightAnchor.constraint (equalToConstant: 35/812.0*screenHeight).isActive = true;
            rightarrow.widthAnchor.constraint (equalToConstant: 55/812.0*screenHeight).isActive = true;
        }
        
        let date = Util.next(days: todaynottomo ? 0 : 1) as Date;
        //sets the frame and alignment for the label at the top of the page
        formatter.dateFormat = "MMMM";
        let tempstring = formatter.string(from: date).uppercased();
        formatter.dateFormat = "d";
        label.text = formatter.string (from: date) + " " + tempstring;
        label.font = UIFont (name: "SegoeUI", size: 14/812.0*screenHeight);
        label.adjustsFontSizeToFitWidth = true;
        label.numberOfLines = 1;
        label.textAlignment = .center
        label.textColor = UIColor (red: 132/255.0, green: 132.0/255, blue: 132.0/255, alpha: 1.0);
        addSubview (label);
        label.translatesAutoresizingMaskIntoConstraints = false;
        label.leadingAnchor.constraint (equalTo: leadingAnchor).isActive = true;
        label.trailingAnchor.constraint (equalTo: trailingAnchor).isActive = true;
        label.topAnchor.constraint(equalTo: topAnchor, constant: 95/812.0*screenHeight).isActive = true;
        label.heightAnchor.constraint (equalToConstant: 25/812.0*screenHeight);
        
        //adds the no Data Label at the center but only shows it if there is no data;
        noDataLabel.font = UIFont (name: "SegoeUI", size: 15);
        noDataLabel.textColor = .black;
        noDataLabel.text = "No Available Data"
        noDataLabel.layer.opacity = 0;
        addSubview (noDataLabel);
        noDataLabel.translatesAutoresizingMaskIntoConstraints = false;
        noDataLabel.centerXAnchor.constraint (equalTo: centerXAnchor).isActive = true;
        noDataLabel.centerYAnchor.constraint (equalTo: centerYAnchor).isActive = true;
    }
    
    //This method gives the timer an event handler (code to execute every time interval) and starts the timer.
    func constructTimer ()
    {
        if let schedule = viewWithTag (13) //gets the current schedule
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
    
    func reloadData (schedules: [Schedule], today: Bool, weeklySchedule: WeeklySchedule?, delegate: KeyboardShiftingDelegate?, reload: Bool)
    {
        if (!reload)
        {
            return;
        }
        loaded = true;
        self.schedules = schedules;
        self.todaynottomo = today;
        self.weeklySchedule = weeklySchedule;
        self.delegate = delegate;
        for view in subviews
        {
            view.removeFromSuperview();
        }
        timer.suspend();
        setup ();
        //gets the weekday based on if it is today or tomorrow
        let date = Util.next(days: todaynottomo ? 0 : 1) as Date;
        //Sunday is 1, Saturday is 7, gets today's weekday count
        let weekday = calendar.component(.weekday, from: date);
        //fetch data from firebase database about the daily schedules.
        if weeklySchedule?.typeOfDay [weekday - 1] == 4
        {
            //creates an image that says enjoy the weekend
            let image = UIImageView (image: UIImage.gifImageWithName("enjoyWeekend"));
            //adds the image to the view to display
            addSubview (image);
            //sets layout constraints
            image.translatesAutoresizingMaskIntoConstraints = false;
            image.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true;
            image.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true;
            image.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true;
            image.heightAnchor.constraint (equalToConstant: 400/812*screenHeight).isActive = true;
        }
        else
        {
            showNoData()
            //loops through all the possible schedules
            for each in self.schedules
            {
                //if the schedule has the same value as the value of the wanted schedule
                if each.value == Int32((weeklySchedule?.typeOfDay [weekday - 1])!)
                {
                    hideNoData()
                    //The things/decorations on top of the actual schedule starts
                    //label that says schedule
                    let labelSchedule = UILabel ()
                    labelSchedule.textAlignment = .center;
                    labelSchedule.font = UIFont (name: "SegoeUI-Bold", size: 16/812.0*screenHeight);
                    labelSchedule.text = "Schedule";
                    labelSchedule.layer.opacity = 0;
                    addSubview (labelSchedule);
                    labelSchedule.translatesAutoresizingMaskIntoConstraints = false;
                    labelSchedule.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true;
                    labelSchedule.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true;
                    labelSchedule.heightAnchor.constraint(equalToConstant: 20/812.0*screenHeight).isActive = true;
                    labelSchedule.topAnchor.constraint (equalTo: self.label.topAnchor, constant: 50.0/812*screenHeight).isActive = true;
                    //make an image for the title on top
                    let image = UIImageView (image: UIImage (named: "Rectangle 1028"));
                    let biggerview = UIView();
                    biggerview.layer.opacity = 0;
                    addSubview (biggerview);
                    //set constraint for the outerview
                    biggerview.translatesAutoresizingMaskIntoConstraints = false;
                    biggerview.trailingAnchor.constraint (equalTo: trailingAnchor).isActive = true;
                    biggerview.leadingAnchor.constraint (equalTo: leadingAnchor).isActive = true;
                    biggerview.heightAnchor.constraint (equalToConstant: 43/812.0*screenHeight).isActive = true;
                    biggerview.topAnchor.constraint (equalTo: labelSchedule.topAnchor, constant: 26/812.0*screenHeight).isActive = true;
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
                    dayLabel.font = UIFont(name: "SegoeUI", size: 16/812.0*screenHeight);
                    dayLabel.textColor = .white;
                    dayLabel.text = "It's " + each.kind;
                    biggerview.addSubview (dayLabel);
                    dayLabel.translatesAutoresizingMaskIntoConstraints = false;
                    dayLabel.centerXAnchor.constraint(equalTo: biggerview.centerXAnchor).isActive = true;
                    dayLabel.centerYAnchor.constraint(equalTo: biggerview.centerYAnchor).isActive = true;
                    //The things/decorations on top of the actual schedule ends
                    
                    //then create a scheduleView with the schedule
                    let currentSchedule = ScheduleView(schedule: each, ADay: (weeklySchedule?.abDay [weekday - 1])!, flipped: (weeklySchedule?.flipOrNot [weekday - 1])!, delegate: (self.delegate)!);
                    //The tag is set to 13 so that you can access this object from anywhere else in the program
                    currentSchedule.tag = 13;
                    
                    //Embeds the scheduleView into another UIView so that the borders are even
                    addSubview (self.tempView);
                    //add currentSchedule to tempView
                    self.tempView.addSubview (currentSchedule)
                    
                    //sets layout constraints for currentSchedule
                    currentSchedule.translatesAutoresizingMaskIntoConstraints = false;
                    currentSchedule.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true;
                    currentSchedule.topAnchor.constraint (equalTo: self.tempView.topAnchor).isActive = true;
                    currentSchedule.bottomAnchor.constraint (equalTo: self.tempView.bottomAnchor).isActive = true;
                    currentSchedule.leadingAnchor.constraint (equalTo: self.tempView.leadingAnchor).isActive = true;
                    currentSchedule.trailingAnchor.constraint (equalTo: self.tempView.trailingAnchor).isActive = true;
                    currentSchedule.spacing = 6/812.0*screenHeight;
                    currentSchedule.backgroundColor = .clear
                    
                    //sets layoutConstraints for tempView
                    self.tempView.translatesAutoresizingMaskIntoConstraints = false;
                    self.tempView.topAnchor.constraint (equalTo: biggerview.bottomAnchor).isActive = true;
                    self.tempView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true;
                    self.tempView.widthAnchor.constraint (equalTo: widthAnchor).isActive = true;
                    self.tempView.heightAnchor.constraint (equalToConstant: 450/812.0*screenHeight).isActive = true;
                    
                    //sets the border opacity to 0
                    self.tempView.layer.opacity = 0;
                    
                    //set scrollview stuff
                    currentSchedule.layoutIfNeeded();
                    if (currentSchedule.frame.height < 450/812.0*screenHeight)
                    {
                        tempView.isScrollEnabled = false;
                    }
                    else
                    {
                        tempView.isScrollEnabled = true;
                        tempView.alwaysBounceVertical = true;
                    }
                    
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
            if todaynottomo
            {
                constructTimer ();
            }
        }
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    private func showNoData ()
    {
        noDataLabel.layer.opacity = 1;
    }
    private func hideNoData ()
    {
        noDataLabel.layer.opacity = 0;
    }
}
