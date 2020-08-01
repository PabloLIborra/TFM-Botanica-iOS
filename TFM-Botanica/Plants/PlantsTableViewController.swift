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
        
        self.updateInterface()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "plantasCell", for: indexPath)
        
        let plantKey = plantSectionTitles[indexPath.section]
        if let plantValues = plantsDictionary[plantKey] {
            cell.textLabel?.text = plantValues[indexPath.row]
        }

        return cell
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "plantSegue" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                if segue.destination is PlantsViewController {
                    let plantController = segue.destination as? PlantsViewController
                    let plantKey = plantSectionTitles[indexPath.section]
                    if let plantValues = plantsDictionary[plantKey] {
                        plantController?.title = plantValues[indexPath.row]
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

}
