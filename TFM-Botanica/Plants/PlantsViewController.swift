//
//  PlantsViewController.swift
//  TFM-Botanica
//
//  Created by Pablo López Iborra on 01/08/2020.
//  Copyright © 2020 Pablo López Iborra. All rights reserved.
//

import UIKit

class PlantsViewController: UIViewController {

    @IBOutlet weak var photoImage: UIImageView!
    var photoName: String = ""
    @IBOutlet weak var familyLabel: UILabel!
    var family: String = ""
    @IBOutlet weak var descriptionText: UITextView!
    var textDescription: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tlabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 40))
        tlabel.text = self.title
        tlabel.textColor = UIColor.black
        tlabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        tlabel.backgroundColor = UIColor.clear
        tlabel.adjustsFontSizeToFitWidth = true
        tlabel.textAlignment = .center
        self.navigationItem.titleView = tlabel
        
        self.photoImage.image = UIImage(named: photoName)
        self.familyLabel.text = "Familia: \(family)"
        self.familyLabel.adjustsFontSizeToFitWidth = true
        self.descriptionText.text = textDescription
        
        self.updateInterface()
    }
    
    // MARK: Functions
    func updateInterface() {
        //Create report button
        let reportButton = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(reportActionButton))
        reportButton.image = UIImage(systemName: "exclamationmark.triangle")
        self.navigationItem.rightBarButtonItems = [reportButton]
    }
    
    @objc func reportActionButton() {
        CustomReportAlertViewController.showReportAlertViewController(view: self)
    }
}
