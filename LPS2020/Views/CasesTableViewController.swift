//
//  CasesTableViewController.swift
//  LPS2020
//
//  Created by Juan Soler Marquez on 03/01/2020.
//  Copyright © 2020 ual. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class CasesTableViewController: UITableViewController {
    
    @IBOutlet weak var BtnLogout: UIBarButtonItem!
    
    @IBAction func BtnActionLogout(_ sender: UIBarButtonItem) {
        let loginManager = FirebaseAuthManager()

        loginManager.signOut()
        // falta el self dismiss
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.allowsMultipleSelectionDuringEditing = false
        
        //self.navigationController?.navigationItem.backBarButtonItem?.tintColor = UIColor.black
        self.navigationItem.title = AppDelegate.username

        
        if (!AppDelegate.usermode!){
            //self.tableView.allowsSelection = false
            let ref = Database.database().reference(withPath: "case-items")
            ref.queryOrdered(byChild: "completed").observe(.value, with: { snapshot in
                var newItems: [Case] = []
                for child in snapshot.children {
                    if let snapshot = child as? DataSnapshot,
                        let caseItem = Case(snapshot: snapshot) {
                        newItems.append(caseItem)
                    }
                }
                
                self.items = newItems
                self.tableView.reloadData()
            })
            
        }else {
            
            BtnAddCaseOutlet.isEnabled = AppDelegate.admin!
            
            let ref = Database.database().reference(withPath: "members")
            ref.child(AppDelegate.username!).child("cases").queryOrdered(byChild: "completed").observe(.value, with: { snapshot in
                var newItems: [Case] = []
                for child in snapshot.children {
                    if let snapshot = child as? DataSnapshot,
                        let caseItem = Case(snapshot: snapshot) {
                        //print(caseItem.name)
                        newItems.append(caseItem)
                    }
                }
                
                self.items = newItems
                self.tableView.reloadData()
            })
            
        }
        

        Auth.auth().addStateDidChangeListener { auth, user in
            guard let user = user else { return }
            self.user = User(authData: user)
            AppDelegate.user = self.user
            let currentUserRef = self.usersRef.child(self.user.uid)
            currentUserRef.setValue(self.user.email)
            currentUserRef.onDisconnectRemoveValue()
        }
       
       
        
        usersRef.observe(.value, with: { snapshot in
            if snapshot.exists() {
                //self.userCountBarButtonItem?.title = snapshot.childrenCount.description
            } else {
                //self.userCountBarButtonItem?.title = "0"
            }
        })
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
   
    
    let usersRef = Database.database().reference(withPath: "online")
    
    var databaseHandle: DatabaseHandle?
    var items: [Case] = []
    var user: User!
    var caseItem : Case?
    var member: String?
    var admin: Bool?
    
    @IBAction func BtnAddCase(_ sender: Any) {
        self.performSegue(withIdentifier: "AddCase", sender: nil)

    }
    
    @IBOutlet weak var BtnAddCaseOutlet: UIBarButtonItem!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

         let name = caseItem?.name
        
        
        
         if segue.identifier == "SampleList"{
             let sampleListTableViewController = segue.destination as! SampleListTableViewController
             sampleListTableViewController.caseSelected = caseItem
             sampleListTableViewController.ref =  Database.database().reference(withPath: "case-items").child(name!.lowercased()).child("samples")
         }
        
        if segue.identifier == "EditTeam"{
            let allMembersTableViewController = segue.destination as! AllMembersTableViewController
            allMembersTableViewController.ref =  Database.database().reference(withPath: "case-items").child(name!.lowercased()).child("members")
            
            allMembersTableViewController.refMember = Database.database().reference(withPath: "members")
            allMembersTableViewController.usermode = true
            allMembersTableViewController.caseItem = caseItem

        }

        
       
        
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CaseCell", for: indexPath) as! CaseUserTableViewCell
        let caseItem = items[indexPath.row]
        //print("cellForRowAt" +  caseItem.name)
        
        Database.database().reference(withPath: "case-items").child(caseItem.name.lowercased()).child("samples").observe(.value, with: { snapshot in
            if snapshot.exists() {
                //cell.detailTextLabel?.text  = snapshot.childrenCount.description
                
                cell.caseNameLbl!.text = caseItem.name
                cell.dateLbl!.text = caseItem.fecha
                cell.numSamplesLbl!.text = snapshot.childrenCount.description
            } else {
                cell.caseNameLbl!.text = caseItem.name
                cell.dateLbl!.text = caseItem.fecha
                cell.numSamplesLbl!.text = "0"
            }
        })

        
        
        /* 2Color rows
        if indexPath.row % 2 != 0 {
            cell.backgroundColor = UIColor.white
        }*/
        //cell.detailTextLabel?.text = caseItem.addedByUser
        
        toggleCellCheckbox(cell, isCompleted: caseItem.completed)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let caseItem = items[indexPath.row]
            caseItem.ref?.removeValue()
            Database.database().reference(withPath: "case-items").child(caseItem.name.lowercased()).removeValue()
            
            let ref = Database.database().reference(withPath: "members")
            ref.observe(.value, with: { snapshot in
                for child in snapshot.children {
                    
                    if let snapshot = child as? DataSnapshot,
                        let memberItem = Member(snapshot: snapshot) {
                        print(memberItem.name)
                        let split = memberItem.name.components(separatedBy: "@")
                        ref.child(split[0]).child("cases").child(caseItem.name.lowercased()).removeValue()
                    }
                }
                
               
            })
        }
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 75 //or whatever you need
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(self.tableView.allowsSelection){
            guard tableView.cellForRow(at: indexPath) != nil else { return }
            caseItem = items[indexPath.row]
            
            
            if (!AppDelegate.usermode!){
                self.performSegue(withIdentifier: "EditTeam", sender: nil)
            }else{
                self.performSegue(withIdentifier: "SampleList", sender: nil)
            }
        }
        

        
        /*let toggledCompletion = !groceryItem.completed
        toggleCellCheckbox(cell, isCompleted: toggledCompletion)
        groceryItem.ref?.updateChildValues([
            "completed": toggledCompletion
            ])
 */
    }
    
    func toggleCellCheckbox(_ cell: UITableViewCell, isCompleted: Bool) {
        if !isCompleted {
            cell.accessoryType = .none
            cell.textLabel?.textColor = .black
            cell.detailTextLabel?.textColor = .black
        } else {
            cell.accessoryType = .checkmark
            cell.textLabel?.textColor = .gray
            cell.detailTextLabel?.textColor = .gray
        }
    }
    
    @IBAction func addButtonDidTouch(_ sender: AnyObject) {
        
        self.performSegue(withIdentifier: "AddCase", sender: nil)
        // FALTA POR HACER _  SI ES ADMIN QUE VAYA A LA VISTA AGREGAR EQUIPO DE LA VISTA ADMIN
        
        
        /*let alert = UIAlertController(title: "Grocery Item",
                                      message: "Add an Item",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            guard let textField = alert.textFields?.first,
                let text = textField.text else { return }
            
            
            let groceryItem = Case(name: text,
                                          addedByUser: self.user.email,
                                          completed: false)
            
            let groceryItemRef = self.ref.child(text.lowercased())
            
            
            
            groceryItemRef.setValue(groceryItem.toAnyObject())
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel)
        
        alert.addTextField()
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
 */
        
    }
    
   

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
