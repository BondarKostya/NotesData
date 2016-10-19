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
    //var notes = [Note]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.loadNotes(withPage: 1, limit: 10)
    }
    
    func loadNotes(withPage page: Int, limit: Int) {
        
    }



}

extension NotesVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "asdfasdfsadf"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteTVC", for: indexPath) as! NoteTVC
        
        cell.textView.text = "fasdfasd"
        return cell
    }
}
