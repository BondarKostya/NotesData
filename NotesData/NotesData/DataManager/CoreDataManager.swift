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
    
//    func loadNotes(withPage page: Int, limit: Int, handler: @escaping ([Note],Error?) -> Void ) {
//        
//        let notesFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
//        notesFetchRequest.fetchLimit = limit
//        notesFetchRequest.fetchOffset = (page - 1) * limit
//        
//        let asyncRequest = NSAsynchronousFetchRequest(fetchRequest: notesFetchRequest) { (asynchronousFetchResult) in
//            DispatchQueue.main.async {
//                let notes = asynchronousFetchResult.finalResult!.flatMap() { note in
//                    return note as? Note
//                }
//                handler(notes,nil)
//            }
//        }
//        do {
//            try self.context?.execute(asyncRequest)
//        } catch {
//            print(error)
//        }
//    }
//    
//    func createNewNote(withDictionary noteDictionary: [String : AnyObject] , handler: (Bool) -> Void) {
//        var newNote = NSEntityDescription.insertNewObject(forEntityName: "Note", into: self.context!) as! Note
//        newNote = NoteBuilder().buildNote(note: newNote, dictionary: noteDictionary)
//  
//        do {
//            try self.context!.save()
//            handler(true)
//        } catch {
//            handler(false)
//            fatalError("Failure to save context: \(error)")
//        }
//
//    }
    
    //MARK: - Buckets
    
    func loadBuckets(_ handler: @escaping ([Bucket],Error?) -> Void ) {
    
        let bucketsFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Bucket")
    
        let asyncRequest = NSAsynchronousFetchRequest(fetchRequest: bucketsFetchRequest) { (asynchronousFetchResult) in
            DispatchQueue.main.async {
                let notes = asynchronousFetchResult.finalResult!.flatMap() { note in
                    return note as? Bucket
                }
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

        existingBucket.createdDate = NSDate()
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
