//
//  BucketTVC.swift
//  NotesData
//
//  Created by mini on 10/18/16.
//  Copyright © 2016 bondar.k.dev. All rights reserved.
//

import UIKit

class BucketTVC: UITableViewCell {

    @IBOutlet weak var bucketNameLabel: UILabel!
    @IBOutlet weak var bucketColorView: UIView!
    
    func setupView(withBucket bucket: Bucket) {
        self.bucketNameLabel.text = bucket.title ?? ""
        self.bucketColorView.backgroundColor = bucket.bucketColor()
    }
}
