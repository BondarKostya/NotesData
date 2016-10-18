//
//  BucketsVC.swift
//  NotesData
//
//  Created by mini on 10/18/16.
//  Copyright © 2016 bondar.k.dev. All rights reserved.
//

import UIKit

class BucketsVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var buckets = [Bucket]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadBuckets()
    }
    
    func loadBuckets() {
        
    }

    
    @IBAction func addBucket(_ sender: UIBarButtonItem) {
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

