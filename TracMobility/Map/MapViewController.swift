//
//  MapViewController.swift
//  TracMobility
//
//  Created by sania zafar on 17/02/2021.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var markerVerticalConstraint: NSLayoutConstraint!
    @IBOutlet weak var menuView: UIView!
    let locationManager = CLLocationManager()
    var location = CLLocationCoordinate2D()
    

    // MARK: - View LifeCycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupMapServices()
        self.configLocationServices()
        self.menuView.isHidden = true
    }
    
    
    // MARK: - Private
    
    private func reverseGeocode(coordinate: CLLocationCoordinate2D) {
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(coordinate) { [weak self] (response, error) in
            self?.location = coordinate
            UIView.animate(withDuration: 0.25) {
                self?.markerVerticalConstraint.constant = -30
                self?.view.layoutIfNeeded()
            }
        }
    }
    
    private func setupMapServices() {
        locationManager.delegate = self
        mapView.delegate = self
        locationManager.requestLocation()
        mapView.isMyLocationEnabled = true
    }
    
    func configLocationServices() {
        locationManager.delegate = self
        let status  = CLLocationManager.authorizationStatus()
        if status == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        } else if status == .denied || status == .restricted {
            self.showLocationSetUpAlert(false)
        } else {
            if #available(iOS 14.0, *) {
                if locationManager.accuracyAuthorization == .reducedAccuracy {
                    self.showLocationSetUpAlert(true)
                } else {
                    self.updateLocationManagerAttributes()
                }
            } else {
                self.updateLocationManagerAttributes()
            }
        }
    }
    
    func showLocationSetUpAlert(_ forIos14Later: Bool) {
        let alert = UIAlertController(title: forIos14Later ? "Location Services Disabled" : "Precise Location Disabled", message: "Let us find your location by allowing us access from your phone settings", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Settings", style: .default) { (okAction) in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (cancelAction) in
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    func updateLocationManagerAttributes() {
        self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        self.locationManager.distanceFilter = 500
        self.locationManager.startUpdatingLocation()
    }
    
    
    // MARK: - IBAction
    
    @IBAction func openCloseMenu(_ sender: UIButton) {
        ///can add animations to show/hide menu view
        self.menuView.isHidden = sender.tag == 1
    }
    
}


// MARK: - CLLocationManagerDelegate

extension MapViewController: CLLocationManagerDelegate {
    
    
    // MARK: - CLLocationManager Delegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations.last
        let camera = GMSCameraPosition.camera(withLatitude: userLocation!.coordinate.latitude,
                                              longitude: userLocation!.coordinate.longitude, zoom: 16.0)
        if self.location.latitude != 0 , self.location.longitude != 0  {
            mapView.animate(to: GMSCameraPosition.camera(withLatitude: self.location.latitude,
                                                         longitude: self.location.longitude, zoom: 16.0))
        } else {
            mapView.animate(to: camera)
        }
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            self.updateLocationManagerAttributes()
        } else {
            self.showLocationSetUpAlert(false)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    @available(iOS 14.0, *)
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print(CLLocationManager.authorizationStatus())
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse, .authorizedAlways:
            if locationManager.accuracyAuthorization == .reducedAccuracy {
                self.showLocationSetUpAlert(true)
            } else {
                self.updateLocationManagerAttributes()
            }
        default:
            self.showLocationSetUpAlert(true)
        }
        switch manager.accuracyAuthorization {
        case .fullAccuracy:
            self.updateLocationManagerAttributes()
        default:
            self.showLocationSetUpAlert(true)
        }
    }
    
}


// MARK: - GMSMapViewDelegate

extension MapViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        reverseGeocode(coordinate: position.target)
        
    }
    
}
