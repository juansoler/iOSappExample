//
//  Switcher.swift
//  LSP2020
//
//  Created by Juan Soler Marquez on 13/01/2020.
//  Copyright © 2020 ual. All rights reserved.
//

import Foundation
import UIKit

class Switcher {
    
    static func updateRootVC(){
        
        let status = UserDefaults.standard.bool(forKey: "loggedin")
        AppDelegate.admin = UserDefaults.standard.bool(forKey: "admin")
        AppDelegate.username = UserDefaults.standard.string(forKey: "username")
        var rootVC : UIViewController?
        
        print(status)
        
        
        if(status == true){
            if AppDelegate.admin! {
                rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AdminNavigation") as! UINavigationController
                rootVC?.modalPresentationStyle = .overCurrentContext
            }else {
                rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UserNavigation") as! UINavigationController
            }
            
        }else{
            rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainPage") as! InitViewController
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = rootVC
        
    }
    
}
