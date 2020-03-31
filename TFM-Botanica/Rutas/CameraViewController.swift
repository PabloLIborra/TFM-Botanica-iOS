//
//  CameraViewController.swift
//  TFM-Botanica
//
//  Created by Pablo López Iborra on 31/03/2020.
//  Copyright © 2020 Pablo López Iborra. All rights reserved.
//

import UIKit

class CameraViewController: UIViewController {

    @IBOutlet weak var cameraImage: UIImageView!
    @IBOutlet weak var photoButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.photoButton.layer.cornerRadius = 40
        
    }
    

}
