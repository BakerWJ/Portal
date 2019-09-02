//
//  NextPeriodView.swift
//  TimeStamp
//
//  Created by Catherine He on 2019-07-26.
//  Copyright © 2019 Baker Jackson. All rights reserved.
//

import UIKit

class NextPeriodView: UIView {
    
    override init(frame: CGRect) {
        super.init (frame: frame);
        setup ()
    }
    required init?(coder: NSCoder) {
        super.init (coder: coder);
    }
    
    let screenWidth = UIScreen.main.bounds.width;
    let screenHeight = UIScreen.main.bounds.height;
    let formatter = DateFormatter ()
    let calendar = Calendar.current;
    
    //this shows what the next class is
    lazy var nextClassLabel: UILabel = {
        let label = UILabel();
        label.backgroundColor = .clear;
        label.textAlignment = .left;
        label.baselineAdjustment = .alignCenters;
        label.numberOfLines = 2;
        label.textColor = .black
        label.adjustsFontSizeToFitWidth = true;
        return label
    }()
    
    //this shows when the next class is
    lazy var nextClassTimeLabel: UILabel = {
        let label = UILabel();
        label.backgroundColor = .clear;
        label.textAlignment = .left;
        label.textColor = .black
        label.baselineAdjustment = .alignBaselines;
        return label;
    }()
    
    private func setup ()
    {
        backgroundColor = .clear
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1;
        
        addSubview(nextClassLabel);
        nextClassLabel.translatesAutoresizingMaskIntoConstraints = false;
        nextClassLabel.leadingAnchor.constraint (equalTo: leadingAnchor, constant: 20.54/375.0*screenWidth).isActive = true;
        nextClassLabel.centerYAnchor.constraint (equalTo: centerYAnchor).isActive = true;
        nextClassLabel.widthAnchor.constraint (equalToConstant: 138/375.0*screenWidth).isActive = true;
        nextClassLabel.heightAnchor.constraint (equalTo: heightAnchor).isActive = true;
        
        addSubview(nextClassTimeLabel);
        nextClassTimeLabel.translatesAutoresizingMaskIntoConstraints = false;
        nextClassTimeLabel.trailingAnchor.constraint (equalTo: trailingAnchor, constant: -20.54/375.0*screenWidth).isActive = true;
        nextClassTimeLabel.heightAnchor.constraint (equalTo: heightAnchor).isActive = true;
        nextClassTimeLabel.centerYAnchor.constraint (equalTo: centerYAnchor).isActive = true;
        nextClassTimeLabel.widthAnchor.constraint (equalToConstant: 138.35/375.0*screenWidth).isActive = true;
    }
    func refresh ()
    {
        var text = NSMutableAttributedString()
        var time = NSMutableAttributedString()
        //if today there is a next period
        if let nextPeriod = getNextPeriod()
        {
            text = NSMutableAttributedString(string: nextPeriod.0 + "\n", attributes: [.font : UIFont(name: "SitkaBanner-Bold", size: 20/375.0*screenWidth) ?? UIFont.systemFont(ofSize: 20/375.0*screenWidth, weight: .bold)])
            text.append(NSMutableAttributedString(string: "is next. Starts at...", attributes: [.font : UIFont (name: "SitkaBanner", size: 14/375.0*screenWidth) ?? UIFont.systemFont(ofSize: 14/375.0*screenWidth)]))
            
            formatter.dateFormat = "hh:mm";
            time = NSMutableAttributedString(string: formatter.string(from: nextPeriod.1), attributes: [.font: UIFont (name: "SimSun", size: 40/375.0*screenWidth) ?? UIFont.systemFont(ofSize: 40/375.0*screenWidth)]);
            formatter.dateFormat = "a";
            time.append (NSMutableAttributedString(string: " " + formatter.string (from: nextPeriod.1).uppercased(), attributes: [.font: UIFont(name: "SitkaBanner", size: 14/375.0*screenWidth) ?? UIFont.systemFont(ofSize: 14/375.0*screenWidth)]))
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
            time = NSMutableAttributedString(string: formatter.string(from: nextSchoolDay.0), attributes: [.font: UIFont (name: "SimSun", size: 40/375.0*screenWidth) ?? UIFont.systemFont(ofSize: 40/375.0*screenWidth)]);
            formatter.dateFormat = "a";
            time.append (NSMutableAttributedString(string: " " + formatter.string (from: nextSchoolDay.0).uppercased(), attributes: [.font: UIFont(name: "SitkaBanner", size: 14/375.0*screenWidth) ?? UIFont.systemFont(ofSize: 14/375.0*screenWidth)]))
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
                            if let periods = schedule.periods
                            {
                                for period in periods
                                {
                                    if let period = period as? Period
                                    {
                                        return (period.startTime as Date, day as Date);
                                    }
                                }
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
            let today = Util.next(days: 0) as Date;
            let weekday = calendar.component(.weekday, from: today);
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
                            let startTime = period.startTime as Date
                            let now = Date()
                            let interval1 = startTime.timeIntervalSince1970 - calendar.startOfDay(for: startTime).timeIntervalSince1970
                            let interval2 = now.timeIntervalSince1970 - calendar.startOfDay(for: now).timeIntervalSince1970
                            //if the start time is later than the time now.
                            if interval1 > interval2
                            {
                                //finds what the name of this period should be after accounting for flipped day, a day, or irregular days as well as what the user inputed
                                if Int(period.correspond) == 0
                                {
                                    return (period.periodName, period.startTime as Date);
                                }
                                var userInput = "";
                                if (period.additionalNotes == "A")
                                {
                                    userInput = UserTimetable.query (ADay: true, flipped: flipped, classnumber: Int (period.correspond));
                                }
                                else if (period.additionalNotes == "B")
                                {
                                    userInput = UserTimetable.query (ADay: false, flipped: flipped, classnumber: Int (period.correspond));
                                }
                                else
                                {
                                    userInput = UserTimetable.query (ADay: ADay, flipped: flipped, classnumber: Int(period.correspond))
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
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
