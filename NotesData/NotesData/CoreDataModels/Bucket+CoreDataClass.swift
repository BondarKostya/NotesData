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

    
    func attributedString() -> NSMutableAttributedString {
        return NSMutableAttributedString(string: self.title ?? "", attributes: [NSBackgroundColorAttributeName : self.bucketColor(), NSForegroundColorAttributeName : UIColor.white])
    }
    
    func bucketColor() -> UIColor {
        return UIColor.color(string: self.color ?? "")
    }
    
    func setColorString(withColor color: UIColor) {
        self.color = color.colorName()
    }

}
