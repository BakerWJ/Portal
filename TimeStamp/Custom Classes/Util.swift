//
//  File.swift
//  TimeStamp
//
//  Created by Jacky He on 2019-05-23.
//  Copyright © 2019 Baker Jackson. All rights reserved.
//

import Foundation
import UIKit

//This class is for random static methods that might be commonly used
class Util
{
    //Prints all the available fonts in the system to the console
    static func printFonts ()
    {
        for family: String in UIFont.familyNames
        {
            print("\(family)")
            for names: String in UIFont.fontNames(forFamilyName: family)
            {
                print("== \(names)")
            }
        }
    }
    
    //The function returns the nearest Sunday from now
    static func nextSunday () -> NSDate
    {
        //gets the current user calendar
        let calendar = Calendar.current;
        
        //gets today's date
        var today: Date = Date();
        
        //initialize weekday
        var weekday = -1;
        
        //loop until the weekday variable says 1, which indicates a Sunday
        while (weekday != 1)
        {
            //Adds one day to "today"'s date
            today = calendar.date(byAdding: .day, value: 1, to: today)!
            
            //The week day value is set to the weekday component of the Date Object with name "today"
            weekday = calendar.component (.weekday, from: today);
        }
        
        //Calling start of day makes the Date referring to the midnight of the current date
        today = calendar.startOfDay(for: today);
        
        //returns the value as NSDate because Core Data hates Date
        return today as NSDate
    }
    
}
