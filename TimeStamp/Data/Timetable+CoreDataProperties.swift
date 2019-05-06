//
//  Timetable+CoreDataProperties.swift
//  UTS APP
//
//  Created by Jacky He on 2019-04-26.
//  Copyright © 2019 Jacky He. All rights reserved.
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
