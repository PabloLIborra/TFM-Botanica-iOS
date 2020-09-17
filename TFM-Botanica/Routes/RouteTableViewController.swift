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
        
        
        let longPressGesture:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress))
        longPressGesture.minimumPressDuration = 1.0 // 1 second press
        self.tableView.addGestureRecognizer(longPressGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.updateData()
        }
    }
    
    @objc private func refreshTableData() {
        DispatchQueue.main.async {
            JSONRequest.readJSONFromServer(view: self)
            //self.updateData()
            //self.customRefreshControl.endRefreshing()
        }
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return self.sections.count + 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case 1:
                return self.routesInProgress.count
            case 2:
                return self.routesAvailables.count
            case 3:
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
        if(indexPath.section == 1) {
            route = routesInProgress[indexPath.row]
        } else if(indexPath.section == 2) {
            route = routesAvailables[indexPath.row]
        } else if(indexPath.section == 3) {
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
                let customHeader = Bundle.main.loadNibNamed("CustomHeaderViewPlantsTableViewCell", owner: self, options: nil)?.first as! CustomHeaderViewPlantsTableViewCell
                customHeader.titleLabel.text = "Itinerarios totales"
                customHeader.titleLabel.font = UIFont.systemFont(ofSize: customHeader.titleLabel.font.pointSize, weight: .heavy)
                let numRoutes = self.routesInProgress.count + self.routesAvailables.count + self.routesComplete.count
                customHeader.numberLabel.text = String(self.routesComplete.count) + "/" + String(numRoutes)
                customHeader.numberLabel.font = UIFont.systemFont(ofSize: customHeader.numberLabel.font.pointSize, weight: .heavy)
            
                return customHeader
            case 1:
                headerView.headerImage.image = UIImage(named: "inProcess-route-icon.png")
                headerView.numberLabel.text = String(self.routesInProgress.count)
            case 2:
                headerView.headerImage.image = UIImage(named: "new-route-icon.png")
                headerView.numberLabel.text = String(self.routesAvailables.count)
            case 3:
                headerView.headerImage.image = UIImage(named: "completed-route-icon.png")
                headerView.numberLabel.text = String(self.routesComplete.count)
            default:
                break
        }
        headerView.headerLabel.text = self.sections[section-1]
        
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
                if(indexPath.section == 1) {
                    route = routesInProgress[indexPath.row]
                } else if(indexPath.section == 2) {
                    route = routesAvailables[indexPath.row]
                } else if(indexPath.section == 3) {
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
    
    func endRefreshing() {
        self.customRefreshControl.endRefreshing()
    }
    
    @objc func reportActionButton() {
        CustomReportAlertViewController.shared.showReportAlertViewController(view: self)
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
    
    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer){
        if gestureRecognizer.state == .began {
            let touchPoint = gestureRecognizer.location(in: self.tableView)
            if let indexPath = self.tableView.indexPathForRow(at: touchPoint) {
                var route: Route?
                if(indexPath.section == 1) {
                    route = routesInProgress[indexPath.row]
                } else if(indexPath.section == 2) {
                    route = routesAvailables[indexPath.row]
                } else if(indexPath.section == 3) {
                    route = routesComplete[indexPath.row]
                }
                showDeleteRouteAlertView(route: route!)
            }
        }
    }
    
    func showDeleteRouteAlertView(route: Route) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let deleteRouteAlert = storyboard.instantiateViewController(withIdentifier: "deleteRouteAlert") as! CustomDeleteAlertViewController
        deleteRouteAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        deleteRouteAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        
        deleteRouteAlert.textTitle = "Eliminar"
        deleteRouteAlert.textInformation = "¿Desea eliminar el itinerario" + "\n \"" + route.name! + "\"?\n\nSi realiza esta acción perderá todo su progreso, pero podrá volver a descargarla deslizando hacia abajo la lista."
        deleteRouteAlert.route = route
        deleteRouteAlert.routeTableView = self
        
        self.present(deleteRouteAlert, animated: true, completion: nil)
    }
}
