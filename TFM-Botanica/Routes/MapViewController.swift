//
//  MapViewController.swift
//  TFM-Botanica
//
//  Created by Pablo López Iborra on 30/03/2020.
//  Copyright © 2020 Pablo López Iborra. All rights reserved.
//

import UIKit
import GoogleMaps

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapView.delegate = self
        self.tappedMarker = CustomMarker(state: 0)
        self.customInfoWindow = CustomInfoWindow().loadView()
        
        self.updateInteface()
        self.updateRouteData()
        self.updateMarkers()
        
        let camera = GMSCameraPosition.camera(withLatitude: activities[0].latitude, longitude: activities[0].longitude, zoom: 15)
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
        self.customInfoWindow?.subtitleLabel.text = self.tappedMarker?.snippet
        
        self.customInfoWindow?.button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        self.customInfoWindow?.button.layer.cornerRadius = 8
        self.customInfoWindow?.button.layer.borderWidth = 1
        self.customInfoWindow?.button.layer.borderColor = UIColor.black.cgColor
        self.customInfoWindow?.button.layer.backgroundColor = UIColor.systemBlue.cgColor
        self.customInfoWindow?.button.setTitleColor(UIColor.white, for: .normal)
        
        self.customInfoWindow?.center = self.mapView.projection.point(for: self.tappedMarker!.position)
        self.customInfoWindow?.center.y -= 100
        
        self.customInfoWindow?.layer.backgroundColor = UIColor.white.cgColor
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
    func updateFromActivityChange() {
        self.updateRouteData()
        self.updateMarkers()
    }
    
    func updateRouteData() {
        self.name = route!.name!
        self.information = route!.information!
        self.stateRoute = Int(route!.state)
        self.activities = route!.activities?.allObjects as! [Activity]
    }
    
    func updateMarkers() {
        // Add Markers into the map
        self.mapView.clear()
        self.markers = []
        for activity in activities {
            self.addMapMarker(latitude: activity.latitude, longitude: activity.longitude, title: activity.title!, subtitle: activity.subtitle!, state: Int(activity.state))
        }
    }
    
    func updateInteface() {
        //Create report button
        let reportButton = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(reportActionButton))
        reportButton.image = UIImage(systemName: "exclamationmark.triangle")
        //Create information button
        let infoButton = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(informationActionButton))
        infoButton.image = UIImage(systemName: "info.circle")
        
        self.navigationItem.rightBarButtonItems = [reportButton, infoButton]
    }
    
    @objc func reportActionButton() {
        
    }

    @objc func informationActionButton() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let informationAlert = storyboard.instantiateViewController(withIdentifier: "informationAlert") as! CustomAlertViewController
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
