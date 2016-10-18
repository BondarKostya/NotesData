//
//  NoteBuilder.swift
//  NotesData
//
//  Created by mini on 10/18/16.
//  Copyright © 2016 bondar.k.dev. All rights reserved.
//

import Foundation

public struct NoteBuilder {
    func buildNote(note: Note! ,dictionary: [String : AnyObject]) -> Note {
        
        note.text = dictionary["text"] as? String ?? ""
        note.createdDate = dictionary["createdDate"] as? NSDate ?? NSDate()
        note.accessedDate = dictionary["accessedDate"] as? NSDate ?? NSDate()
        note.modifiedDate = dictionary["modifiedDate"] as? NSDate ?? NSDate()

        return note
    }
}
