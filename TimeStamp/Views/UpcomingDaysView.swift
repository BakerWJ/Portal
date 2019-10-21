//
//  UpcomingDaysView.swift
//  TimeStamp
//
//  Created by Catherine He on 2019-07-26.
//  Copyright © 2019 Baker Jackson. All rights reserved.
//

import UIKit

class UpcomingDaysView: UIStackView
{
    override init(frame: CGRect) {
        super.init (frame: frame);
    }
    
    required init(coder: NSCoder) {
        super.init (coder: coder)
    }
    
    init (numDays: Int, delegate: MainPageViewController)
    {
        super.init (frame: CGRect());
        self.numDays = numDays
        self.delegate = delegate;
        setup()
        refresh()
    }
    
    let screenWidth = UIScreen.main.bounds.width;
    let screenHeight = UIScreen.main.bounds.height;
    
    var numDays: Int = 4;
    weak var delegate: MainPageViewController?
    
    //model
    
    private func setup ()
    {
        axis = .horizontal;
        distribution = .fillEqually
        spacing = 21/375.0*screenWidth;
        isUserInteractionEnabled = true;
        
        for _ in 1...numDays
        {
            let dayView = UpcomingDayView()
            dayView.delegate = self.delegate
            addArrangedSubview(dayView);
            dayView.translatesAutoresizingMaskIntoConstraints = false;
        }
    }
    
    func refresh ()
    {
        var daysDisplayed = [Date?]()
        var abdayDisplayed = [Int?]()
        var typeOfDayDisplayed = [String?]()
        
        guard let schedules = UserDataSettings.fetchAllSchedules(),
            let weeklySchedule = UserDataSettings.fetchWeeklySchedule()
            else {return;}
        
        for x in 1...numDays
        {
            let currDay = Util.next(days: x) as Date
            let weekday = Calendar.current.component(.weekday, from: currDay);
            daysDisplayed.append (currDay);
            var found = false;
            for schedule in schedules
            {
                if (schedule.value == weeklySchedule.typeOfDay [weekday - 1])
                {
                    if (schedule.value == 4)
                    {
                        abdayDisplayed.append (-1);
                    }
                    else
                    {
                        abdayDisplayed.append (weeklySchedule.abDay [weekday - 1] ? 1 : 0);
                    }
                    typeOfDayDisplayed.append (schedule.kind);
                    found = true;
                    break;
                }
            }
            if (!found)
            {
                abdayDisplayed.append (nil);
                typeOfDayDisplayed.append (nil);
            }
        }
        
        var idx = 0;
        for subview in arrangedSubviews
        {
            let subview = subview as! UpcomingDayView
            subview.refresh(day: daysDisplayed [idx], abday: abdayDisplayed [idx], typeOfDay: typeOfDayDisplayed [idx])
            idx += 1;
        }
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}


class UpcomingDayView: UIView
{
    override init(frame: CGRect) {
        super.init (frame: frame);
        setup ()
    }
    required init?(coder: NSCoder) {
        super.init (coder: coder);
    }
    
    //screen height and width
    let screenHeight = UIScreen.main.bounds.height
    let screenWidth = UIScreen.main.bounds.width
    
    let formatter = DateFormatter ()
    weak var delegate: MainPageViewController?
    
    var date = Date();
    
    //view with border
    lazy var outlineView: UIView = {
        let view = UIView();
        view.layer.cornerRadius = 15/375.0*screenWidth;
        view.layer.borderColor = UIColor.black.cgColor;
        view.backgroundColor = .clear;
        view.layer.borderWidth = 1;
        return view;
    }()
    
    lazy var weekDayLabel: UILabel = {
        let label = UILabel ()
        label.backgroundColor = .clear;
        label.font = UIFont (name: "SitkaBanner", size: 18/375.0*screenWidth);
        label.textAlignment = .left;
        label.textColor = .black;
        label.adjustsFontSizeToFitWidth = true;
        label.numberOfLines = 1;
        label.baselineAdjustment = .alignCenters;
        return label;
    }()
    
    lazy var ABDayLabel : UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear;
        label.font = UIFont (name: "SitkaBanner-Bold", size: 14/375.0*screenWidth);
        label.textAlignment = .left;
        label.textColor = .black;
        label.adjustsFontSizeToFitWidth = true;
        label.numberOfLines = 1;
        label.baselineAdjustment = .alignCenters;
        return label;
    }()
    
    lazy var typeOfDayLabel: UILabel = {
        let label = UILabel ()
        label.backgroundColor = .clear;
        label.font = UIFont (name: "SitkaBanner", size: 14/375.0*screenWidth);
        label.textAlignment = .center;
        label.textColor = .black;
        label.adjustsFontSizeToFitWidth = true;
        label.numberOfLines = 0;
        label.baselineAdjustment = .alignCenters;
        return label;
    }()
    
    private func setup ()
    {
        addSubview(outlineView);
        addConstraintsWithFormat("H:|[v0]|", views: outlineView);
        addConstraintsWithFormat("V:|[v0]|", views: outlineView);
        
        outlineView.addSubview(weekDayLabel);
        weekDayLabel.translatesAutoresizingMaskIntoConstraints = false;
        weekDayLabel.leadingAnchor.constraint (equalTo: outlineView.leadingAnchor, constant: 13/375.0*screenWidth).isActive = true;
        weekDayLabel.trailingAnchor.constraint (equalTo: outlineView.trailingAnchor, constant: -13/375.0*screenWidth).isActive = true;
        weekDayLabel.heightAnchor.constraint(equalToConstant: 20/812.0*screenHeight).isActive = true;
        weekDayLabel.topAnchor.constraint (equalTo: outlineView.topAnchor, constant: 14/812.0*screenHeight).isActive = true;
        
        outlineView.addSubview(ABDayLabel);
        ABDayLabel.translatesAutoresizingMaskIntoConstraints = false;
        ABDayLabel.leadingAnchor.constraint (equalTo: weekDayLabel.leadingAnchor).isActive = true;
        ABDayLabel.trailingAnchor.constraint (equalTo: weekDayLabel.trailingAnchor).isActive = true;
        ABDayLabel.heightAnchor.constraint (equalToConstant: 20/812.0*screenHeight).isActive = true;
        ABDayLabel.topAnchor.constraint (equalTo: weekDayLabel.bottomAnchor).isActive = true;
        
        outlineView.addSubview(typeOfDayLabel);
        outlineView.addConstraintsWithFormat("H:|[v0]|", views: typeOfDayLabel);
        outlineView.addConstraintsWithFormat("V:|[v0]|", views: typeOfDayLabel);
        
        //add a gesture recognizer to this to detect a tap
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector (tapped));
        addGestureRecognizer(gestureRecognizer);
        isUserInteractionEnabled = true;
    }
    
    func refresh (day: Date?, abday: Int?, typeOfDay: String?) //abday: -1 means special
    {
        //unwrap the optionals
        guard let day = day,
        let abday = abday,
        let typeOfDay = typeOfDay
            else {return}
        date = day;
        formatter.dateFormat = "EEE.";
        weekDayLabel.text = formatter.string(from: day);
        ABDayLabel.text = "";
        if (abday == 1)
        {
            ABDayLabel.text = "A Day";
        }
        else if (abday == 0)
        {
            ABDayLabel.text = "B Day";
        }
        typeOfDayLabel.text = typeOfDay;
    }
    
    @objc func tapped ()
    {
        delegate?.goCheckDay(date: date)
    }
}
