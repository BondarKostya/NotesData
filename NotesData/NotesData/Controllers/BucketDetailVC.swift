//
//  BucketDetailVC.swift
//  NotesData
//
//  Created by mini on 10/18/16.
//  Copyright © 2016 bondar.k.dev. All rights reserved.
//

import UIKit

class BucketDetailVC: UIViewController {

    @IBOutlet weak var colorButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var pickerBackgroundView: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    
    var bucket: Bucket?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.changePickerHideState(isHide: true)
        
        if let bucket = self.bucket {
            self.nameTextField.text = bucket.title
            self.colorButton.setTitleColor(bucket.bucketColor(), for: .normal)
            self.colorButton.setTitle(bucket.color, for: .normal)
            self.title = bucket.title
        }else {
            self.nameTextField.text = "New bucket"
            self.colorButton.setTitleColor(UIColor.blue, for: .normal)
            self.colorButton.setTitle("blue", for: .normal)
            self.title = "New bucket"
        }
        

    }


    func changePickerHideState(isHide: Bool) {
        self.pickerBackgroundView.isHidden = isHide
        self.pickerView.isHidden = isHide
    }
    
    @IBAction func saveAction(_ sender: UIButton) {
        CoreDataManager.shared.createNewBucket(buildBucket: { (bucket) -> Bucket in
            bucket.color = "red"
            bucket.title = self.nameTextField.text ?? "Wrong"
            bucket.createdDate = NSDate()
            bucket.modifiedDate = NSDate()
            return bucket
            }, handler: { response in
                print(response)
        })
    }
    
    @IBAction func chooseColor(_ sender: UIButton) {
        self.changePickerHideState(isHide: false)
    }
}

extension BucketDetailVC : UIPickerViewDelegate, UIPickerViewDataSource {
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 10
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.colorButton.setTitleColor(self.color(withComponent: component), for: .normal)
        self.changePickerHideState(isHide: true)
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.color(withComponent: component).description
    }
    
    func color(withComponent component: Int) -> UIColor {
        switch component {
        case 0:
            return UIColor.red
        case 1:
            return UIColor.green
        case 2:
            return UIColor.blue
        case 3:
            return UIColor.yellow
        case 4:
            return UIColor.purple
        case 5:
            return UIColor.brown
        case 6:
            return UIColor.darkGray
        case 7:
            return UIColor.black
        case 8:
            return UIColor.cyan
        case 9:
            return UIColor.orange
        default :
            return UIColor.black
        }
    }
}
