//
//  Schedule+CoreDataProperties.swift
//  TimeStamp
//
//  Created by Jacky He on 2019-05-07.
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
    @NSManaged public var periods: NSOrderedSet?

}

// MARK: Generated accessors for periods
extension Schedule {

    @objc(insertObject:inPeriodsAtIndex:)
    @NSManaged public func insertIntoPeriods(_ value: Period, at idx: Int)

    @objc(removeObjectFromPeriodsAtIndex:)
    @NSManaged public func removeFromPeriods(at idx: Int)

    @objc(insertPeriods:atIndexes:)
    @NSManaged public func insertIntoPeriods(_ values: [Period], at indexes: NSIndexSet)

    @objc(removePeriodsAtIndexes:)
    @NSManaged public func removeFromPeriods(at indexes: NSIndexSet)

    @objc(replaceObjectInPeriodsAtIndex:withObject:)
    @NSManaged public func replacePeriods(at idx: Int, with value: Period)

    @objc(replacePeriodsAtIndexes:withPeriods:)
    @NSManaged public func replacePeriods(at indexes: NSIndexSet, with values: [Period])

    @objc(addPeriodsObject:)
    @NSManaged public func addToPeriods(_ value: Period)

    @objc(removePeriodsObject:)
    @NSManaged public func removeFromPeriods(_ value: Period)

    @objc(addPeriods:)
    @NSManaged public func addToPeriods(_ values: NSOrderedSet)

    @objc(removePeriods:)
    @NSManaged public func removeFromPeriods(_ values: NSOrderedSet)

}
