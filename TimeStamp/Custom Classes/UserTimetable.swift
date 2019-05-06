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
    var normalToFlip: [Int] = [Int] (repeating: 0, count: 6);
    var flipToNormal: [Int] = [Int] (repeating: 0, count: 6);
    var ADaySchedule: [String] = [String] (repeating: "", count: 6);
    var BDaySchedule: [String] = [String] (repeating: "" , count: 6);
    var ADayTimetable: Timetable?
    var BDayTimetable: Timetable?
    init ()
    {
        let fetchRequest = NSFetchRequest <NSFetchRequestResult> (entityName: "FlipDay");
        let fetchRequest2 = NSFetchRequest <NSFetchRequestResult> (entityName: "Timetable");
        do
        {
            if let results = try CoreDataStack.managedObjectContext.fetch (fetchRequest) as? [FlipDay]
            {
                normalToFlip = results [0].normalToFlip;
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
    
    func update (ADay: Bool, flipped: Bool, classnumber: Int, newValue: String)
    {
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
    
    func query (ADay: Bool, flipped: Bool, classnumber: Int) -> String
    {
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
