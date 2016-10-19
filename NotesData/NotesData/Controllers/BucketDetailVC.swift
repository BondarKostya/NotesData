//
//  BucketDetailVC.swift
//  NotesData
//
//  Created by mini on 10/18/16.
//  Copyright © 2016 bondar.k.dev. All rights reserved.
//

import UIKit

class BucketDetailVC: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var colorTextField: UITextField!
    
    var isNew = true
    var pickerView = UIPickerView()
    var colors = [UIColor.red, UIColor.green, UIColor.blue, UIColor.magenta, UIColor.purple, UIColor.brown, UIColor.darkGray, UIColor.black, UIColor.cyan, UIColor.orange]
    
    var bucket: Bucket?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupPickerView()

        if let bucket = self.bucket {
            self.nameTextField.text = bucket.title
            
            self.colorTextField.backgroundColor = bucket.bucketColor()
            self.colorTextField.text = bucket.color
            self.title = bucket.title
            self.pickerView.selectRow(colors.index(of: bucket.bucketColor())!, inComponent: 0, animated: true)
            self.isNew = false
        }else {
            self.nameTextField.text = "New bucket"
            
            self.colorTextField.backgroundColor = colors[0]
            self.colorTextField.text = colors[0].colorName()
            
            self.title = "New bucket"
            self.isNew = true
        }
    }
    
    func setupPickerView() {
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(BucketDetailVC.donePressed(sender:)))
        
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        colorTextField.inputView = pickerView
        colorTextField.inputAccessoryView = toolBar
    }
    
    
    func donePressed(sender: UIBarButtonItem) {
        colorTextField.resignFirstResponder()
    }
    
    @IBAction func saveAction(_ sender: UIButton) {
        if self.nameTextField.text?.isEmpty ?? false  {
            return
        }
        if isNew {
            CoreDataManager.shared.createNewBucket(title: self.nameTextField.text!, buildBucket: { (bucket)  in
                    self.buildBucket(bucket: bucket)
                }, handler: { error in
                    if error == nil {
                        self.navigationController!.popViewController(animated: true)
                    } else {
                         UIAlertController.alert(withTitle: "Error", message: error!.localizedDescription).show(inController: self)
                    }
            })
        } else {
            CoreDataManager.shared.updateBucket(bucket: self.bucket!, updateBucket: { (bucket) in
                    self.buildBucket(bucket: bucket)
                }, handler: { error in
                    if error == nil {
                       self.navigationController!.popViewController(animated: true)
                    } else {
                        UIAlertController.alert(withTitle: "Error", message: error!.localizedDescription).show(inController: self)
                    }
                    
            })
        }
        
    }
    
    func buildBucket(bucket: Bucket) {
        bucket.color = self.colorTextField.text ?? "red"
        bucket.title = self.nameTextField.text ?? "Wrong"
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}

extension BucketDetailVC : UIPickerViewDelegate, UIPickerViewDataSource {
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.colors.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.colorTextField.text = self.colors[row].colorName()
        self.colorTextField.backgroundColor = self.colors[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.colors[row].colorName()
    }
}

extension BucketDetailVC : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
}

extension UIColor {
    static func color(string: String) -> UIColor{
        switch string {
        case "red" :
            return UIColor.red
        case "green" :
            return UIColor.green
        case "blue" :
            return UIColor.blue
        case "magenta" :
            return UIColor.magenta
        case "purple" :
            return UIColor.purple
        case "brown" :
            return UIColor.brown
        case "darkGray" :
            return UIColor.darkGray
        case "black" :
            return UIColor.black
        case "cyan" :
            return UIColor.cyan
        case "orange" :
            return UIColor.orange
        default :
            return UIColor.black
        }
    }
    
    func colorName() -> String {
        switch self {
        case UIColor.red :
            return  "red"
        case UIColor.green :
            return "green"
        case UIColor.blue :
            return "blue"
        case UIColor.magenta :
            return "magenta"
        case UIColor.purple :
            return "purple"
        case UIColor.brown :
            return "brown"
        case UIColor.darkGray :
            return "darkGray"
        case UIColor.black :
            return "black"
        case UIColor.cyan :
            return "cyan"
        case UIColor.orange :
            return "orange"
        default :
            return "black"
        }
    }
}
