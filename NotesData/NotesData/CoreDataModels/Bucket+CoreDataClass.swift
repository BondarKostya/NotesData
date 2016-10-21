//
//  Bucket+CoreDataClass.swift
//  NotesData
//
//  Created by mini on 10/18/16.
//  Copyright © 2016 bondar.k.dev. All rights reserved.
//

import Foundation
import CoreData
import UIKit

public class Bucket: NSManagedObject {

    func sortedNotes(ascending: Bool) -> [Note] {
        let sortedArray = (self.notes?.allObjects as! [Note]).sorted(by: {  ascending ? $0.text ?? "" < $1.text ?? "" : $0.text ?? "" > $1.text ?? "" })
        return sortedArray
    }
    
    func attributedString() -> NSMutableAttributedString {
        return NSMutableAttributedString(string: self.title ?? "", attributes: [NSBackgroundColorAttributeName : self.color!, NSForegroundColorAttributeName : UIColor.white])
    }


}
