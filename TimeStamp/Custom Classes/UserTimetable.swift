//
//  File.swift
//  UTS APP
//
//  Created by Jacky He on 2019-04-25.
//  Copyright © 2019 Jacky He. All rights reserved.
//

import Foundation
import CoreData
class UserTimetable
{
    static var normalToFlip: [Int] = [Int] (repeating: 0, count: 6);
    static var flipToNormal: [Int] = [Int] (repeating: 0, count: 6);
    static var ADaySchedule: [String] = [String] (repeating: "", count: 6);
    static var BDaySchedule: [String] = [String] (repeating: "" , count: 6);
    static var ADayTimetable: Timetable?
    static var BDayTimetable: Timetable?
    
    static private func fetchData ()
    {
        let fetchRequest = NSFetchRequest <NSFetchRequestResult> (entityName: "FlipDay");
        let fetchRequest2 = NSFetchRequest <NSFetchRequestResult> (entityName: "Timetable");
        do
        {
            if let results = try CoreDataStack.managedObjectContext.fetch (fetchRequest) as? [FlipDay]
            {
                if (results.count != 0)
                {
                    normalToFlip = results [0].normalToFlip;
                }
            }
        }
        catch
        {
            fatalError ("There was an error fetching the list of flipdays")
        }
        do
        {
            if let results = try CoreDataStack.managedObjectContext.fetch (fetchRequest2) as? [Timetable]
            {
                for each in results
                {
                    if each.name == "ADay"
                    {
                        ADayTimetable = each
                        ADaySchedule = each.classes
                    }
                    else if each.name == "BDay"
                    {
                        BDayTimetable = each
                        BDaySchedule = each.classes
                    }
                }
            }
        }
        catch
        {
            fatalError ("There was an error fetching the list of timetable")
        }
        for x in 0..<5
        {
            flipToNormal [normalToFlip [x]] = x + 1;
        }
    }
    
    static func update (ADay: Bool, flipped: Bool, classnumber: Int, newValue: String)
    {
        fetchData()
        if (ADay)
        {
            if (flipped)
            {
                ADaySchedule [flipToNormal [classnumber]] = newValue;
            }
            else
            {
                ADaySchedule [classnumber] = newValue;
            }
        }
        else
        {
            if (flipped)
            {
                BDaySchedule [flipToNormal [classnumber]] = newValue;
            }
            else
            {
                BDaySchedule [classnumber] = newValue;
            }
        }
        if let A = ADayTimetable, let B = BDayTimetable
        {
            A.classes = ADaySchedule
            B.classes = BDaySchedule
        }
        CoreDataStack.saveContext()
    }
    
    static func query (ADay: Bool, flipped: Bool, classnumber: Int) -> String
    {
        fetchData()
        if (ADay)
        {
            if (flipped)
            {
                return ADaySchedule [flipToNormal [classnumber]];
            }
            return ADaySchedule [classnumber];
        }
        else
        {
            if (flipped)
            {
                return BDaySchedule [flipToNormal [classnumber]];
            }
            return BDaySchedule [classnumber];
        }
    }
}
