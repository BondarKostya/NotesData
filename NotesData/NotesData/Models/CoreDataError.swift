//
//  CoreDataError.swift
//  NotesData
//
//  Created by mini on 10/19/16.
//  Copyright © 2016 bondar.k.dev. All rights reserved.
//

import Foundation

extension NSError {
    class func coreDataError(withMessage message: String) -> NSError {
        let userInfo: [NSObject : String] =
        [
                NSLocalizedDescriptionKey as NSObject : message
        ]
        let error = NSError(domain: "", code: 399, userInfo: userInfo)
        
        return error
    }
}
