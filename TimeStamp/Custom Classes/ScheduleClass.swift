//
//  ScheduleClass.swift
//  UTS APP
//
//  Created by Jacky He on 2019-04-20.
//  Copyright © 2019 Jacky He. All rights reserved.
//

import UIKit

//The ScheduleView displays a schedule and extends UIStackView
//Note: UIStackView is not the same as UIView so UIStackView.layer might not work as expected
class ScheduleView: UIStackView
{
    //MARK: Properties
    var periodNames: [String] = [String] ()
    var startTimes: [Date] = [Date] ()
    var endTimes: [Date] = [Date] ()
    var additionalNotes: [String] = [String] ()
    var corresponds: [Int] = [Int] ()
    var ADay = false;
    var flipped = false;
    let changeTimetable = UserTimetable ()
    var delegate: KeyboardShiftingDelegate?
    
    //MARK: Constructors
    
    //This Constructor takes in a Schedule Object and creates a ScheduleView
    init (schedule: Schedule, ADay: Bool, flipped: Bool, delegate: KeyboardShiftingDelegate)
    {
        //Loops through every Period objects in the Schedule Object to get their properties and inserts them into appropriate arrays
        for period in schedule.periods!
        {
            if let period = period as? Period
            {
                if Int(period.correspond) == 0
                {
                    periodNames.append(period.periodName);
                }
                else
                {
                    let userInput = changeTimetable.query (ADay: ADay, flipped: flipped, classnumber: Int(period.correspond))
                    if userInput == ""
                    {
                        periodNames.append(period.periodName)
                    }
                    else
                    {
                        periodNames.append(userInput);
                    }
                }
                startTimes.append (period.startTime as Date)
                endTimes.append (period.endTime as Date)
                corresponds.append (Int(period.correspond))
                self.additionalNotes.append (period.additionalNotes)
            }
        }
        self.delegate = delegate;
        self.ADay = ADay;
        self.flipped = flipped
        //super class function
        super.init (frame: CGRect())
        //Performs some setup
        setup ()
    }
    
    //Another way of initializing the ScheduleView is just directly passing in the necessary arrays
    init (periodNames: [String], startTimes: [Date], endTimes: [Date], additionalNotes: [String], corresponds: [Int])
    {
        self.periodNames = periodNames;
        self.startTimes = startTimes;
        self.endTimes = endTimes;
        self.additionalNotes = additionalNotes;
        self.corresponds = corresponds
        super.init (frame: CGRect())
        //Performs some setup
        setup ()
    }
    
    //override super class methods
    override init (frame: CGRect)
    {
        super.init (frame: frame)
    }
    required init (coder: NSCoder)
    {
        super.init (coder: coder)
    }
    
    private func setup ()
    {
        //makes the stack view vertical
        axis = .vertical
        
        //loops through the arrays storing attributes of periods
        for x in 0..<startTimes.count
        {
            //Error checking to avoid ArrayIndexOutOfBound
            if (x < min(min (periodNames.count, endTimes.count), additionalNotes.count))
            {
                
                //Generates a PeriodView
                let period = PeriodView (periodName: periodNames [x], startTime: startTimes [x], endTime: endTimes [x], additionalNotes: additionalNotes [x], ADay: ADay, flipped: flipped, classnumber: corresponds [x])
                period.keyboardDelegate = self.delegate;
                //Adds it to the stackview's subview in order.
                //temp.backgroundColor = UIColor(patternImage: UIImage(named: "Rounded Rectangle")!);
                addArrangedSubview(period)
            }
        }
    }
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementat on adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
}
