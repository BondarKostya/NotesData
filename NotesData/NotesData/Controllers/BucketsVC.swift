//
//  BucketsVC.swift
//  NotesData
//
//  Created by mini on 10/18/16.
//  Copyright © 2016 bondar.k.dev. All rights reserved.
//

import UIKit

class BucketsVC: UIViewController {

    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    var needToReload = false
    var buckets = [Bucket]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView()
        self.loadBuckets()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.needToReload {
            self.needToReload = false
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

    
    @IBAction func editAction(_ sender: UIBarButtonItem) {
        self.tableView.setEditing(!self.tableView.isEditing, animated: true)
    }
    
    @IBAction func addBucket(_ sender: UIBarButtonItem) {
        self.needToReload = true
        self.showBucketDetailVC(bucket: nil)
    }
    
    func showBucketDetailVC(bucket: Bucket?) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let bucketDetailVC = storyboard.instantiateViewController(withIdentifier: "BucketDetailVC") as! BucketDetailVC
        
        bucketDetailVC.bucket = bucket
        
        self.navigationController?.show(bucketDetailVC, sender: self)
    }
    
}

extension BucketsVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.buckets.count
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let bucket = self.buckets[indexPath.row]
            
            CoreDataManager.shared.removeBucket(bucket: bucket, handler: { (error) in
                if error == nil {
                    self.buckets.remove(at: self.buckets.index(of: bucket)!)
                    self.tableView.deleteRows(at: [indexPath], with: .automatic)
                } else {
                    UIAlertController.alert(withTitle: "Error", message: error!.localizedDescription).show(inController: self)
                }
            })
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let bucket = buckets[indexPath.row]
        self.showBucketDetailVC(bucket: bucket)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BucketTVC", for: indexPath) as! BucketTVC
        let bucket = buckets[indexPath.row]
        
        cell.setupView(withBucket: bucket)
        return cell
    }
}

