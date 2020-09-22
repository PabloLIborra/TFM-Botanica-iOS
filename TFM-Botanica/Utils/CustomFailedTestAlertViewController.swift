//
//  CustomErrorTestAlertViewController.swift
//  TFM-Botanica
//
//  Created by Pablo López Iborra on 22/09/2020.
//  Copyright © 2020 Pablo López Iborra. All rights reserved.
//

import UIKit

class CustomFailedTestAlertViewController: UIViewController {

    @IBOutlet weak var alertBox: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    var textTitle: String = ""
    @IBOutlet weak var informationText: UITextView!
    var textInformation: String = ""
    @IBOutlet weak var closeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.alertBox?.layer.backgroundColor = UIColor.barColor.cgColor
        self.alertBox?.layer.borderColor = UIColor.black.cgColor
        self.alertBox?.layer.borderWidth = 1
        self.alertBox?.layer.cornerRadius = 15
        
        self.titleLabel.text = self.textTitle
        self.titleLabel?.layer.backgroundColor = UIColor.barColor.cgColor
        
        self.informationText.text = self.textInformation
        self.informationText?.layer.backgroundColor = UIColor.barColor.cgColor
        
        self.closeButton.layer.cornerRadius = 8
        self.closeButton.layer.borderWidth = 1
        self.closeButton.layer.borderColor = UIColor.black.cgColor
        self.closeButton.layer.backgroundColor = UIColor.greenCell.cgColor
        self.closeButton.setTitleColor(UIColor.white, for: .normal)
    }
    
    @IBAction func closeAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
