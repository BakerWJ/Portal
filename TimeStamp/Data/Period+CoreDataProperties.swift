//
//  Period+CoreDataProperties.swift
//  TimeStamp
//
//  Created by Jacky He on 2019-05-06.
//  Copyright © 2019 Baker Jackson. All rights reserved.
//
//

import Foundation
import CoreData


extension Period {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Period> {
        return NSFetchRequest<Period>(entityName: "Period")
    }

    @NSManaged public var additionalNotes: String
    @NSManaged public var correspond: Int32
    @NSManaged public var endTime: NSDate
    @NSManaged public var periodName: String
    @NSManaged public var startTime: NSDate
    @NSManaged public var schedule: Schedule?

}
