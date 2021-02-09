//
//  TableViewController.swift
//  TracMobility
//
//  Created by sabaz shereef on 05/02/21.
//

import UIKit
import Auth0
class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var myTableList: UITableView!
    let home = HomeViewController()
    var profileInfo = [String]()
    var imageArray = [String]()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        retrievedata()
        
    }
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        imageArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myTableList.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SideMenuTableViewCell
        cell.infoLabel.text = profileInfo[indexPath.row]
       
        cell.logoImage.image = UIImage(named: imageArray[indexPath.row])
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if profileInfo[indexPath.row] == "Settings" {
            home.alert()
        }
       
    }
    
    func retrievedata() {
        let credentialsManager = CredentialsManager(authentication: Auth0.authentication())
        
        credentialsManager.credentials { error, credentials in
            guard error == nil, let credentials = credentials else {
                return print("Failed with \(String(describing: error))")
            }
           
            
            Auth0
                .authentication()
                .userInfo(withAccessToken: credentials.accessToken ?? "")
                .start { [self] result in
                    switch result {
                    case .success(let profile):
                        
                        self.profileInfo.append(profile.nickname ?? "Not Found")
                        self.profileInfo.append(profile.name ?? "Not Found")
                        profileInfo.append("Settings")
                        
                        imageArray = ["Profile","Email", "Settings"]
                        
                        DispatchQueue.main.sync {
                            myTableList.reloadData()
                        }
                        
                    case .failure(let error):
                        print("Failed with \(error)")
                    }
                }
        }
    }
}
