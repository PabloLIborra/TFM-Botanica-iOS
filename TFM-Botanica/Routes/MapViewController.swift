//
//  MapViewController.swift
//  TFM-Botanica
//
//  Created by Pablo López Iborra on 30/03/2020.
//  Copyright © 2020 Pablo López Iborra. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreData

class MapViewController: UIViewController, GMSMapViewDelegate {
    
    var route: Route?
    
    @IBOutlet var mapView: GMSMapView!
    var tappedMarker : GMSMarker?
    var customInfoWindow : CustomInfoWindow?
    var markers : [CustomMarker] = []
    var activities: [Activity] = []
    
    //Data Information window
    var name: String = "Nombre ruta"
    var information: String = "Información de la ruta"
    var stateRoute: Int = -1
    
    //Check to complete route
    var numCompletedActivities = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapView.delegate = self
        self.tappedMarker = CustomMarker(state: 0)
        self.customInfoWindow = CustomInfoWindow().loadView()
        
        self.updateInterface()
        self.updateRouteData()
        self.checkActivitiesFromCoreData()
        self.updateMarkers()
        
        var camera: GMSCameraPosition
        if activities.count > 0 {
            camera = GMSCameraPosition.camera(withLatitude: activities[0].latitude, longitude: activities[0].longitude, zoom: 15)
        }
        else
        {
            camera = GMSCameraPosition.camera(withLatitude: 38.385750, longitude: -0.514250, zoom: 15)
        }
        self.mapView.camera = camera
        
        if(self.stateRoute == State.AVAILABLE) {
            self.informationActionButton()
        }
    }
    
