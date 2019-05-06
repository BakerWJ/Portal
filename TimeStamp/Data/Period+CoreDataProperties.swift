//
//  Period+CoreDataProperties.swift
//  UTS APP
//
//  Created by Jacky He on 2019-04-26.
//  Copyright © 2019 Jacky He. All rights reserved.
//
//

import Foundation
import CoreData


extension Period {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Period> {
        return NSFetchRequest<Period>(entityName: "Period")
    }

    @NSManaged public var additionalNotes: String
    @NSManaged public var endTime: NSDate
    @NSManaged public var periodName: String
    @NSManaged public var startTime: NSDate
    @NSManaged public var correspond: Int32
    @NSManaged public var schedule: Schedule?

}
