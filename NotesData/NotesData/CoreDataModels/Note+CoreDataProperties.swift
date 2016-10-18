//
//  Note+CoreDataProperties.swift
//  NotesData
//
//  Created by mini on 10/18/16.
//  Copyright © 2016 bondar.k.dev. All rights reserved.
//

import Foundation
import CoreData

extension Note {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note");
    }

    @NSManaged public var text: String?
    @NSManaged public var createdDate: NSDate?
    @NSManaged public var accessedDate: NSDate?
    @NSManaged public var modifiedDate: NSDate?
    @NSManaged public var buckets: NSSet?

}

// MARK: Generated accessors for buckets
extension Note {

    @objc(addBucketsObject:)
    @NSManaged public func addToBuckets(_ value: Bucket)

    @objc(removeBucketsObject:)
    @NSManaged public func removeFromBuckets(_ value: Bucket)

    @objc(addBuckets:)
    @NSManaged public func addToBuckets(_ values: NSSet)

    @objc(removeBuckets:)
    @NSManaged public func removeFromBuckets(_ values: NSSet)

}
