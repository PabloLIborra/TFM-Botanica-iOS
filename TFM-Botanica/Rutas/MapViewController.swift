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
    
    @IBOutlet var mapView: GMSMapView!
    var tappedMarker : GMSMarker?
    var customInfoWindow : CustomInfoWindow?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapView.delegate = self
        self.tappedMarker = GMSMarker()
        self.customInfoWindow = CustomInfoWindow().loadView()
        
        let camera = GMSCameraPosition.camera(withLatitude: 38.385750, longitude: -0.514250, zoom: 15)
        self.mapView.camera = camera
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: 38.385750, longitude: -0.514250)
        marker.title = "Universidad de Alicante"
        marker.snippet = "Alicante"
        marker.map = mapView
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
    
//    MARK: Functions
    
    @objc func buttonAction() {
        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "activityNavigation") as! UINavigationController
        viewController.modalPresentationStyle = .automatic
        self.present(viewController, animated: true, completion: nil)
    }
}
