//
//  NotesVC.swift
//  NotesData
//
//  Created by mini on 10/18/16.
//  Copyright © 2016 bondar.k.dev. All rights reserved.
//

import UIKit

class NotesVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var buckets = [Bucket]()
    
    var notesWithoutBucket = [Note]()
    
    var isNeedToReload = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.tableFooterView = UIView()
        self.tableView.estimatedRowHeight = 220.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        self.loadNotes()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.isNeedToReload {
            self.isNeedToReload = false
            self.loadNotes()
        } else {
            self.tableView.reloadData()
        }
    }
    
    func loadNotes() {
        CoreDataManager.shared.loadBuckets { (buckets, error) in
            if error != nil {
                UIAlertController.alert(withTitle: "Error", message: error!.localizedDescription).show(inController: self)
                return
            }
            self.buckets = buckets
            self.tableView.reloadData()
        }

        CoreDataManager.shared.loadNotes(withoutBucket: true) { (notes, error) in
            if error != nil {
                UIAlertController.alert(withTitle: "Error", message: error!.localizedDescription).show(inController: self)
                return
            }
            self.notesWithoutBucket = notes
            self.tableView.reloadData()
        }
    }

    @IBAction func addNewNoteAction(_ sender: UIBarButtonItem) {
        self.isNeedToReload = true
        self.showNoteDetail(withNote: nil)
    }
    
    func showNoteDetail(withNote note: Note?) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let noteDetailVC = storyboard.instantiateViewController(withIdentifier: "NoteDetailVC") as! NoteDetailVC
        
        noteDetailVC.note = note
        
        self.navigationController!.show(noteDetailVC, sender: true)
    }


    @IBAction func editAction(_ sender: AnyObject) {
        self.tableView.setEditing(!self.tableView.isEditing, animated: true)
    }

}

extension NotesVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        //add addition section for notes without buckets
        return self.buckets.count + (self.notesWithoutBucket.isEmpty ? 0 : 1)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            // check if it is last section with Notes without bucket
            if !self.notesWithoutBucket.isEmpty && self.buckets.count == indexPath.section {
                
                let note = self.notesWithoutBucket[indexPath.row]
                
                CoreDataManager.shared.remove(note, handler: { (error) in
                    if error == nil {
                        self.notesWithoutBucket.remove(at: indexPath.row)
                        self.tableView.deleteRows(at: [indexPath], with: .automatic)
                    } else {
                        UIAlertController.alert(withTitle: "Error", message: error!.localizedDescription).show(inController: self)
                    }
                })
                return
            }
            
            let note = self.buckets[indexPath.section].sortedNotes(ascending: true)[indexPath.row]
            
            CoreDataManager.shared.remove(note, handler: { (error) in
                if error == nil {
                    self.tableView.reloadData()
                } else {
                    UIAlertController.alert(withTitle: "Error", message: error!.localizedDescription).show(inController: self)
                }
            })
        }
    }

    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if !self.notesWithoutBucket.isEmpty && self.buckets.count == section {
            return "Without bucket"
        } else {
            return self.buckets[section].title
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !self.notesWithoutBucket.isEmpty && self.buckets.count == section {
            return self.notesWithoutBucket.count
        } else {
            return self.buckets[section].sortedNotes(ascending: true).count
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var note:Note
        if !self.notesWithoutBucket.isEmpty && self.buckets.count == indexPath.section {
            note = self.notesWithoutBucket[indexPath.row]
            self.isNeedToReload = true
            
        }else {
            note = self.buckets[indexPath.section].sortedNotes(ascending: true)[indexPath.row]
        }
        
        self.showNoteDetail(withNote: note)
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteTVC", for: indexPath) as! NoteTVC
        
        var note:Note
        if !self.notesWithoutBucket.isEmpty && self.buckets.count == indexPath.section {
            note = self.notesWithoutBucket[indexPath.row]
        }else {
            note = self.buckets[indexPath.section].sortedNotes(ascending: true)[indexPath.row]
        }
        
        cell.noteTextLabel.text = note.text ?? ""
        cell.bucketsLabel.attributedText = note.bucketsAttributeString()
        cell.setNeedsUpdateConstraints()
        cell.updateConstraintsIfNeeded()
        return cell
    }
}
