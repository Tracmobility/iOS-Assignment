//
//  DashboardViewController.swift
//  TracMobility
//
//  Created by Shalini on 20/02/21.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation

class DashboardViewController: UIViewController {
    
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var inboxButton: UIButton!
    @IBOutlet weak var scanToUnlock: UIButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var sideExtra: UIButton!
    
    @IBAction func sideExtraViewTapped(_ sender: Any) {
        
        UIView.animate(withDuration: 0.4, delay: 0.8, options: [.transitionFlipFromRight], animations: { DispatchQueue.main.async { self.containerView.isHidden = true
                        self.sideExtra.isHidden = true }}, completion: nil)
    }
    
    @IBAction func inboxButtonTapped(_ sender: Any) {
        
        CustomAlertView.sharedInstance.okAlert(self, "Note", "This feature is not available at the moment!", "OK", .default, alertStyle: .alert)
    }
    
    @IBAction func menuButtonTapped(_ sender: Any) {
        
        UIView.animate(withDuration: 0.4, delay: 0.8, options: [.transitionFlipFromLeft], animations: { DispatchQueue.main.async { self.containerView.isHidden = false
                        self.sideExtra.isHidden = false }}, completion: nil)
    }
    
    @IBAction func scanToUnlockTapped(_ sender: Any) {
        
        getLocation(){ latitude, longitude, location in
            
            self.loadMap(latitude, longitude, location)
        }
    }
    
    var latitude: Double?
    var longitude: Double?
    var located_location = String()
    let locationManager = CLLocationManager()
    var locationMarker = GMSMarker()
    var markerIcon = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async {
            self.sideExtra.isHidden = true
            self.containerView.isHidden = true
        }
        self.containerView.layer.masksToBounds = true
        
        /// `check location permission`
        guard locationPermission() else {
            
            self.locationPermissionAlert("TracMobility does not have access to your location. To enable access, tap Settings and turn on location.")
            return
        }
        
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        
        //start location
        startTrackingLocation()
        getLocation(){ latitude, longitude, location in
            
            self.loadMap(latitude, longitude, location)
        }
        
        //set up marker
        if let image = UIImage(named: "Marker") {
            markerIcon = resizeImage(image: image, targetSize: CGSize.init(width: 50, height: 50))
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    //resize the image
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage ?? UIImage()
    }
    
    //loadMap
    func loadMap(_ latitude: Double?,_ longitude: Double?,_ location: String?) {
        
        DispatchQueue.main.async { [self] in
            
            let camera = GMSCameraPosition.camera(withLatitude: latitude ?? 0.0, longitude: longitude ?? 0.0, zoom: 14)
            self.mapView.animate(to: camera)
            
            self.locationMarker.position = CLLocationCoordinate2D(latitude: latitude ?? 0.0, longitude: longitude ?? 0.0)
            
            self.locationMarker.title = location
            self.locationMarker.icon = .some(self.markerIcon)
            self.locationMarker.appearAnimation = .pop
            self.locationMarker.map = self.mapView
        }
    }
}

//MARK: `Location Permission & Delegates`
extension DashboardViewController: CLLocationManagerDelegate {
    
    //init location manager
    func startTrackingLocation() {
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestLocation()
        locationManager.startUpdatingLocation()
    }
    
    //get latitude, longitude and location
    func getLocation(completion: @escaping (_ latitude: Double?,_ longitude: Double?,_ location: String?) -> ()) {
        
        let coordinate = CLLocation(latitude: self.latitude ?? 0.0, longitude: self.longitude ?? 0.0)
        geoCoder(coordinate) {
            completion(self.latitude, self.longitude, self.located_location)
        }
    }
    
    //stop tracking the location
    func stopTracking() {
        locationManager.stopUpdatingLocation()
    }
    
    //location permission
    func locationPermission() -> Bool {
        
        if CLLocationManager.locationServicesEnabled() {
            let locationStatus = CLLocationManager.authorizationStatus()
            
            switch locationStatus {
            case .authorized, .authorizedWhenInUse:
                NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
                return true
                
            case .restricted,.denied:
                stopTracking()
                NotificationCenter.default.addObserver(self, selector: #selector(self.checkPermissionForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
                return false
                
            case .notDetermined:
                locationManager.delegate = self
                locationManager.requestWhenInUseAuthorization()
                
                NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
                
                return true
                
            default:
                return false
            }
        }
        return false
    }
    
    @objc func checkPermissionForeground() {
        
        DispatchQueue.main.async(execute: {
            
            if !self.locationPermission() {
                self.locationPermissionAlert("TracMobility does not have access to your location. To enable access, tap Settings and turn on location.")
            }
        })
    }
    
    //if the permission is denied, redirect to settings.
    func locationPermissionAlert(_ titleText: String){
        let alertController = UIAlertController(title: titleText, message: nil, preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Settings", style: .default){ (_) -> Void in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url as URL)
                }
            }
        }
        alertController.addAction(settingsAction)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancel)
        
        OperationQueue.main.addOperation {
            self.present(alertController, animated: true, completion:nil)
        }
    }
    
    func geoCoder(_ coordinate: CLLocation, completion: @escaping() ->()) {
        
        let geocoder: CLGeocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(coordinate, completionHandler: {(response, error) -> Void in
            
            if let address = response?.first {
                
                if address.subLocality != nil && address.locality != nil && address.country != nil {
                    self.located_location = "\(address.subLocality!), " + "\(address.locality!), " + "\(address.country!)"
                } else if address.locality != nil && address.country != nil {
                    self.located_location = "\(address.locality!), " + "\(address.country!)"
                } else if address.locality != nil {
                    self.located_location = address.locality!
                } else {
                    self.located_location = ""
                }
                completion()
            }
        })
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let userCllocation = locations[0] as CLLocation
        latitude = userCllocation.coordinate.latitude
        longitude = userCllocation.coordinate.longitude
        
        let coordinate = CLLocation(latitude: self.latitude ?? 0.0, longitude: self.longitude ?? 0.0)
        geoCoder(coordinate) { }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        checkPermissionForeground()
    }
}

//MARK: `Map Delegates`
extension DashboardViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        locationMarker = marker
        return false
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
    }
    
    // take care of the close event
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        latitude = coordinate.latitude
        longitude = coordinate.longitude
        
        getLocation(){ latitude, longitude, location in
            
            self.loadMap(latitude, longitude, location)
        }
    }
}
