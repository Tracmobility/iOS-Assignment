//
//  Authentication.swift
//  TracMobility
//
//  Created by Shalini on 21/02/21.
//

import UIKit
import Auth0

class Authentication: NSObject {
    
    func signUp(completion: @escaping(Bool) -> ()) {
        guard let clientInfo = plistValues(bundle: Bundle.main) else { return }
        
            Auth0
                .webAuth()
                .scope("openid profile")
                .audience("https://" + clientInfo.domain + "/userinfo")
                .start {
                    switch $0 {
                    case .failure(let error):
                        print("Error: \(error)")
                        completion(false)
                        
                    case .success(let credentials):
                        guard let accessToken = credentials.accessToken else { return }
                        UserDefaults.standard.setValue(accessToken, forKey: "accessToken")
                        completion(true)
                    }
                }
    }
    
    //logout
    func logout(completion: @escaping(Bool) -> ()) {
        
        Auth0
            .webAuth()
            .clearSession(federated:false){
                completion($0)
            }
    }
    
    //get values from plist
    func plistValues(bundle: Bundle) -> (clientId: String, domain: String)? {
        guard
            let path = bundle.path(forResource: "Auth0", ofType: "plist"),
            let values = NSDictionary(contentsOfFile: path) as? [String: Any]
        else {
            print("Missing Auth0.plist file with 'ClientId' and 'Domain' entries in main bundle!")
            return nil
        }
        
        guard
            let clientId = values["ClientId"] as? String,
            let domain = values["Domain"] as? String
        else {
            print("Auth0.plist file at \(path) is missing 'ClientId' and/or 'Domain' entries!")
            print("File currently has the following entries: \(values)")
            return nil
        }
        return (clientId: clientId, domain: domain)
    }
}

