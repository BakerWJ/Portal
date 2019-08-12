//
//  Event+CoreDataProperties.swift
//  TimeStamp
//
//  Created by Jacky He on 2019-08-12.
//  Copyright © 2019 Baker Jackson. All rights reserved.
//
//

import Foundation
import CoreData


extension Event {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Event> {
        return NSFetchRequest<Event>(entityName: "Event")
    }

    @NSManaged public var detail: String
    @NSManaged public var endTime: NSDate
    @NSManaged public var kind: Int32
    @NSManaged public var startTime: NSDate
    @NSManaged public var title: String

}
