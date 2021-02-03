//
//  HomeController.swift
//  tracmobility
//
//  Created by David K on 2/3/21.
//

import UIKit
import GoogleMaps
import Mapbox
import Auth0

class HomeController: UIViewController, MGLMapViewDelegate {
    
    @IBOutlet weak var mapContainer: UIView!
    
    var googleMapView: GMSMapView?
    var mapboxMapView: MGLMapView?
    
    let markers = [
        ["lat": 51.507359, "lng": -0.136439],
        ["lat": 51.527359, "lng": -0.106439],
        ["lat": 51.547359, "lng": -0.166439]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.logout), name: NSNotification.Name(rawValue: "Logout"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.showGoogleMap), name: NSNotification.Name(rawValue: "GoogleMap"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.showMapbox), name: NSNotification.Name(rawValue: "Mapbox"), object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setupGoogleMap()
    }
   
    func setupGoogleMap() {
        let camera = GMSCameraPosition.camera(withLatitude: 51.507359, longitude: -0.136439, zoom: 12.0)
        googleMapView = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: mapContainer.frame.width, height: mapContainer.frame.height), camera: camera)
        mapContainer.addSubview(googleMapView!)
        
        for markerData in markers {
            
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: markerData["lat"]!, longitude: markerData["lng"]!)
            marker.title = "London"
            marker.snippet = "United Kingdom"
            marker.icon = UIImage.init(named: "marker")
            marker.map = googleMapView
        }
    }
    
    func setupMapboxMap() {
        mapboxMapView = MGLMapView(frame: CGRect(x: 0, y: 0, width: mapContainer.frame.width, height: mapContainer.frame.height))
        mapboxMapView!.delegate = self
        mapboxMapView!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapboxMapView!.setCenter(CLLocationCoordinate2D(latitude: 51.507359, longitude: -0.136439), zoomLevel: 10, animated: false)
        mapContainer.addSubview(mapboxMapView!)
    }
    
    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        var index = 0;
        
        for markerData in markers {
            // Create point to represent where the symbol should be placed
            let point = MGLPointAnnotation()
            point.coordinate = CLLocationCoordinate2D(latitude: markerData["lat"]!, longitude: markerData["lng"]!)
             
            // Create a data source to hold the point data
            let shapeSource = MGLShapeSource(identifier: "marker-source-\(index)", shape: point, options: nil)
             
            // Create a style layer for the symbol
            let shapeLayer = MGLSymbolStyleLayer(identifier: "marker-style-\(index)", source: shapeSource)
             
            let image = UIImage.init(named: "marker")
            // Add the image to the style's sprite
            style.setImage(image!, forName: "marker")
             
            // Tell the layer to use the image in the sprite
            shapeLayer.iconImageName = NSExpression(forConstantValue: "marker")
             
            // Add the source and style layer to the map
            style.addSource(shapeSource)
            style.addLayer(shapeLayer)
            
            index = index + 1
        }
    }
    
    @objc private func logout(notification: NSNotification) {
        let credentialsManager = CredentialsManager(authentication: Auth0.authentication())
        _ = credentialsManager.clear()
        
        performSegue(withIdentifier: "logoutSegue", sender: self)
    }
    
    @objc private func showGoogleMap(notification: NSNotification) {
        if mapboxMapView != nil {
            mapboxMapView!.removeFromSuperview()
            mapboxMapView = nil
        }
        
        if googleMapView == nil {
            setupGoogleMap()
        }
    }
    
    @objc private func showMapbox(notification: NSNotification) {
        if googleMapView != nil {
            googleMapView!.removeFromSuperview()
            googleMapView = nil
        }
        
        if mapboxMapView == nil {
            setupMapboxMap()
        }
    }
}
