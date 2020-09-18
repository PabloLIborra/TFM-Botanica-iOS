//
//  CustomDownloadImagesViewController.swift
//  TFM-Botanica
//
//  Created by Pablo López Iborra on 18/09/2020.
//  Copyright © 2020 Pablo López Iborra. All rights reserved.
//

import UIKit

class CustomDownloadImagesAlertViewController: UIViewController {

    @IBOutlet weak var downloadView: UIView!
    @IBOutlet weak var downloadLabel: UILabel!
    var textLabel = "Descargando archivos"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.downloadLabel.text = self.textLabel
    }
    
    func changeTextLabel(text: String) {
        self.textLabel = text
        self.downloadLabel.text = textLabel
    }
    
    func dismissAlert() {
        self.dismiss(animated: true, completion: nil)
    }
}
