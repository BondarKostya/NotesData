//
//  AlertManager.swift
//  NotesData
//
//  Created by mini on 10/19/16.
//  Copyright © 2016 bondar.k.dev. All rights reserved.
//

import Foundation
import UIKit
extension UIAlertController {
    
    class func alert(withError errorMessage : String, handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertController {
        let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: handler))
        return alert
    }
    
    class func alert(withTitle title: String, message :String, handler: ((UIAlertAction) -> Void)? = nil)  -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: handler))
        return alert
    }
    
    func show(inController: UIViewController) {
        inController.present(self, animated: true, completion: nil)
    }
}
