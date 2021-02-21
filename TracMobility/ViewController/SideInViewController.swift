//
//  SideInViewController.swift
//  TracMobility
//
//  Created by Shalini on 20/02/21.
//

import UIKit

class SideInViewController: UIViewController {
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var emailID: UILabel!
    @IBOutlet weak var mobileNumber: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var sideMenuTableView: UITableView!
    
    var menuItems:[Menu] = [.Rides, .Wallet, .Membership, .FreeRides, .ReferAndEarn, .Settings , .Version, .Logout]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sideMenuTableView.tableFooterView = UIView()
        if let userInfo = UserDefaults.standard.value(forKey: "userInfo") as? [String : String] {
            userName.text = "\((userInfo["FirstName"] ?? "Trac Mobility") + " " + (userInfo["LastName"] ?? ""))"
            mobileNumber.text = "\((userInfo["CountryCode"] ?? "🇬🇧+44") + " " + (userInfo["PhoneNumber"] ?? "7743405150"))"
            emailID.text = userInfo["Email"] ?? "tracmobility@gmail.com"
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.sideMenuTableView.reloadData()
    }
    
    /// `LogOut`
    func logOutTapped() {
        
        
        let confirmationAlert = UIAlertController(title: "Are you sure", message: "You want to logout?", preferredStyle: .alert)
        
        let confirmDelete = UIAlertAction(title: "Logout", style: .destructive) { _ in
            
//            Authentication().logout { done in
//                if done {
                    
                    /// `Delete stored user Info & access token`
                    UserDefaults.standard.removeObject(forKey: "userInfo")
                    UserDefaults.standard.removeObject(forKey: "accessToken")
                    
                    DispatchQueue.main.async {
                        
                        // redirect the user to sign up screen
                        let storyboard = UIStoryboard(name:"Main", bundle:nil).instantiateViewController(withIdentifier: "navigationControllerID") as! UINavigationController
                        storyboard.modalPresentationStyle = .fullScreen
                        self.present(storyboard, animated: true, completion:nil)
                    }
//                } else {
//                    CustomAlertView.sharedInstance.okAlert(self, "Error", "Sorry, something went wrong. Please try after some time!", "OK", .default, alertStyle: .alert)
//                }
        }
        confirmationAlert.addAction(confirmDelete)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        confirmationAlert.addAction(cancel)
        
        OperationQueue.main.addOperation {
            self.present(confirmationAlert, animated: true)
        }
    }
}

//MARK: `UITableview Delegates`
extension SideInViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        
        let menu = menuItems[indexPath.row]
        cell.textLabel?.text = menu.rawValue
        
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.textAlignment = .left
        cell.textLabel?.textColor = UIColor.black
        
        if menu.rawValue == Menu.Logout.rawValue {
            
            cell.accessoryType = .none
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.textColor = UIColor.red
            
            //tap gesture for logout
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didSelect))
            cell.tag = indexPath.row
            cell.addGestureRecognizer(tapGesture)
            
        } else if menu.rawValue == Menu.Version.rawValue {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    @objc func didSelect(tapGesture: UITapGestureRecognizer) {
        
        let indexPath = IndexPath(row: (tapGesture.view?.tag ?? 0), section:0)
        let menu = menuItems[indexPath.row]
        if menu.rawValue == Menu.Logout.rawValue {
            logOutTapped()
        }
    }
}

