//
//  CustomAlertViewController.swift
//  TFM-Botanica
//
//  Created by Pablo López Iborra on 14/04/2020.
//  Copyright © 2020 Pablo López Iborra. All rights reserved.
//

import UIKit

class CustomMapAlertViewController: UIViewController {

    @IBOutlet weak var alertBox: UIView!
    
    //Principal
    @IBOutlet weak var name: UILabel!
    var nameText:String = ""
    @IBOutlet weak var information: UITextView!
    var informationText:String = ""
    
    //Legend
    @IBOutlet weak var inactiveImage: UIImageView!
    var imageInactive: UIImage = UIImage()
    @IBOutlet weak var inactiveText: UILabel!
    var textInactive:String = ""
    
    @IBOutlet weak var availableImage: UIImageView!
    var imageAvailable: UIImage = UIImage()
    @IBOutlet weak var availableText: UILabel!
    var textAvailable:String = ""
    
    @IBOutlet weak var onProgressImage: UIImageView!
    var imageOnProgress: UIImage = UIImage()
    @IBOutlet weak var onProgressText: UILabel!
    var textOnProgress:String = ""
    
    @IBOutlet weak var completeImage: UIImageView!
    var imageComplete: UIImage = UIImage()
    @IBOutlet weak var completeText: UILabel!
    var textComplete:String = ""
    
    @IBOutlet weak var closeButton: UIButton!
    var textButton:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.alertBox?.layer.backgroundColor = UIColor.barColor.cgColor
        self.alertBox?.layer.borderColor = UIColor.black.cgColor
        self.alertBox?.layer.borderWidth = 1
        self.alertBox?.layer.cornerRadius = 30
        
        self.name.text = self.nameText
        
        self.information.text = self.informationText
        self.information?.layer.backgroundColor = UIColor.barColor.cgColor
        
        self.inactiveImage.image = self.imageInactive
        self.inactiveText.text = self.textInactive
        
        self.availableImage.image = self.imageAvailable
        self.availableText.text = self.textAvailable
        
        self.onProgressImage.image = self.imageOnProgress
        self.onProgressText.text = self.textOnProgress
        
        self.completeImage.image = self.imageComplete
        self.completeText.text = self.textComplete
        
        self.closeButton.setTitle(self.textButton, for: .normal)
        self.closeButton.layer.cornerRadius = 8
        self.closeButton.layer.borderWidth = 1
        self.closeButton.layer.borderColor = UIColor.black.cgColor
        self.closeButton.layer.backgroundColor = UIColor.greenCell.cgColor
        self.closeButton.setTitleColor(UIColor.white, for: .normal)
    }
    
    @IBAction func actionButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
