//
//  CustomDownloadImagesAlertViewController.swift
//  TFM-Botanica
//
//  Created by Pablo López Iborra on 18/09/2020.
//  Copyright © 2020 Pablo López Iborra. All rights reserved.
//

import UIKit

class CustomDownloadImagesAlertViewController: UIViewController {

    var listRoutes: RouteTableViewController?
    
    @IBOutlet weak var downloadView: UIView!
    @IBOutlet weak var downloadLabel: UILabel!
    var textLabel: String = "Descargando archivos"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.downloadLabel.text = textLabel
    }

    func changeLabel(text: String) {
        if self.downloadLabel != nil {
            self.textLabel = text
            self.downloadLabel.text = self.textLabel
        }
    }
    
    func dismissAlert() {
        self.dismiss(animated: true, completion: nil)
    }
}
