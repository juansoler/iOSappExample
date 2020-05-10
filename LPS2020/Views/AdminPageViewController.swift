//
//  AdminPageViewController.swift
//  LPS2020
//
//  Created by Juan Soler Marquez on 05/01/2020.
//  Copyright © 2020 ual. All rights reserved.
//

import UIKit

class AdminPageViewController: UIViewController {
    
    @IBAction func BtnLogout(_ sender: Any) {
        let loginManager = FirebaseAuthManager()
        
        loginManager.signOut()
    }
        
    @IBAction func BtnUser(_ sender: Any) {
        AppDelegate.usermode = true
        self.performSegue(withIdentifier: "UserMode", sender: nil)
    }
    
    @IBAction func btnCrearCaso(_ sender: Any) {
        AppDelegate.usermode = false
        self.performSegue(withIdentifier: "MostrarCasos", sender: nil)
    }
    var labelTemp:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.navigationItem.title = labelTemp
        self.navigationItem.title = AppDelegate.username

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if segue.identifier == "MostrarCasos"{
            let casesTableViewController = segue.destination as! CasesTableViewController
            casesTableViewController.admin = true
                
        }
         if segue.identifier == "UserMode"{
            if let navigationController = segue.destination as? UINavigationController,
                let destinationNavigationController = navigationController.viewControllers.first as? CasesTableViewController {
                destinationNavigationController.admin = false
                
            }
            
            let destinationNavigationController = segue.destination as! UINavigationController
            
            
            _ = destinationNavigationController.topViewController
            
        }
       
        
        
    }
}
