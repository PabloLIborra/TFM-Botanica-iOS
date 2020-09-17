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
        
        self.updateInterface()

        if(self.imageFromCamera != nil) {
            self.cameraImage.image = self.imageFromCamera
            self.cameraImage.contentMode = .scaleAspectFill
        }
    }
    
    // MARK: Functions
    
    func updateInterface() {
        //Create report button
        let reportButton = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(reportActionButton))
        reportButton.image = UIImage(systemName: "exclamationmark.triangle")
        self.navigationItem.rightBarButtonItems = [reportButton]
    }
    
    @objc func reportActionButton() {
        CustomReportAlertViewController.shared.showReportAlertViewController(view: self)
    }

}
