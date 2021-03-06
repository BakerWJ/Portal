//
//  FlipDay+CoreDataProperties.swift
//  TimeStamp
//
//  Created by Jacky He on 2019-05-07.
//  Copyright © 2019 Baker Jackson. All rights reserved.
//
//

import Foundation
import CoreData


extension FlipDay {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FlipDay> {
        return NSFetchRequest<FlipDay>(entityName: "FlipDay")
    }

    @NSManaged public var expirationDate: NSDate
    @NSManaged public var normalToFlip: [Int]

}
