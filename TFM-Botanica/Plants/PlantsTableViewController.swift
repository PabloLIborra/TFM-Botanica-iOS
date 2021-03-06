//
//  PlantsTableViewController.swift
//  TFM-Botanica
//
//  Created by Pablo López Iborra on 30/03/2020.
//  Copyright © 2020 Pablo López Iborra. All rights reserved.
//

import UIKit
import CoreData

class PlantsTableViewController: UITableViewController {

    var plantsDictionary = [String: [Plant]]()
    var plantSectionTitles = [String]()
    var imagesPlant = [Plant:UIImage]()
    
    private let customRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.tableView.backgroundView = UIImageView(image: UIImage(named: "background-plants.jpeg"))
        self.tableView.backgroundView?.contentMode = .scaleAspectFill
        self.tableView.backgroundView?.alpha = 0.3
        
        self.tableView.contentInset.top = 10.0
        
        self.addRefreshControl()
        
        self.updateInterface()
        self.loadPlantsCoreData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.updateData()
        }
    }
    
    @objc private func refreshTableData() {
        DispatchQueue.main.async {
            self.updateData()
            self.customRefreshControl.endRefreshing()
            self.imagesPlant.removeAll()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return self.plantSectionTitles.count + 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section != 0 {
            let plantKey = plantSectionTitles[section-1]
            if let plantValues = plantsDictionary[plantKey] {
                return plantValues.count
            }
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?{
        return self.plantSectionTitles[section]
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "plantasCell", for: indexPath) as! PlantsTableViewCell
        
        if indexPath.section == 0 {
            return cell
        }
        
        let plantKey = plantSectionTitles[indexPath.section - 1]
        let keyExists = self.imagesPlant[plantsDictionary[plantKey]![indexPath.row]] != nil
        var imagePlant: UIImage
        if let plantValues = plantsDictionary[plantKey] {
            cell.nameLabel.text = plantValues[indexPath.row].scientific_name
            if var image = plantValues[indexPath.row].images?.allObjects as? [Image] {
                image.sort(by: { $0.name!.compare($1.name!) == .orderedAscending })
                if image.count > 0 {
                    if keyExists == true {
                        imagePlant = self.imagesPlant[plantsDictionary[plantKey]![indexPath.row]]!
                    } else {
                        imagePlant = UIImage(data: image.first!.image!)!
                        self.imagesPlant[plantsDictionary[plantKey]![indexPath.row]] = imagePlant
                    }
                } else {
                    if keyExists == true {
                        imagePlant = self.imagesPlant[plantsDictionary[plantKey]![indexPath.row]]!
                    } else {
                        imagePlant = UIImage(named: "notAvailable.png")!
                        self.imagesPlant[plantsDictionary[plantKey]![indexPath.row]] = imagePlant
                    }
                }
            } else {
                if keyExists == true {
                    imagePlant = self.imagesPlant[plantsDictionary[plantKey]![indexPath.row]]!
                } else {
                    imagePlant = UIImage(named: "notAvailable.png")!
                    self.imagesPlant[plantsDictionary[plantKey]![indexPath.row]] = imagePlant
                }
            }
            cell.plantImage.image = imagePlant
            
            if plantValues[indexPath.row].unlock == false{
                cell.setInteractableCardView(interactable: false)
            } else {
                cell.setInteractableCardView(interactable: true)
            }
        } else {
            cell.plantImage.image = UIImage(named: "notAvailable.png")
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

        var plantsUnlock = 0
        
        if section == 0 {
            headerView.titleLabel.text = "Plantas totales"
            headerView.titleLabel.font = UIFont.systemFont(ofSize: headerView.titleLabel.font.pointSize, weight: .heavy)
            
            var numPlants = 0
            for sectionCount in self.plantSectionTitles {
                if let plantValues = plantsDictionary[sectionCount] {
                    for plant in plantValues {
                        numPlants += 1
                        if plant.unlock == true {
                            plantsUnlock += 1
                        }
                    }
                }
            }
            
            headerView.numberLabel.text = String(plantsUnlock) + "/" + String(numPlants)
            headerView.numberLabel.font = UIFont.systemFont(ofSize: headerView.numberLabel.font.pointSize, weight: .heavy)
        } else {
            let plantKey = plantSectionTitles[section-1]
            if let plantValues = plantsDictionary[plantKey] {
                for plant in plantValues {
                    if plant.unlock == true {
                        plantsUnlock += 1
                    }
                }
            }
            headerView.titleLabel.text = self.plantSectionTitles[section-1]
            headerView.numberLabel.text = String(plantsUnlock) + "/" + String(plantsDictionary[plantKey]!.count)
        }
        
        return headerView
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = self.tableView.indexPathForSelectedRow {
            let plantKey = plantSectionTitles[indexPath.section-1]
            if let plantValues = plantsDictionary[plantKey] {
                if plantValues[indexPath.row].unlock {
                    if segue.identifier == "plantSegue" {
                        if segue.destination is PlantsViewController {
                            let plantController = segue.destination as? PlantsViewController
                            let plantKey = plantSectionTitles[indexPath.section-1]
                            if let plantValues = plantsDictionary[plantKey] {
                                plantController?.title = plantValues[indexPath.row].scientific_name
                                plantController?.family = plantValues[indexPath.row].family!
                                
                                if var imagesPlant = plantValues[indexPath.row].images!.allObjects as? [Image] {
                                    imagesPlant.sort(by: { $0.name!.compare($1.name!) == .orderedAscending })
                                    for imagePlant in imagesPlant {
                                        plantController?.images.append(imagePlant)
                                    }
                                }

                                plantController?.textDescription = plantValues[indexPath.row].information!
                            }
                        }
                    }
                }
            }
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if let indexPath = self.tableView.indexPathForSelectedRow {
            let plantKey = plantSectionTitles[indexPath.section-1]
            if let plantValues = plantsDictionary[plantKey] {
                if !plantValues[indexPath.row].unlock {
                    self.showLockedPlantAlertView(plant: plantValues[indexPath.row])
                    self.tableView.deselectRow(at: indexPath, animated: true)
                    return false
                }
            }
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
    
    func updateData() {
        plantsDictionary = [String: [Plant]]()
        plantSectionTitles = [String]()
        
        self.loadPlantsCoreData()
        self.tableView.reloadData()
    }
    
    @objc func reportActionButton() {
        CustomReportAlertViewController.shared.showReportAlertViewController(view: self)
    }
    
    func loadPlantsCoreData() {
        guard let miDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let miContexto = miDelegate.persistentContainer.viewContext
        
        let requestPlants : NSFetchRequest<Plant> = NSFetchRequest(entityName:"Plant")
        var plants = try? miContexto.fetch(requestPlants)
        
        plants!.sort(by: {$0.scientific_name!.lowercased() < $1.scientific_name!.lowercased()})
        
        for plant in plants! {
            let plantKey = String(plant.scientific_name!.prefix(1))
            if var plantValues = plantsDictionary[plantKey] {
                plantValues.append(plant)
                plantsDictionary[plantKey] = plantValues
            } else {
                plantsDictionary[plantKey] = [plant]
            }
        }
        
        plantSectionTitles = [String](plantsDictionary.keys)
        plantSectionTitles = plantSectionTitles.sorted(by: { $0 < $1 })
    }
    
    func addRefreshControl() {
        self.customRefreshControl.tintColor = UIColor(red:0, green:0, blue:0, alpha:1.0)
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor(red:0, green:0, blue:0, alpha:1.0)]
        self.customRefreshControl.attributedTitle = NSAttributedString(string: "Actualizando Plantas ...", attributes: attributes)

        if #available(iOS 10.0, *) {
           tableView.refreshControl = customRefreshControl
        } else {
           tableView.addSubview(customRefreshControl)
        }

        customRefreshControl.addTarget(self, action: #selector(refreshTableData), for: .valueChanged)
    }
    
    func showLockedPlantAlertView(plant: Plant) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let lockedPlantAlert = storyboard.instantiateViewController(withIdentifier: "lockedPlantAlert") as! CustomPlantAlertViewController
        lockedPlantAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        lockedPlantAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        
        lockedPlantAlert.titleCustom = "Planta Bloqueada"
        lockedPlantAlert.information = "Para poder visualizar esta planta necesitas desbloquearla. Para ello debes completar la siguiente actividad."
        lockedPlantAlert.route = plant.activity!.route!.name!
        lockedPlantAlert.activity = plant.activity!.title!
        
        self.present(lockedPlantAlert, animated: true, completion: nil)
    }
}
