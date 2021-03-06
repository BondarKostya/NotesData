//
//  NoteDetailVC.swift
//  NotesData
//
//  Created by mini on 10/18/16.
//  Copyright © 2016 bondar.k.dev. All rights reserved.
//

import UIKit

class NoteDetailVC: UIViewController {

    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var bucketsLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var dictateButton: UIButton!
    
    var dictatedString = ""
    
    var existingString = ""
    
    var speechRecognizer = SpeechRecognizer()
    
    var note: Note?
    
    var buckets = Set<Bucket>()

    var isNew = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.speechRecognizer.authorizeSpeechRecognition()
        self.speechRecognizer.delegate = self
        self.dictateButton.isEnabled = false
        
        self.noteTextView.delegate = self
        
        if let note = note {
            self.isNew = false
            noteTextView.text = note.text ?? ""
            self.buckets = note.buckets as! Set<Bucket>
            
        } else {
            noteTextView.text = ""
        }
        
    }
    
    @IBAction func dictateButtonAction(_ sender: AnyObject) {
        if self.speechRecognizer.authorizedStatus  == .authorized {
            if self.speechRecognizer.isStart {
                self.speechRecognizer.stopRecognize()
            } else {
                self.view.endEditing(true)
                self.existingString = self.noteTextView.text!
                self.dictatedString = ""
                self.speechRecognizer.startRecognize()
            }
        } else {
            UIAlertController.alert(withTitle: "Error", message: self.speechRecognizer.authorizedStatus.description()).show(inController: self)
        }
            
        
    }
    
    func setupBucketsLabel() {
        if let note = self.note {
            bucketsLabel.attributedText = note.bucketsAttributeString()
            
        } else {
            let attributedString = NSMutableAttributedString()
            
            if self.buckets.count == 0 {
                bucketsLabel.text = "Press Edit to add Bucket "
                return
            }
            
            for (index, bucket) in self.buckets.enumerated() {
                attributedString.append(bucket.attributedString())
                if index % 2 == 0 {
                    attributedString.append(NSAttributedString(string: "\n"))
                }else {
                    attributedString.append(NSAttributedString(string: " "))
                }
                
            }
            bucketsLabel.attributedText = attributedString
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setupBucketsLabel()
    }
    
    @IBAction func saveAction(_ sender: UIButton) {
        
        if self.noteTextView.text.isEmpty {
            UIAlertController.alert(withTitle: "", message: "Please, input note text").show(inController: self)
        }
        
        self.saveButton.isEnabled = false
        
        if isNew {
            CoreDataManager.shared.createNewNote(buildNote: { (note) in
                note.text = self.noteTextView.text!
                note.buckets = self.buckets as NSSet!
            }, handler: { (error) in
                if error != nil {
                    UIAlertController.alert(withTitle: "Error", message: error!.localizedDescription).show(inController: self)
                    self.saveButton.isEnabled = true
                }
                self.navigationController!.popViewController(animated: true)
           })
        } else {
            CoreDataManager.shared.update(self.note!, updateNote: { (note) in
                note.text = self.noteTextView.text!
                note.buckets = self.note!.buckets
            }, handler: { (error) in
                if error != nil {
                    UIAlertController.alert(withTitle: "Error", message: error!.localizedDescription).show(inController: self)
                    self.saveButton.isEnabled = true
                }
                self.navigationController!.popViewController(animated: true)
            })
        }
        
    }
    @IBAction func editBucketsAction(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let bucketSelectionVC = storyboard.instantiateViewController(withIdentifier: "BucketSelectionVC") as! BucketSelectionVC
        
        bucketSelectionVC.selectedBuckets = self.buckets
        
        bucketSelectionVC.selectedBucketsCallback = { (buckets) in
            
            if self.isNew {
                self.buckets = buckets
            }else {
                self.note!.buckets = buckets as NSSet
            }
            
        }
        self.navigationController!.show(bucketSelectionVC, sender: self)
    }


}

extension NoteDetailVC : UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.speechRecognizer.stopRecognize()
    }
}

extension NoteDetailVC : SpeechRecognitionDelegate {
    
    func handle(_ error: Error) {
        UIAlertController.alert(withTitle: "Error", message: error.localizedDescription).show(inController: self)
    }
    
    func speechRecognized(_ text: String, error: Error?, isFinalText: Bool) {
        self.dictatedString = text
        
        if isFinalText {
            self.existingString = "\(self.existingString) \(self.dictatedString)"
            self.dictatedString = ""
            self.noteTextView.text = self.existingString
        } else {
            self.noteTextView!.text = "\(self.existingString) \(self.dictatedString)"
        }

    }
    
    func recognizerStartListen() {
        self.dictateButton.setTitle("Stop", for: .normal)
    }
    
    func recognizerStopListen() {
        self.dictateButton.setTitle("Dictate", for: .normal)
    }
    
    func authorizationResponse(_ status: SpeechRecognizer.SpeechRecognizerAuthorizationStatus) {
        switch status {
        case .authorized:
            self.dictateButton.setTitle("Dictate", for: .normal)
            self.dictateButton.isEnabled = true
        default:
            self.dictateButton.setTitle("Not Allowed", for: .normal)
            self.dictateButton.isEnabled = false
            
        }
    }
    
    func speechReconizer(availabilityDidChange available: Bool) {
        if !available {
            self.dictateButton.setTitle("Not available", for: .normal)
            self.dictateButton.isEnabled = false
        }
    }
}
