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

class SampleListTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.allowsMultipleSelectionDuringEditing = false
        
        BtnTeamEdit.isEnabled = AppDelegate.admin!
        
        self.title = caseSelected?.name

        ref?.queryOrdered(byChild: "completed").observe(.value, with: { snapshot in
            var newItems: [Sample] = []
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                    let sampleItem = Sample(snapshot: snapshot) {
                    newItems.append(sampleItem)
                    //print(sampleItem.name)
                }
            }
            
            self.items = newItems
            self.tableView.reloadData()
        })
        
        Auth.auth().addStateDidChangeListener { auth, user in
            guard let user = user else { return }
            self.user = User(authData: user)
            
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
    
    var ref: DatabaseReference?
        
    
    
    let usersRef = Database.database().reference(withPath: "online")
    
    var databaseHandle: DatabaseHandle?
    
    var items: [Sample] = []
    var user: User!
    var sampleItem : Sample?
    var caseSelected: Case?
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let name = caseSelected?.name
        
        if segue.identifier == "ShowSample"{
            let addSampleViewController = segue.destination as! AddSampleViewController
            addSampleViewController.sampleItem = sampleItem
            addSampleViewController.ref =  Database.database().reference(withPath: "case-items").child(name!.lowercased()).child("samples").child((sampleItem?.name.lowercased())!)
            
            
            
            print("showCase")
        }
        
        if segue.identifier == "ShowMembers"{
            /* print("showMembers")
            print(name!)
            let membersTableViewController = segue.destination as! MembersTableViewController
            membersTableViewController.caseSelected = caseSelected
            membersTableViewController.ref =  Database.database().reference(withPath: "case-items").child(name!.lowercased()).child("members")
            */
            let allMembersTableViewController = segue.destination as! AllMembersTableViewController
            allMembersTableViewController.ref =  Database.database().reference(withPath: "case-items").child(name!.lowercased()).child("members")
            
            allMembersTableViewController.refMember = Database.database().reference(withPath: "members")
            allMembersTableViewController.usermode = true
            allMembersTableViewController.caseItem = caseSelected

            print("AddMemberToCase")
        }
        
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SampleCell", for: indexPath)
        let groceryItem = items[indexPath.row]
        
        cell.textLabel?.text = groceryItem.name
        cell.detailTextLabel?.text = "CrystalType: \(groceryItem.typeOfGlass)"
        
        toggleCellCheckbox(cell, isCompleted: groceryItem.completed)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let groceryItem = items[indexPath.row]
            groceryItem.ref?.removeValue()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //guard let cell = tableView.cellForRow(at: indexPath) else { return }
        sampleItem = items[indexPath.row]
        
        self.performSegue(withIdentifier: "ShowSample", sender: nil)
        
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
    

    @IBOutlet weak var BtnTeamEdit: UIButton!
    
    @IBAction func addButtonDidTouch(_ sender: AnyObject) {
        let alert = UIAlertController(title: "Sample add",
                                      message: "",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            guard let textField = alert.textFields?.first,
                let text = textField.text else { return }
            
            
            let sampleItem = Sample(name: text,
                                   addedByUser: self.user.email,
                                   completed: false,
                                   refractiveIndex: 0,
                                   sodium: 0,
                                   manganese: 0,
                                   silicon : 0,
                                   calcium : 0,
                                   aluminium : 0,
                                   potasium : 0,
                                   barium : 0,
                                   iron : 0,
                                   typeOfGlass : ""
            )
            
            let sampleItemRef = self.ref?.child(text.lowercased())
            
            sampleItemRef?.setValue(sampleItem.toAnyObject())
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel)
        
        alert.addTextField()
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func btnEditarEquipo(_ sender: Any) {
        self.performSegue(withIdentifier: "ShowMembers", sender: nil)
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
