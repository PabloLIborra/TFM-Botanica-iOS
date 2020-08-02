//
//  PlantsTableViewController.swift
//  TFM-Botanica
//
//  Created by Pablo López Iborra on 30/03/2020.
//  Copyright © 2020 Pablo López Iborra. All rights reserved.
//

import UIKit

class PlantsTableViewController: UITableViewController {

    var plantsDictionary = [String: [String]]()
    var plantSectionTitles = [String]()
    
    let plants = ["Audi", "Aston Martin","BMW", "Bugatti", "Bentley","Chevrolet", "Cadillac","Dodge","Ferrari", "Ford","Honda","Jaguar","Lamborghini","Mercedes", "Mazda","Nissan","Porsche","Rolls Royce","Toyota","Volkswagen"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.tableView.backgroundView = UIImageView(image: UIImage(named: "background-plants.jpeg"))
        self.tableView.backgroundView?.contentMode = .scaleAspectFill
        self.tableView.backgroundView?.alpha = 0.3
        
        self.tableView.contentInset.top = 10.0
        
        self.updateInterface()
        self.loadPlantsCoreData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return self.plantSectionTitles.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let plantKey = plantSectionTitles[section]
        if let plantValues = plantsDictionary[plantKey] {
            return plantValues.count
        }
            
        return 0
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?{
        return self.plantSectionTitles[section]
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "plantasCell", for: indexPath) as! PlantsTableViewCell
        
        let plantKey = plantSectionTitles[indexPath.section]
        if let plantValues = plantsDictionary[plantKey] {
            cell.nameLabel.text = plantValues[indexPath.row]
            cell.plantImage.image = UIImage(named: "background-plants.jpeg")
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44.0
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = Bundle.main.loadNibNamed("CustomHeaderViewPlantsTableViewCell", owner: self, options: nil)?.first as! CustomHeaderViewPlantsTableViewCell
        
        headerView.titleLabel.text = self.plantSectionTitles[section]
        
        return headerView
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "plantSegue" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                if segue.destination is PlantsViewController {
                    let plantController = segue.destination as? PlantsViewController
                    let plantKey = plantSectionTitles[indexPath.section]
                    if let plantValues = plantsDictionary[plantKey] {
                        plantController?.title = plantValues[indexPath.row]
                        plantController?.family = "Prueba"
                        plantController?.photoName = "background-routes.jpeg"
                        plantController?.textDescription = "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda."
                        
                    }
                }
            }
        }
        
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if(identifier == "cameraSegue") {
            return false
        }
        return true
    }
    
    // MARK: Functions
    func updateInterface() {
        //Create report button
        let reportButton = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(reportActionButton))
        reportButton.image = UIImage(systemName: "exclamationmark.triangle")
        self.navigationItem.rightBarButtonItems = [reportButton]
    }
    
    @objc func reportActionButton() {
        
    }
    
    // MARK: ToDo: Cambiar a core data y no datos fijos
    func loadPlantsCoreData() {
        for plant in plants {
            let plantKey = String(plant.prefix(1))
                if var plantValues = plantsDictionary[plantKey] {
                    plantValues.append(plant)
                    plantsDictionary[plantKey] = plantValues
                } else {
                    plantsDictionary[plantKey] = [plant]
                }
        }
        
        // 2
        plantSectionTitles = [String](plantsDictionary.keys)
        plantSectionTitles = plantSectionTitles.sorted(by: { $0 < $1 })
    }
}
