//
//  ActivityViewController.swift
//  TFM-Botanica
//
//  Created by Pablo López Iborra on 31/03/2020.
//  Copyright © 2020 Pablo López Iborra. All rights reserved.
//

import UIKit

class ActivityViewController: UIViewController {

    @IBOutlet weak var descriptionTextField: UITextView!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var stateImageColor: UIImageView!
    @IBOutlet weak var questionButton: UIButton!
    @IBOutlet weak var captureButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.questionButton.layer.cornerRadius = 8
        self.questionButton.layer.borderWidth = 3
        self.questionButton.layer.borderColor = UIColor.black.cgColor
        self.questionButton.layer.backgroundColor = UIColor.systemBlue.cgColor
        self.questionButton.setTitleColor(UIColor.white, for: .normal)
        self.captureButton.layer.cornerRadius = 8
        self.captureButton.layer.borderWidth = 3
        self.captureButton.layer.borderColor = UIColor.black.cgColor
        self.captureButton.layer.backgroundColor = UIColor.systemBlue.cgColor
        self.captureButton.setTitleColor(UIColor.white, for: .normal)
    }
    
    @IBAction func questionAction(_ sender: Any) {
    }
    
    @IBAction func captureAction(_ sender: Any) {
    }
    
}
