//
//  InitViewController.swift
//  TFM-Botanica
//
//  Created by Pablo López Iborra on 31/03/2020.
//  Copyright © 2020 Pablo López Iborra. All rights reserved.
//

import UIKit

class InitViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var initButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initButton.layer.cornerRadius = 8
        self.initButton.layer.borderWidth = 3
        self.initButton.layer.borderColor = UIColor.black.cgColor
        self.initButton.layer.backgroundColor = UIColor.systemBlue.cgColor
        self.initButton.setTitleColor(UIColor.white, for: .normal)
    }
    
}
