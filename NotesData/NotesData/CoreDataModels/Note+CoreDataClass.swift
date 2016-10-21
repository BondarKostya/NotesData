//
//  Note+CoreDataClass.swift
//  NotesData
//
//  Created by mini on 10/18/16.
//  Copyright © 2016 bondar.k.dev. All rights reserved.
//

import Foundation
import CoreData


public class Note: NSManagedObject {

    func bucketsAttributeString() -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString()
        
        for bucket in self.buckets as! Set<Bucket> {
            attributedString.append(bucket.attributedString())
            attributedString.append(NSAttributedString(string: " "))
        }
        
        return attributedString
    }
}
