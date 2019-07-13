//
//  ToDo_Task+CoreDataProperties.swift
//  TimeStamp
//
//  Created by Jacky He on 2019-07-11.
//  Copyright © 2019 Baker Jackson. All rights reserved.
//
//

import Foundation
import CoreData


extension ToDo_Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDo_Task> {
        return NSFetchRequest<ToDo_Task>(entityName: "ToDo_Task")
    }

    @NSManaged public var title: String
    @NSManaged public var detail: String?
    @NSManaged public var dueDate: NSDate?
    @NSManaged public var completed: Bool
    @NSManaged public var tag: ToDo_TaskTag

}
