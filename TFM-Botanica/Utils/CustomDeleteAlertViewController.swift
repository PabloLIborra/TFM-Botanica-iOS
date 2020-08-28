//
//  CustomDeleteAlertViewController.swift
//  TFM-Botanica
//
//  Created by Pablo López Iborra on 27/08/2020.
//  Copyright © 2020 Pablo López Iborra. All rights reserved.
//

import UIKit
import CoreData

class CustomDeleteAlertViewController: UIViewController {

    @IBOutlet weak var alertBox: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    var textTitle = ""
    @IBOutlet weak var informationText: UITextView!
    var textInformation = ""
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    
    var route: Route?
    var routeTableView: RouteTableViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.alertBox?.layer.backgroundColor = UIColor.barColor.cgColor
        self.alertBox?.layer.borderColor = UIColor.black.cgColor
        self.alertBox?.layer.borderWidth = 1
        self.alertBox?.layer.cornerRadius = 15
        
        self.titleLabel.text = self.textTitle
        self.titleLabel?.layer.backgroundColor = UIColor.barColor.cgColor
        
        self.informationText.text = self.textInformation
        self.informationText?.layer.backgroundColor = UIColor.barColor.cgColor
        self.informationText?.textContainerInset = UIEdgeInsets.zero
        
        self.deleteButton.layer.cornerRadius = 8
        self.deleteButton.layer.borderWidth = 1
        self.deleteButton.layer.borderColor = UIColor.black.cgColor
        self.deleteButton.layer.backgroundColor = UIColor.greenCell.cgColor
        self.deleteButton.setTitleColor(UIColor.white, for: .normal)
        
        self.closeButton.layer.cornerRadius = 8
        self.closeButton.layer.borderWidth = 1
        self.closeButton.layer.borderColor = UIColor.black.cgColor
        self.closeButton.layer.backgroundColor = UIColor.greenCell.cgColor
        self.closeButton.setTitleColor(UIColor.white, for: .normal)
    }

    @IBAction func deleteAction(_ sender: Any) {
        guard let miDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let miContexto = miDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Route")
        let predicateName = NSPredicate(format: "name == %@",self.route!.name!)
        fetchRequest.predicate = predicateName

        do {
            let routes = try miContexto.fetch(fetchRequest) as! [Route]
            
            for route in routes {
                if route == self.route {
                    
                    print("---------Antiguas---------")
                    var fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Activity")
                    var objects = try miContexto.fetch(fetchRequest) as! [Activity]
                    print(objects.count)

                    fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Answer")
                    var objects2 = try miContexto.fetch(fetchRequest) as! [Answer]
                    print(objects2.count)

                    fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Image")
                    var objects3 = try miContexto.fetch(fetchRequest) as! [Image]
                    print(objects3.count)

                    fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Plant")
                    var objects4 = try miContexto.fetch(fetchRequest) as! [Plant]
                    print(objects4.count)

                    fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Question")
                    var objects5 = try miContexto.fetch(fetchRequest) as! [Question]
                    print(objects5.count)

                    fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Route")
                    var objects6 = try miContexto.fetch(fetchRequest) as! [Route]
                    print(objects6.count)
                    
                    miContexto.delete(route)
                    
                    print("---------Nuevas---------")
                    fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Activity")
                    objects = try miContexto.fetch(fetchRequest) as! [Activity]
                    print(objects.count)

                    fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Answer")
                    objects2 = try miContexto.fetch(fetchRequest) as! [Answer]
                    print(objects2.count)

                    fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Image")
                    objects3 = try miContexto.fetch(fetchRequest) as! [Image]
                    print(objects3.count)

                    fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Plant")
                    objects4 = try miContexto.fetch(fetchRequest) as! [Plant]
                    print(objects4.count)

                    fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Question")
                    objects5 = try miContexto.fetch(fetchRequest) as! [Question]
                    print(objects5.count)

                    fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Route")
                    objects6 = try miContexto.fetch(fetchRequest) as! [Route]
                    print(objects6.count)
                }
            }

            self.routeTableView?.updateData()
            try miContexto.save()
        } catch {
            print(error)
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func closeAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
