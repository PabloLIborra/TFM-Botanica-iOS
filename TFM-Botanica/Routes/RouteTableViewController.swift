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
    var routesInProgress: [Route] = []
    var routesComplete: [Route] = []
    
    private let customRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // This will remove extra separators from tableview
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.tableView.backgroundView = UIImageView(image: UIImage(named: "background-routes.jpeg"))
        self.tableView.backgroundView?.contentMode = .scaleAspectFill
        self.tableView.backgroundView?.alpha = 0.3
        
        self.tableView.contentInset.top = 10.0
        
        self.addRefreshControl()

        self.updateInterface()
        self.loadRoutesCoreData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    @objc private func refreshTableData() {
        DispatchQueue.main.async {
            JSONRequest.readJSONFromServer()
            self.updateData()
            self.customRefreshControl.endRefreshing()
        }
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return self.sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case State.IN_PROGRESS:
                return self.routesInProgress.count
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

        var route: Route?
        if(indexPath.section == State.IN_PROGRESS) {
            route = routesInProgress[indexPath.row]
        } else if(indexPath.section == State.AVAILABLE) {
            route = routesAvailables[indexPath.row]
        } else if(indexPath.section == State.COMPLETE) {
            route = routesComplete[indexPath.row]
        }

        cell.nameLabel.text = route!.name
        cell.informationLabel.text = route!.information
        var complete = 0
        for activity in route!.activities?.allObjects as! [Activity] {
            if(activity.state == State.COMPLETE) {
                complete += 1
            }
        }
        cell.progressLabel.text = String(complete) + "/" + String(route!.activities!.allObjects.count)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44.0
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = Bundle.main.loadNibNamed("CustomHeaderViewRoutesTableViewCell", owner: self, options: nil)?.first as! CustomHeaderViewRoutesTableViewCell
        
        switch section {
            case 0:
                headerView.headerImage.image = UIImage(named: "inProcess-route-icon.png")
            case 1:
                headerView.headerImage.image = UIImage(named: "new-route-icon.png")
            case 2:
                headerView.headerImage.image = UIImage(named: "completed-route-icon.png")
            default:
                break
        }
        headerView.headerLabel.text = self.sections[section]
        
        return headerView
    }
    
    /*override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor.red
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.black
        header.textLabel?.font = UIFont.boldSystemFont(ofSize: 18.0)
    }*/
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mapSegue" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let destiny = segue.destination as! MapViewController
                
                var route: Route?
                if(indexPath.section == State.IN_PROGRESS) {
                    route = routesInProgress[indexPath.row]
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
        self.routesInProgress = []
        self.routesAvailables = []
        self.routesComplete = []
        
        self.loadRoutesCoreData()
        self.tableView.reloadData()
    }
    
    @objc func reportActionButton() {
        CustomReportAlertViewController.showReportAlertViewController(view: self)
    }
    
    func addRefreshControl() {
        self.customRefreshControl.tintColor = UIColor(red:0, green:0, blue:0, alpha:1.0)
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor(red:0, green:0, blue:0, alpha:1.0)]
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
            if(route.state == State.IN_PROGRESS) {
                self.routesInProgress.append(route)
            } else if(route.state == State.AVAILABLE) {
                self.routesAvailables.append(route)
            } else if(route.state == State.COMPLETE) {
                self.routesComplete.append(route)
            }
        }
    }

}
