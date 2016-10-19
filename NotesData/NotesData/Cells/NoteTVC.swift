//
//  NoteTVC.swift
//  NotesData
//
//  Created by mini on 10/19/16.
//  Copyright © 2016 bondar.k.dev. All rights reserved.
//

import UIKit

class NoteTVC: UITableViewCell {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var bucketCollectionView: UICollectionView!

    override func awakeFromNib() {
        bucketCollectionView.delegate = self
        bucketCollectionView.dataSource = self
    }
}

extension NoteTVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BucketCVC", for: indexPath) as! BucketCVC
        
        cell.bucketLabel.text = "asf"
        cell.backgroundColor = UIColor.purple
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
}
