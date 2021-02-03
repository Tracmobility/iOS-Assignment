//
//  SideMenuController.swift
//  tracmobility
//
//  Created by David K on 2/3/21.
//

import UIKit
import SideMenu
import Auth0

class SideMenuController: UITableViewController {
    
    var email: String = UserDefaults.standard.string(forKey: "email")!
    var username: String = UserDefaults.standard.string(forKey: "username")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.tableFooterView = UIView.init(frame: CGRect.zero)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            
            let profileCell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as! ProfileCell
            profileCell.emailLabel.text = email
            profileCell.nameLabel.text = username
            return profileCell
            
        } else {
           
            let menuItemCell = tableView.dequeueReusableCell(withIdentifier: "MenuItemCell", for: indexPath) as! MenuItemCell
            
            if indexPath.row == 1 {
                menuItemCell.iconImage.image = UIImage.init(named: "mapIcon")
                menuItemCell.titleLabel.text = "Google Map"
                
            } else if indexPath.row == 2 {
                menuItemCell.iconImage.image = UIImage.init(named: "mapIcon")
                menuItemCell.titleLabel.text = "Mapbox"
                
            } else if indexPath.row == 3 {
                menuItemCell.iconImage.image = UIImage.init(named: "logout")
                menuItemCell.titleLabel.text = "Log Out"
            }
            
            return menuItemCell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension;
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 1 {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "GoogleMap"), object: nil)
            
        } else if indexPath.row == 2 {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Mapbox"), object: nil)
            
        } else if indexPath.row == 3 {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Logout"), object: nil)
        }
        
        let navController = self.navigationController as! SideMenuNavigationController
        navController.dismiss(animated: true, completion: nil)
    }
}
