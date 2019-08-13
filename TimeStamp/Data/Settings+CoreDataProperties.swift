//
//  Settings+CoreDataProperties.swift
//  TimeStamp
//
//  Created by Jacky He on 2019-08-12.
//  Copyright © 2019 Baker Jackson. All rights reserved.
//
//

import Foundation
import CoreData


extension Settings {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Settings> {
        return NSFetchRequest<Settings>(entityName: "Settings")
    }

    @NSManaged public var articleNotifications: Bool
    @NSManaged public var daysBefore: Int16
    @NSManaged public var surveyNotifications: Bool
    @NSManaged public var firstTimeOpen: Bool
    @NSManaged public var generalNotifications: Bool
    @NSManaged public var houseNotifications: Bool
    @NSManaged public var notificationTime: Int16

}
