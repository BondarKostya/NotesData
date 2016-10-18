//
//  NotesVC.swift
//  NotesData
//
//  Created by mini on 10/18/16.
//  Copyright © 2016 bondar.k.dev. All rights reserved.
//

import UIKit

class NotesVC: UIViewController {

    //var notes = [Note]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.loadNotes(withPage: 1, limit: 10)
    }
    
    func loadNotes(withPage page: Int, limit: Int) {
//        CoreDataManager.shared.loadNotes(withPage: page, limit: limit) { (notes, error) in
//            if  error != nil {
//                return
//            }
//            for note in notes {
//                print(note.text)
//            }
//            
//        }
    }



}
