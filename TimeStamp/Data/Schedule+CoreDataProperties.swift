//
//  Schedule+CoreDataProperties.swift
//  TimeStamp
//
//  Created by Baker Jackson on 2019-05-06.
//  Copyright © 2019 Baker Jackson. All rights reserved.
//
//

import Foundation
import CoreData


extension Schedule {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Schedule> {
        return NSFetchRequest<Schedule>(entityName: "Schedule")
    }

    @NSManaged public var expirationDate: NSDate
    @NSManaged public var kind: String
    @NSManaged public var value: Int32
    @NSManaged public var periods: Period?

}
