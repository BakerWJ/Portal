//
//  WeeklySchedule+CoreDataProperties.swift
//  TimeStamp
//
//  Created by Jacky He on 2019-05-07.
//  Copyright © 2019 Baker Jackson. All rights reserved.
//
//

import Foundation
import CoreData


extension WeeklySchedule {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WeeklySchedule> {
        return NSFetchRequest<WeeklySchedule>(entityName: "WeeklySchedule")
    }

    @NSManaged public var abDay: [Bool]
    @NSManaged public var flipOrNot: [Bool]
    @NSManaged public var typeOfDay: [Int]

}
