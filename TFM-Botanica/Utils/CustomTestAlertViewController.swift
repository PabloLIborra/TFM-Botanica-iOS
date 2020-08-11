//
//  CustomTestAlertViewController.swift
//  TFM-Botanica
//
//  Created by Pablo López Iborra on 11/08/2020.
//  Copyright © 2020 Pablo López Iborra. All rights reserved.
//

import UIKit

class CustomTestAlertViewController: UIViewController {

    @IBOutlet weak var alertBox: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    var textTitle: String = ""
    @IBOutlet weak var informationText: UITextView!
    var textInformation: String = ""
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    
    var plant: Plant?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.alertBox?.layer.backgroundColor = UIColor.barColor.cgColor
        self.alertBox?.layer.borderColor = UIColor.black.cgColor
        self.alertBox?.layer.borderWidth = 1
        self.alertBox?.layer.cornerRadius = 15
        
        self.titleLabel.text = self.textTitle
        self.titleLabel?.layer.backgroundColor = UIColor.barColor.cgColor
        
        self.informationText.text = self.textInformation + "\n \n \"" + self.plant!.scientific_name! + "\""
        self.informationText?.layer.backgroundColor = UIColor.barColor.cgColor
        
        self.acceptButton.layer.cornerRadius = 8
        self.acceptButton.layer.borderWidth = 1
        self.acceptButton.layer.borderColor = UIColor.black.cgColor
        self.acceptButton.layer.backgroundColor = UIColor.greenCell.cgColor
        self.acceptButton.setTitleColor(UIColor.white, for: .normal)
        
        self.closeButton.layer.cornerRadius = 8
        self.closeButton.layer.borderWidth = 1
        self.closeButton.layer.borderColor = UIColor.black.cgColor
        self.closeButton.layer.backgroundColor = UIColor.greenCell.cgColor
        self.closeButton.setTitleColor(UIColor.white, for: .normal)
    }
    
    @IBAction func acceptAction(_ sender: Any) {
        self.loadCompletedPlant()
    }
    
    @IBAction func closeAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    func loadCompletedPlant() {
        let tabBarController:UITabBarController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "initialTabController") as! UITabBarController
        tabBarController.selectedIndex = 1
        let navigationController:UINavigationController = tabBarController.selectedViewController! as! UINavigationController
        navigationController.modalPresentationStyle = .automatic
        
        let plant = self.storyboard?.instantiateViewController(withIdentifier: "plantController") as! PlantsViewController

        plant.title = self.plant!.scientific_name
        plant.family = self.plant!.family!
        plant.photoName = "background-routes.jpeg"
        plant.textDescription = self.plant!.information!
        
        navigationController.pushViewController(plant, animated: true)
        
        self.present(tabBarController, animated: true, completion: nil)
    }
}
