//
//  Settings+CoreDataProperties.swift
//  TimeStamp
//
//  Created by Baker Jackson on 2019-05-06.
//  Copyright © 2019 Baker Jackson. All rights reserved.
//
//

import Foundation
import CoreData


extension Settings {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Settings> {
        return NSFetchRequest<Settings>(entityName: "Settings")
    }

    @NSManaged public var generalNotification: Bool
    @NSManaged public var houseNotification: Bool
    @NSManaged public var eventNotifications: Bool
    @NSManaged public var notificationTime: NSDate?
    @NSManaged public var daysBefore: Int16

}
