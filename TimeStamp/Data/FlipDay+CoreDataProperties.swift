//
//  FlipDay+CoreDataProperties.swift
//  UTS APP
//
//  Created by Jacky He on 2019-04-26.
//  Copyright © 2019 Jacky He. All rights reserved.
//
//

import Foundation
import CoreData


extension FlipDay {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FlipDay> {
        return NSFetchRequest<FlipDay>(entityName: "FlipDay")
    }

    @NSManaged public var normalToFlip: [Int]
    @NSManaged public var expirationDate: NSDate

}
