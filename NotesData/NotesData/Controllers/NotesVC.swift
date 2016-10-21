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
    var needToReload = false
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.tableFooterView = UIView()
        self.tableView.estimatedRowHeight = 220.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.loadNotes()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.needToReload {
            self.needToReload = false
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
    }

    @IBAction func addNewNoteAction(_ sender: UIBarButtonItem) {
        self.needToReload = true
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
        return self.buckets.count
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let note = self.buckets[indexPath.section].notes!.allObjects[indexPath.row] as! Note
            
            CoreDataManager.shared.removeNote(note: note, handler: { (error) in
                if error == nil {
                    self.buckets[indexPath.section].removeFromNotes(note)
                    self.tableView.deleteRows(at: [indexPath], with: .automatic)
                } else {
                    UIAlertController.alert(withTitle: "Error", message: error!.localizedDescription).show(inController: self)
                }
            })
        }
    }

    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.buckets[section].title
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.buckets[section].notes!.allObjects.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let note = self.buckets[indexPath.section].notes!.allObjects[indexPath.row] as! Note
        
        self.showNoteDetail(withNote: note)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteTVC", for: indexPath) as! NoteTVC
        
        let note = self.buckets[indexPath.section].notes!.allObjects[indexPath.row] as! Note
        
        cell.noteTextLabel.text = note.text ?? ""
        cell.bucketsLabel.attributedText = note.bucketsAttributeString()
        cell.setNeedsUpdateConstraints()
        cell.updateConstraintsIfNeeded()
        return cell
    }
}
