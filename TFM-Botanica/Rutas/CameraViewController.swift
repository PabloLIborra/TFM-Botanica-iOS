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
    var imageFromCamera: UIImage!
    var imagePicker: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if(self.imageFromCamera != nil) {
            self.cameraImage.image = self.imageFromCamera
            self.cameraImage.contentMode = .scaleAspectFill
        }
        
    }

}
