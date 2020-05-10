//
//  MainViewController.swift
//  LPS2020
//
//  Created by Juan Soler Marquez on 03/01/2020.
//  Copyright © 2020 ual. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase


class MainViewController: UIViewController, UITableViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func BtnLogout(_ sender: Any) {
        
    }
    
    
    @IBOutlet weak var CasesTableView: UITableView!
    
    let ref = Database.database().reference(withPath: "case-items")
    let usersRef = Database.database().reference(withPath: "online")

    var databaseHandle: DatabaseHandle?
    var items: [Case] = []
    var user: User!

    

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UITableView Delegate methods
    
}
