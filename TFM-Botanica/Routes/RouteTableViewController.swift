//
//  RouteTableViewController.swift
//  TFM-Botanica
//
//  Created by Pablo López Iborra on 30/03/2020.
//  Copyright © 2020 Pablo López Iborra. All rights reserved.
//

import UIKit
import CoreData

class RouteTableViewController: UITableViewController {

    let sections = ["En proceso", "Nuevas", "Completadas"]
    var routesAvailables: [Route] = []
    var routesOnProgress: [Route] = []
    var routesComplete: [Route] = []
    
    private let customRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // This will remove extra separators from tableview
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        self.addRefreshControl()

        self.updateInterface()
        self.loadRoutesCoreData()
    }
    
    @objc private func refreshTableData() {
        DispatchQueue.main.async {
            self.updateData()
            self.customRefreshControl.endRefreshing()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.updateData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return self.sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case State.ON_PROGRESS:
                return self.routesOnProgress.count
            case State.AVAILABLE:
                return self.routesAvailables.count
            case State.COMPLETE:
                return self.routesComplete.count
            default:
                return 0
        }
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?{
            return self.sections[section]
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "routesCell", for: indexPath) as! RouteTableViewCell

        var route: Route = Route()
        if(indexPath.section == State.ON_PROGRESS) {
            route = routesOnProgress[indexPath.row]
        } else if(indexPath.section == State.AVAILABLE) {
            route = routesAvailables[indexPath.row]
        } else if(indexPath.section == State.COMPLETE) {
            route = routesComplete[indexPath.row]
        }

        cell.nameLabel.text = route.name
        cell.informationLabel.text = route.information
        var complete = 0
        for activity in route.activities?.allObjects as! [Activity] {
            if(activity.state == State.COMPLETE) {
                complete += 1
            }
        }
        cell.progressLabel.text = String(complete) + "/" + String(route.activities!.allObjects.count)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mapSegue" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let destiny = segue.destination as! MapViewController
                
                var route: Route = Route()
                if(indexPath.section == State.ON_PROGRESS) {
                    route = routesOnProgress[indexPath.row]
                } else if(indexPath.section == State.AVAILABLE) {
                    route = routesAvailables[indexPath.row]
                } else if(indexPath.section == State.COMPLETE) {
                    route = routesComplete[indexPath.row]
                }
                
                destiny.route = route
            }
        }
    }
    
    // MARK: Functions
    func updateInterface() {
        //Create report button
        let reportButton = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(reportActionButton))
        reportButton.image = UIImage(systemName: "exclamationmark.triangle")
        self.navigationItem.rightBarButtonItems = [reportButton]
    }
    
    func updateData() {
        self.routesOnProgress = []
        self.routesAvailables = []
        self.routesComplete = []
        
        self.loadRoutesCoreData()
        self.tableView.reloadData()
    }
    
    @objc func reportActionButton() {
        
    }
    
    func addRefreshControl() {
        self.customRefreshControl.tintColor = UIColor(red:0.25, green:0.72, blue:0.85, alpha:1.0)
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor(red:0.25, green:0.72, blue:0.85, alpha:1.0)]
        self.customRefreshControl.attributedTitle = NSAttributedString(string: "Actualizando Rutas ...", attributes: attributes)

        if #available(iOS 10.0, *) {
           tableView.refreshControl = customRefreshControl
        } else {
           tableView.addSubview(customRefreshControl)
        }

        customRefreshControl.addTarget(self, action: #selector(refreshTableData), for: .valueChanged)
    }
    
    func loadRoutesCoreData() {
        guard let miDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let miContexto = miDelegate.persistentContainer.viewContext
        
        let requestRoutes : NSFetchRequest<Route> = NSFetchRequest(entityName:"Route")
        var routes = try? miContexto.fetch(requestRoutes)
        
        routes!.sort(by: {$0.name!.lowercased() < $1.name!.lowercased()})
        
        for route in routes! {
            if(route.state == State.ON_PROGRESS) {
                self.routesOnProgress.append(route)
            } else if(route.state == State.AVAILABLE) {
                self.routesAvailables.append(route)
            } else if(route.state == State.COMPLETE) {
                self.routesComplete.append(route)
            }
        }
    }

}
