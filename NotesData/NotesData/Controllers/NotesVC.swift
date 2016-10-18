//
//  NotesVC.swift
//  NotesData
//
//  Created by mini on 10/18/16.
//  Copyright © 2016 bondar.k.dev. All rights reserved.
//

import UIKit

class NotesVC: UIViewController {

    var notes = [Note]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.loadNotes(withPage: 1, limit: 10)

//        let dict1 = ["text" : "fsadfasdf"]
//        let dict2 = ["text" : "adads11111s"]
//        
//        CoreDataManager.shared.createNewNote(withDictionary: dict2 as [String : AnyObject]) { (response) in
//            print(response)
//
//        }
        
//        CoreDataManager.shared.createNewNote(withDictionary: dict2 as [String : AnyObject]) { (response) in
//            print(response)
//        }
        // Do any additional setup after loading the view.
    }
    
    func loadNotes(withPage page: Int, limit: Int) {
        CoreDataManager.shared.loadNotes(withPage: page, limit: limit) { (notes, error) in
            if  error != nil {
                return
            }
            for note in notes {
                print(note.text)
            }
            
        }
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
