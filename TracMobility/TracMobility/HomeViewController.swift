//
//  HomeViewController.swift
//  TracMobility
//
//  Created by sabaz shereef on 05/02/21.
//

import UIKit
import SideMenu
import GoogleMaps
import CoreLocation
class HomeViewController: UIViewController, CLLocationManagerDelegate {
    
    let locationManger = CLLocationManager()
    var mapView = GMSMapView()
    var menu: SideMenuNavigationController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let leftVc  = self.storyboard?.instantiateViewController(identifier: "TableViewController") as! TableViewController
        
        menu = SideMenuNavigationController(rootViewController: leftVc)
        menu?.leftSide = true
        
        SideMenuManager.default.leftMenuNavigationController = menu
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
        
        configureMap()
        setupButton()
    }
    
    
    @IBAction func didTapMenu() {
        present(menu!, animated: true)
    }
    
    func configureMap()  {
        
        locationManger.requestWhenInUseAuthorization()
        locationManger.startUpdatingLocation()
        locationManger.delegate = self
        
    }
    
    override func viewDidLayoutSubviews() {
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 20))
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "App Logo")
        imageView.image = image
        navigationItem.titleView = imageView
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        let cordinate = location.coordinate
        let camera = GMSCameraPosition.camera(withLatitude: cordinate.latitude, longitude: cordinate.longitude, zoom: 6.0)
        mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
        view.insertSubview(mapView, at: 0)
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: cordinate.latitude, longitude: cordinate.longitude)
        
        
        marker.map = mapView
        
        
        
        
    }
    
    @IBAction func inboxButton(_ sender: Any) {
        alert()
        
    }
    
    @IBAction func Logout(_ sender: Any) {
        navigationController!.popViewController(animated: true)
    }
    
    @objc func alert() {
        
        let alertController = UIAlertController(title: "Alert!", message: "Service Under Maintenance", preferredStyle: UIAlertController.Style.alert)
        
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default,handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    func setupButton() {
        
        let button = UIButton(type: .system)
        button.setTitle("Scan To Unlock", for: .normal)
        button.backgroundColor = .black
        
        button.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(button, at: 1)
        button.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        
        button.addTarget(self, action: #selector(alert), for: .touchUpInside)
    }
    
}
