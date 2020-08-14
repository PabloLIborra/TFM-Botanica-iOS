//
//  CreditsViewController.swift
//  TFM-Botanica
//
//  Created by Pablo López Iborra on 13/08/2020.
//  Copyright © 2020 Pablo López Iborra. All rights reserved.
//

import UIKit

class CreditsViewController: UIViewController {

    @IBOutlet weak var backgroundImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.backgroundImage.image = UIImage(named: "background-credits.jpeg")
        self.backgroundImage.contentMode = .scaleAspectFill
        self.backgroundImage.alpha = 0.3
        
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
