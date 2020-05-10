//
//  InitViewController.swift
//  LPS2020
//
//  Created by Juan Soler Marquez on 03/01/2020.
//  Copyright © 2020 ual. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class InitViewController: UIViewController {
    @IBOutlet weak var versionlbl: UILabel!
    
   
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        
        
        #if VER2
            versionlbl.text = "Version 2.0"
        #else
            versionlbl.text = "Version 1.0"
        #endif
    }
    
    /*override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if UserDefaults.standard.bool(forKey: "loggedin") {
            // User is signed in.
            // ...
            print("user signed")
            self.performSegue(withIdentifier: "MainPage", sender: nil)
            
        } else {
            
            print("no user is sign in")
            // No user is signed in.
            // ...
        }
    }
    
   */
    
    @IBOutlet weak var usernameText: UITextField!
    
    @IBOutlet weak var passwordText: UITextField!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "MainPage"{
            /*let destinationNavigationController = segue.destination as! UINavigationController
            let targetController = destinationNavigationController.topViewController
            */
            
            if let navigationController = segue.destination as? UINavigationController,
                let casesTableViewController = navigationController.viewControllers.first as? CasesTableViewController {
                casesTableViewController.admin = false
            }
            
            print("prueba")
            //MainViewController.school = selectedSchool
        }
        
        if segue.identifier == "AdminPage"{
            
            if let navigationController = segue.destination as? UINavigationController,
                       let adminPageViewController = navigationController.viewControllers.first as? AdminPageViewController {
                adminPageViewController.labelTemp = usernameText.text
                   }
        }

        
       
        
    }
    
    @IBAction func BtnLogin(_ sender: Any) {
        let loginManager = FirebaseAuthManager()
        guard let username = usernameText.text, let password = passwordText.text else { return }
        
        
        loginManager.signIn(email: username, pass: password) {[weak self] (success) in
            if (success){
                
                
                let split = username.components(separatedBy: "@")
                
                
                
                AppDelegate.username = split[0]
                UserDefaults.standard.set(split[0], forKey: "username")

                
                let items = username.components(separatedBy: "@")
                
                let ref = Database.database().reference(withPath: "members").child(items[0]).child("admin")
                UserDefaults.standard.set(true, forKey: "loggedin")
                
               
                ref.observe(.value, with: { snapshot in
                
                    if !snapshot.exists() {
                        self?.performSegue(withIdentifier: "MainPage", sender: nil)
                        AppDelegate.admin = false
                        UserDefaults.standard.set(false, forKey: "admin")
                        UserDefaults.standard.synchronize()
                        
                    }else{
                        if (snapshot.value as! Bool == true){
                            
                            AppDelegate.admin = true
                            UserDefaults.standard.set(true, forKey: "admin")
                            UserDefaults.standard.synchronize()
                            self?.performSegue(withIdentifier: "AdminPage", sender: nil)
                            
                        }else{
                            self?.performSegue(withIdentifier: "MainPage", sender: nil)
                        }
                    }
                    
                   
                  
                });
                

                /*ref.observe(.value, with: { snapshot in
                    var newItems: [Member] = []
                    for child in snapshot.children {
                        if let snapshot = child as? DataSnapshot,
                            let sampleItem = Member(snapshot: snapshot) {
                            newItems.append(sampleItem)
                        }
                    }
                    
                    self.items = newItems
                    self.tableView.reloadData()
                })
 */
              
                
                //let vc = MainViewController()
                //self?.present(vc, animated: true)
            }else {
                self?.showPopup(isSuccess: false)


            }
            
        }
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
   

}


extension InitViewController {
    
    func showPopup(isSuccess: Bool) {
        let successMessage = "User was sucessfully logged in."
        let errorMessage = "Something went wrong. Please try again"
        let alert = UIAlertController(title: isSuccess ? "Success": "Error", message: isSuccess ? successMessage: errorMessage, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Done", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}


