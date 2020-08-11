//
//  CustomPlantAlertViewController.swift
//  TFM-Botanica
//
//  Created by Pablo López Iborra on 10/08/2020.
//  Copyright © 2020 Pablo López Iborra. All rights reserved.
//

import UIKit

class CustomPlantAlertViewController: UIViewController {

    @IBOutlet weak var alertBox: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    var titleCustom: String = ""
    @IBOutlet weak var informationText: UITextView!
    var information: String = ""
    @IBOutlet weak var routeText: UITextView!
    var route: String = ""
    @IBOutlet weak var activityText: UITextView!
    var activity: String = ""
    @IBOutlet weak var closeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.alertBox?.layer.backgroundColor = UIColor.barColor.cgColor
        self.alertBox?.layer.borderColor = UIColor.black.cgColor
        self.alertBox?.layer.borderWidth = 1
        self.alertBox?.layer.cornerRadius = 30
        
        self.titleLabel.text = self.titleCustom
        self.titleLabel?.layer.backgroundColor = UIColor.barColor.cgColor
        
        self.informationText.text = self.information
        self.informationText?.layer.backgroundColor = UIColor.barColor.cgColor
        
        self.routeText.text = "Itinerario\n" + "\"" + self.route + "\""
        self.routeText?.layer.backgroundColor = UIColor.barColor.cgColor
        
        self.activityText.text = "Actividad\n" + "\"" + self.activity + "\""
        self.activityText?.layer.backgroundColor = UIColor.barColor.cgColor
        
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
