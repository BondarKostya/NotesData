//
//  CoreDataManager.swift
//  NotesData
//
//  Created by mini on 10/18/16.
//  Copyright © 2016 bondar.k.dev. All rights reserved.
//

import UIKit
import CoreData


class CoreDataManager {
    static let shared = CoreDataManager()
    
    let appDelegate: AppDelegate?
    let context: NSManagedObjectContext?
    
    private init() {
        self.appDelegate = UIApplication.shared.delegate as? AppDelegate
        self.context = appDelegate?.persistentContainer.viewContext
    }
    
    func loadNotes(withPage page: Int, limit: Int, handler: @escaping ([Note],Error?) -> Void ) {
        
        let notesFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
        notesFetchRequest.fetchLimit = limit
        notesFetchRequest.fetchOffset = (page - 1) * limit
        
        let asyncRequest = NSAsynchronousFetchRequest(fetchRequest: notesFetchRequest) { (asynchronousFetchResult) in
            DispatchQueue.main.async {
                let notes = asynchronousFetchResult.finalResult!.flatMap() { note in
                    return note as? Note
                }
                handler(notes,nil)
            }
        }
        do {
            try self.context?.execute(asyncRequest)
        } catch {
            print(error)
        }
    }
    
    func createNewNote(withDictionary noteDictionary: [String : AnyObject] , handler: (Bool) -> Void) {
        var newNote = NSEntityDescription.insertNewObject(forEntityName: "Note", into: self.context!) as! Note
        newNote = NoteBuilder().buildNote(note: newNote, dictionary: noteDictionary)
        
        
        do {
            try self.context!.save()
            handler(true)
        } catch {
            handler(false)
            fatalError("Failure to save context: \(error)")
        }
        
        
    }
    
    
    
}
