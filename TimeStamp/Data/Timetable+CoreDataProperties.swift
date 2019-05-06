//
//  Timetable+CoreDataProperties.swift
//  TimeStamp
//
//  Created by Jacky He on 2019-05-06.
//  Copyright © 2019 Baker Jackson. All rights reserved.
//
//

import Foundation
import CoreData


extension Timetable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Timetable> {
        return NSFetchRequest<Timetable>(entityName: "Timetable")
    }

    @NSManaged public var classes: [String]
    @NSManaged public var name: String

}
