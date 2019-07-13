//
//  ToDo_TaskTag+CoreDataProperties.swift
//  TimeStamp
//
//  Created by Jacky He on 2019-07-11.
//  Copyright © 2019 Baker Jackson. All rights reserved.
//
//

import Foundation
import CoreData
import UIKit

extension ToDo_TaskTag {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDo_TaskTag> {
        return NSFetchRequest<ToDo_TaskTag>(entityName: "ToDo_TaskTag")
    }

    @NSManaged public var colour: UIColor
    @NSManaged public var name: String?
    @NSManaged public var tasks: NSOrderedSet?

}

// MARK: Generated accessors for tasks
extension ToDo_TaskTag {

    @objc(insertObject:inTasksAtIndex:)
    @NSManaged public func insertIntoTasks(_ value: ToDo_Task, at idx: Int)

    @objc(removeObjectFromTasksAtIndex:)
    @NSManaged public func removeFromTasks(at idx: Int)

    @objc(insertTasks:atIndexes:)
    @NSManaged public func insertIntoTasks(_ values: [ToDo_Task], at indexes: NSIndexSet)

    @objc(removeTasksAtIndexes:)
    @NSManaged public func removeFromTasks(at indexes: NSIndexSet)

    @objc(replaceObjectInTasksAtIndex:withObject:)
    @NSManaged public func replaceTasks(at idx: Int, with value: ToDo_Task)

    @objc(replaceTasksAtIndexes:withTasks:)
    @NSManaged public func replaceTasks(at indexes: NSIndexSet, with values: [ToDo_Task])

    @objc(addTasksObject:)
    @NSManaged public func addToTasks(_ value: ToDo_Task)

    @objc(removeTasksObject:)
    @NSManaged public func removeFromTasks(_ value: ToDo_Task)

    @objc(addTasks:)
    @NSManaged public func addToTasks(_ values: NSOrderedSet)

    @objc(removeTasks:)
    @NSManaged public func removeFromTasks(_ values: NSOrderedSet)

}
