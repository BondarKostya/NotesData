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
    
    
    //MARK: - Notes
    
    func removeNote(note: Note, handler: (Error?) -> Void) {
        guard let note = try! self.context?.existingObject(with: note.objectID) as? Note  else {
            handler(NSError.generateError(withMessage: "Not found"))
            return
        }
        
        self.context!.delete(note)
        
        do {
            try self.context!.save()
            handler(nil)
        } catch {
            handler(error)
        }
        
    }
    
    func loadNotes(withoutBucket: Bool = false, _ handler: @escaping ([Note],Error?) -> Void ) {
        
        let notesFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
        
        if withoutBucket {
            notesFetchRequest.predicate = NSPredicate(format: " buckets.@count == 0")
        }
        
        let asyncRequest = NSAsynchronousFetchRequest(fetchRequest: notesFetchRequest) { (asynchronousFetchResult) in
            DispatchQueue.main.async {
                let notes = asynchronousFetchResult.finalResult! as! [Note]
                handler(notes,nil)
            }
        }
        do {
            try self.context?.execute(asyncRequest)
        } catch {
            handler([],error)
        }
    }

    func createNewNote(buildNote: (Note) -> Void, handler: (Error?) -> Void)  {
        let newNote = NSEntityDescription.insertNewObject(forEntityName: "Note", into: self.context!) as! Note
        
        buildNote(newNote)
        
        newNote.createdDate = NSDate()
        newNote.accessedDate = NSDate()
        newNote.modifiedDate = NSDate()
  
        do {
            try self.context!.save()
            handler(nil)
        } catch {
            handler(error)
        }

    }
    
    func updateNote(note: Note, updateNote: (Note) -> Void, handler: (Error?) -> Void) {
        
        guard let existingNote = try! self.context?.existingObject(with: note.objectID) as? Note  else {
            self.createNewNote(buildNote: updateNote, handler: handler)
            return
        }
        
        updateNote(existingNote)

        existingNote.modifiedDate = NSDate()
        
        do {
            try self.context!.save()
            handler(nil)
        } catch {
            handler(error)
        }
    }
    
    //MARK: - Buckets
    
    func loadBuckets(_ handler: @escaping ([Bucket],Error?) -> Void ) {
    
        let bucketsFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Bucket")
    
        let asyncRequest = NSAsynchronousFetchRequest(fetchRequest: bucketsFetchRequest) { (asynchronousFetchResult) in
            DispatchQueue.main.async {
                let notes = asynchronousFetchResult.finalResult! as! [Bucket]
                handler(notes,nil)
            }
        }
        do {
            try self.context?.execute(asyncRequest)
        } catch {
            handler([], error)
        }
    }
    
    
    
    func createNewBucket(title: String,buildBucket: (Bucket) -> Void, handler: (Error?) -> Void) {
        let titleCheckRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Bucket")
        titleCheckRequest.predicate = NSPredicate(format: " title == %@", title)
        
        let existingBucket = (try? self.context!.fetch(titleCheckRequest) as! [Bucket]) ?? []
        
        if existingBucket.count > 0 {
            handler(NSError.generateError(withMessage: "Bucket with \"\(title)\" existing"))
            return
        }
        
        let newBucket = NSEntityDescription.insertNewObject(forEntityName: "Bucket", into: self.context!) as! Bucket
        
        buildBucket(newBucket)
        
        newBucket.createdDate = NSDate()
        newBucket.modifiedDate = NSDate()
        
        do {
            try self.context!.save()
            handler(nil)
        } catch {
            handler(error)
        }
    }
    
    func updateBucket(bucket: Bucket, updateBucket: (Bucket) -> Void, handler: (Error?) -> Void) {
        
        guard let existingBucket = try! self.context?.existingObject(with: bucket.objectID) as? Bucket  else {
            self.createNewBucket(title: bucket.title!, buildBucket: updateBucket, handler: handler)
            return
        }
        
        updateBucket(existingBucket)

        existingBucket.modifiedDate = NSDate()
        
        do {
            try self.context!.save()
            handler(nil)
        } catch {
            handler(error)
        }
    }
    
    func removeBucket(bucket: Bucket, handler: (Error?) -> Void) {
        guard let bucket = try! self.context?.existingObject(with: bucket.objectID) as? Bucket  else {
            handler(NSError.generateError(withMessage: "Not found"))
            return
        }
    
        self.context!.delete(bucket)
        
        do {
            try self.context!.save()
            handler(nil)
        } catch {
            handler(error)
        }
        
    }
    
    
    
}
