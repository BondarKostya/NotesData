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

    func bucketColor() -> UIColor {
        switch self.color ?? "" {
        case "red" :
            return UIColor.red
        case "green" :
            return UIColor.green
        case "blue" :
            return UIColor.blue
        case "yellow" :
            return UIColor.yellow
        case "purple" :
            return UIColor.purple
        case "brown" :
            return UIColor.brown
        case "darkGray" :
            return UIColor.darkGray
        case "black" :
            return UIColor.black
        case "cyan" :
            return UIColor.cyan
        case "orange" :
            return UIColor.orange
        default :
            return UIColor.black
        }
    }
    
    func setColorString(withColor color: UIColor) {
        switch color {
        case UIColor.red :
            self.color = "red"
        case UIColor.green :
            self.color = "green"
        case UIColor.blue :
            self.color = "blue"
        case UIColor.yellow :
            self.color = "yellow"
        case UIColor.purple :
            self.color = "purple"
        case UIColor.brown :
            self.color = "brown"
        case UIColor.darkGray :
            self.color = "darkGray"
        case UIColor.black :
            self.color = "black"
        case UIColor.cyan :
            self.color = "cyan"
        case UIColor.orange :
            self.color = "orange"
        default :
            self.color = "black"
        }
        
    }

}
