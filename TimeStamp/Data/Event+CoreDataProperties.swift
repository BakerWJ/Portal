//
//  Event+CoreDataProperties.swift
//  TimeStamp
//
//  Created by Jacky He on 2019-08-13.
//  Copyright © 2019 Baker Jackson. All rights reserved.
//
//

import Foundation
import CoreData


extension Event {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Event> {
        return NSFetchRequest<Event>(entityName: "Event")
    }

    @NSManaged public var titleDetail: String
    @NSManaged public var time: String
    @NSManaged public var date: NSDate
    @NSManaged public var kind: Int32

}