//    MARK: MapView delegates
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        self.tappedMarker = marker
        
        let camera = GMSCameraUpdate.setTarget(self.tappedMarker!.position)
        self.mapView.animate(with: camera)
        
        self.customInfoWindow?.titleLabel.text = self.tappedMarker?.title
        self.customInfoWindow?.subtitleText.text = "HolaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaHolaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaHolaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
        self.customInfoWindow?.subtitleText.layer.backgroundColor = UIColor.barColor.cgColor
        self.customInfoWindow?.subtitleText.textContainerInset = UIEdgeInsets.zero
        
        self.customInfoWindow?.button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        self.customInfoWindow?.button.layer.cornerRadius = 8
        self.customInfoWindow?.button.layer.borderWidth = 1
        self.customInfoWindow?.button.layer.borderColor = UIColor.black.cgColor
        self.customInfoWindow?.button.layer.backgroundColor = UIColor.init(red: 45/255, green: 118/255, blue: 79/255, alpha: 1.0).cgColor
        self.customInfoWindow?.button.setTitleColor(UIColor.white, for: .normal)
        
        self.customInfoWindow?.center = self.mapView.projection.point(for: self.tappedMarker!.position)
        self.customInfoWindow?.center.y -= 100
        
        self.customInfoWindow?.layer.backgroundColor = UIColor.init(red: 190/255, green: 255/255, blue: 208/255, alpha: 1.0).cgColor
        self.customInfoWindow?.layer.borderColor = UIColor.black.cgColor
        self.customInfoWindow?.layer.borderWidth = 1
        self.customInfoWindow?.layer.cornerRadius = 8
        
        self.mapView.addSubview(self.customInfoWindow!)
        
        return false
    }

    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        return UIView()
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        customInfoWindow?.removeFromSuperview()
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        let position = tappedMarker?.position
        customInfoWindow?.center = mapView.projection.point(for: position!)
        customInfoWindow?.center.y -= 100
    }
    
    // MARK: Functions
    func unlockNextActivityFromActivityChange(activity: Activity) {
        let indexPath = self.activities.firstIndex(of: activity)
        if indexPath != self.activities.count - 1 {
            self.activities[indexPath! + 1].state = Int16(State.AVAILABLE)
            self.updateFromActivityChange()
        }
    }
    
    func updateFromActivityChange() {
        self.updateRouteData()
        self.updateMarkers()
    }
    
    func updateRouteData() {
        self.name = route!.name!
        self.information = route!.information!
        self.stateRoute = Int(route!.state)
        self.activities = route!.activities?.allObjects as! [Activity]
        
        self.activities.sort(by: { $0.date!.compare($1.date!) == .orderedAscending })
    }
    
    func updateMarkers() {
        // Add Markers into the map
        self.numCompletedActivities = 0
        self.mapView.clear()
        self.markers = []
        for activity in activities {
            print(activity.title)
            self.addMapMarker(latitude: activity.latitude, longitude: activity.longitude, title: activity.title!, subtitle: activity.subtitle!, state: Int(activity.state))
            
            if activity.state == State.COMPLETE {
                self.numCompletedActivities += 1
            }
        }
        
        if self.activities.count == self.numCompletedActivities {
            self.route?.state = Int16(State.COMPLETE)
            self.updateRouteFromCoreData()
        } else if self.activities.count >= self.numCompletedActivities && self.activities[0].state != State.AVAILABLE {
            self.route?.state = Int16(State.IN_PROGRESS)
            self.updateRouteFromCoreData()
        }
        
        self.drawPolylineBetweenMarkers()
    }
    
    func drawPolylineBetweenMarkers() {
        let path = GMSMutablePath()
        for marker in self.markers {
            let location = CLLocationCoordinate2D(latitude: marker.layer.latitude, longitude: marker.layer.longitude)
            
            path.add(location)
        }
        let polyline = GMSPolyline(path: path)
        polyline.strokeColor = UIColor.greenCell
        polyline.strokeWidth = 2
        polyline.map = self.mapView
    }
    
    func updateRouteFromCoreData() {
        guard let miDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let miContexto = miDelegate.persistentContainer.viewContext
        
        let requestRoutes : NSFetchRequest<Route> = NSFetchRequest(entityName:"Route")
        let routes = try? miContexto.fetch(requestRoutes)
        
        if(routes!.count > 0) {
            for route in routes! {
                if route == self.route {
                    route.state = Int16(self.route!.state)
                    break
                }
            }

            do {
                try miContexto.save()
            } catch let error as NSError  {
                print("Error al guardar el contexto: \(error)")
            }
        }
        
    }
    
    func checkActivitiesFromCoreData() {
        guard let miDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let miContexto = miDelegate.persistentContainer.viewContext
        
        let requestRoutes : NSFetchRequest<Route> = NSFetchRequest(entityName:"Route")
        let routes = try? miContexto.fetch(requestRoutes)
        
        if(routes!.count > 0) {
            var changeActivity = false
            var changedActivity = Activity()
            routesLoop: for route in routes! {
                if route == self.route {
                    let activities = self.activities
                    activitiesLoop: for activity in activities {
                        if activity.state != State.COMPLETE {
                            if activity.state != State.IN_PROGRESS {
                                if activity.state != State.AVAILABLE {
                                    if activity.state == State.INACTIVE {
                                        activity.state = Int16(State.AVAILABLE)
                                        changedActivity = activity
                                        changeActivity = true
                                    }
                                }
                            }
                            break activitiesLoop
                        }
                    }
                    if changeActivity == true {
                        let activities = route.activities?.allObjects as! [Activity]
                        activitiesLoop: for activity in activities {
                            if activity.latitude == changedActivity.latitude && activity.longitude == changedActivity.longitude {
                                activity.state = changedActivity.state
                                break activitiesLoop
                            }
                        }
                    }
                    break routesLoop
                }
            }

            do {
                if changeActivity == true {
                    try miContexto.save()
                }
            } catch let error as NSError  {
                print("Error al guardar el contexto: \(error)")
            }
        }
        
    }
    
    func updateInterface() {
        //Create report button
        let reportButton = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(reportActionButton))
        reportButton.image = UIImage(systemName: "exclamationmark.triangle")
        //Create information button
        let infoButton = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(informationActionButton))
        infoButton.image = UIImage(systemName: "info.circle")
        
        self.navigationItem.rightBarButtonItems = [reportButton, infoButton]
    }
    
    @objc func reportActionButton() {
        CustomReportAlertViewController.showReportAlertViewController(view: self)
    }

    @objc func informationActionButton() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let informationAlert = storyboard.instantiateViewController(withIdentifier: "informationAlert") as! CustomMapAlertViewController
        informationAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        informationAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        
        informationAlert.nameText = self.name
        informationAlert.informationText = self.information
        informationAlert.imageInactive = GMSMarker.markerImage(with: UIColor.gray)
        informationAlert.textInactive = "Actividad Bloqueada, se desbloqueara completando la anterior"
        informationAlert.imageAvailable = GMSMarker.markerImage(with: UIColor.cyan)
        informationAlert.textAvailable = "Actividad disponible"
        informationAlert.imageOnProgress = GMSMarker.markerImage(with: UIColor.red)
        informationAlert.textOnProgress = "Actividad en progreso"
        informationAlert.imageComplete = GMSMarker.markerImage(with: UIColor.green)
        informationAlert.textComplete = "Actividad completada"
        informationAlert.textButton = "Cerrar"
        
        self.present(informationAlert, animated: true, completion: nil)
    }
    
    @objc func buttonAction() {
        let navigationController:UINavigationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "activityNavigation") as! UINavigationController
        navigationController.modalPresentationStyle = .automatic
        let activityController = navigationController.viewControllers.first as! ActivityViewController
        
        activityController.mapViewController = self
        
        for activity in self.activities {
            if activity.latitude == self.tappedMarker!.position.latitude && activity.longitude == self.tappedMarker!.position.longitude {
                activityController.activity = activity
                break
            }
        }
        
        self.present(navigationController, animated: true, completion: nil)
    }
    
    //Estate: 0 - Inactive
    //        1 - On Progress
    //        2 - Complete
    func addMapMarker(latitude:Double, longitude:Double, title:String, subtitle:String, state:Int) {
        let marker = CustomMarker(state: state)
        marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        marker.title = title
        marker.snippet = subtitle
        marker.map = mapView
        
        self.markers.append(marker)
    }
}
