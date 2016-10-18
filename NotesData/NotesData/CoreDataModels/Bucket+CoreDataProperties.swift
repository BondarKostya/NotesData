//
//  Bucket+CoreDataProperties.swift
//  NotesData
//
//  Created by mini on 10/18/16.
//  Copyright © 2016 bondar.k.dev. All rights reserved.
//

import Foundation
import CoreData

extension Bucket {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Bucket> {
        return NSFetchRequest<Bucket>(entityName: "Bucket");
    }

    @NSManaged public var title: String?
    @NSManaged public var createdDate: NSDate?
    @NSManaged public var modifiedDate: NSDate?
    @NSManaged public var notes: NSSet?

}

// MARK: Generated accessors for notes
extension Bucket {

    @objc(addNotesObject:)
    @NSManaged public func addToNotes(_ value: Note)

    @objc(removeNotesObject:)
    @NSManaged public func removeFromNotes(_ value: Note)

    @objc(addNotes:)
    @NSManaged public func addToNotes(_ values: NSSet)

    @objc(removeNotes:)
    @NSManaged public func removeFromNotes(_ values: NSSet)

}
