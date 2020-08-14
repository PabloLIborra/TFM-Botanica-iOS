//
//  CustomReportAlertViewController.swift
//  TFM-Botanica
//
//  Created by Pablo López Iborra on 13/08/2020.
//  Copyright © 2020 Pablo López Iborra. All rights reserved.
//

import UIKit

class CustomReportAlertViewController: UIViewController {

    @IBOutlet weak var alertBox: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var reportText: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    
    var nameController: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.alertBox?.layer.backgroundColor = UIColor.barColor.cgColor
        self.alertBox?.layer.borderColor = UIColor.black.cgColor
        self.alertBox?.layer.borderWidth = 1
        self.alertBox?.layer.cornerRadius = 30
        
        
        self.reportText?.layer.backgroundColor = UIColor.barColor.cgColor
        self.reportText?.layer.borderColor = UIColor.black.cgColor
        self.reportText?.layer.borderWidth = 1
        self.reportText?.layer.cornerRadius = 15
        self.reportText?.layer.backgroundColor = UIColor.barColor.cgColor
        self.reportText.becomeFirstResponder()
        
        self.sendButton.layer.cornerRadius = 8
        self.sendButton.layer.borderWidth = 1
        self.sendButton.layer.borderColor = UIColor.black.cgColor
        self.sendButton.layer.backgroundColor = UIColor.greenCell.cgColor
        self.sendButton.setTitleColor(UIColor.white, for: .normal)
        
        self.closeButton.layer.cornerRadius = 8
        self.closeButton.layer.borderWidth = 1
        self.closeButton.layer.borderColor = UIColor.black.cgColor
        self.closeButton.layer.backgroundColor = UIColor.greenCell.cgColor
        self.closeButton.setTitleColor(UIColor.white, for: .normal)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @IBAction func sendAction(_ sender: Any) {
        print(nameController + "\n")
    }
    
    @IBAction func closeAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    static func showReportAlertViewController(view: UIViewController) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let reportAlert = storyboard.instantiateViewController(withIdentifier: "reportAlert") as! CustomReportAlertViewController
        reportAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        reportAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        
        reportAlert.nameController = NSStringFromClass(view.classForCoder)
        
        view.present(reportAlert, animated: true, completion: nil)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
