//
//  Article+CoreDataProperties.swift
//  TimeStamp
//
//  Created by Baker Jackson on 2019-08-25.
//  Copyright © 2019 Baker Jackson. All rights reserved.
//
//

import Foundation
import CoreData
import UIKit


extension Article {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Article> {
        return NSFetchRequest<Article>(entityName: "Article")
    }

    @NSManaged public var img: String
    @NSManaged public var author: String
    @NSManaged public var text: String
    @NSManaged public var title: String
    @NSManaged public var genre: String
    @NSManaged public var likes: Int32
    @NSManaged public var hashVal: String
    @NSManaged public var uploaded: Bool
    @NSManaged public var publication: Int16
    @NSManaged public var timestamp: NSDate
}
