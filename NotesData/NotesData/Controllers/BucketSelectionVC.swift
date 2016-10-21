//
//  BucketSelectionVC.swift
//  NotesData
//
//  Created by mini on 10/20/16.
//  Copyright © 2016 bondar.k.dev. All rights reserved.
//

import UIKit

class BucketSelectionVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var selectedBucketsCallback : ((Set<Bucket>) -> Void)?
    var selectedBuckets: Set<Bucket>?
    
    var buckets = [Bucket]()
    
    var isNeedToReload = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView()
        self.loadBuckets()
    }
    
    override func viewWillDisappear(_ animated : Bool) {
        super.viewWillDisappear(animated)
        
        if (self.isMovingFromParentViewController){
            guard let selectedBucketsCallback = self.selectedBucketsCallback else {
                return
            }
            selectedBucketsCallback(self.selectedBuckets!)
        }
    }
    
    @IBAction func addNewBucketAction(_ sender: AnyObject) {
        self.isNeedToReload = true

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let bucketDetailVC = storyboard.instantiateViewController(withIdentifier: "BucketDetailVC") as! BucketDetailVC
        
        self.navigationController?.show(bucketDetailVC, sender: self)

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.isNeedToReload {
            self.isNeedToReload = false
            self.loadBuckets()
        } else {
            self.tableView.reloadData()
        }
    }

    func loadBuckets() {
        CoreDataManager.shared.loadBuckets() { (buckets, error) in
            if error != nil {
                UIAlertController.alert(withTitle: "Error", message: error!.localizedDescription).show(inController: self)
                return
            }
            self.buckets = buckets
            self.tableView.reloadData()
        }
    }
}

extension BucketSelectionVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.buckets.count
    }
    
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cellToDeSelect = tableView.cellForRow(at: indexPath)!
        cellToDeSelect.accessoryType = .none
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = tableView.cellForRow(at: indexPath)!
        
        selectedCell.accessoryType = .checkmark
        
        let bucket = buckets[indexPath.row]
        
        if self.selectedBuckets!.contains(bucket) {
            self.selectedBuckets!.remove(bucket)
        }else {
           self.selectedBuckets!.insert(bucket) 
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BucketTVC", for: indexPath) as! BucketTVC
        
        let bucket = buckets[indexPath.row]
        
        cell.setupView(withBucket: bucket)
        
        if (selectedBuckets?.contains(bucket))! {
            cell.accessoryType = .checkmark
        }
        return cell
    }
}
