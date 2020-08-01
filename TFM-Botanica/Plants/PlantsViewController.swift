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

        self.photoImage.image = UIImage(named: photoName)
        self.familyLabel.text = "Familia: \(family)"
        self.descriptionText.text = textDescription
    }

}
