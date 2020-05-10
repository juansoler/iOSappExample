//
//  AllMembersTableViewController.swift
//  LPS2020
//
//  Created by Juan Soler Marquez on 05/01/2020.
//  Copyright © 2020 ual. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage

class AllMembersTableViewController: UITableViewController {
    
    var caseName:String?
    var ref: DatabaseReference?
    var refMember: DatabaseReference?
    var items: [Member] = []
    var selectedItems: [Member] = []
    var caseItem:Case?

    var user: User!
    let usersRef = Database.database().reference(withPath: "online")
    var member:Member!
    var usermode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.allowsMultipleSelectionDuringEditing = false
        AppDelegate.selectedItems.removeAll();

        if usermode {
            print("dentro usermode")
            ref?.observe(.value, with: { snapshot in
                //var newItems: [Member] = []
                for child in snapshot.children {
                    if let snapshot = child as? DataSnapshot,
                        let sampleItem = Member(snapshot: snapshot) {
                        //newItems.append(sampleItem)
                        print(sampleItem.name)
                        AppDelegate.selectedItems.append(sampleItem)
                    }
                }
                
                //self.items = newItems
                //self.tableView.reloadData()
            })
        }
        refMember?.observe(.value, with: { snapshot in
            var newItems: [Member] = []
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                    let sampleItem = Member(snapshot: snapshot) {
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
    
    /*
    @IBAction func performUnwindSegueOperation(_ sender: UIStoryboardSegue) {
        guard let landingVC = sender.source as? AddCaseViewController else { return }
        landingVC.selectedItems = selectedItems
    }
   */

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier:
            "MemberCell", for: indexPath) as! MemberCell
        /*let cell = tableView.dequeueReusableCell(withIdentifier: "MemberCell", for: indexPath)
 */
        let memberItem = items[indexPath.row]
        
        let split = memberItem.name.components(separatedBy: "@")
        
        let storage = Storage.storage()
        
        storage.reference(withPath: "images/"+split[0]+".jpg").getData(maxSize: (1 * 1024 * 1024)) { (data, error) in
            if let _error = error{
                print(_error)
            } else {
                if let _data  = data {
                    cell.foto.image = UIImage(data: _data)
                }
            }
        }
        
        
        cell.nombre.text = memberItem.name
        
        cell.textLabel?.text = memberItem.name
        cell.detailTextLabel?.text = memberItem.otro
        
        
        
        toggleCellCheckbox(cell, isCompleted: false)
       
        if AppDelegate.selectedItems.contains(memberItem){
            toggleCellCheckbox(cell, isCompleted: true)
        }else {
            toggleCellCheckbox(cell, isCompleted: false)

        }
        

        
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 75 //or whatever you need
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
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        member = items[indexPath.row]
        
        print(member.name)
        
        
        if (usermode){
            if AppDelegate.selectedItems.contains(member){
                print("esta dentro")
                let index = AppDelegate.selectedItems.firstIndex(of: member)
                AppDelegate.selectedItems.remove(at: index!)
                eliminarCasoOfMiembro(miembro: (member.name), caso: caseItem!)
                
                toggleCellCheckbox(cell, isCompleted: false)
                
            }else {
                print("no esta")
                AppDelegate.selectedItems.append(member)
                addCasoOfMiembro(miembro: (member.name), caso: caseItem!)
                
                toggleCellCheckbox(cell, isCompleted: true)
                
            }
        }else {
            if AppDelegate.selectedItems.contains(member){
                print("esta dentro")
                let index = AppDelegate.selectedItems.firstIndex(of: member)
                AppDelegate.selectedItems.remove(at: index!)
                
                
                toggleCellCheckbox(cell, isCompleted: false)
                
            }else {
                print("no esta")
                AppDelegate.selectedItems.append(member)
                
                
                toggleCellCheckbox(cell, isCompleted: true)
                
            }
        }
        
        
        
        
       
        
        
       
        
        
        
        
        
         /*membertemRef.ref?.updateChildValues([
         "completed": toggledCompletion
         ])
 */
        
    }
    
    func eliminarCasoOfMiembro(miembro: String, caso: Case){
        let split = miembro.components(separatedBy: "@")
        
        let refEliminar = Database.database().reference(withPath: "members").child(split[0]).child("cases").child(caso.name.lowercased());
        refEliminar.removeValue()
    }
    
    func addCasoOfMiembro(miembro: String, caso: Case){
        let split = miembro.components(separatedBy: "@")
        
        Database.database().reference(withPath: "members").child(split[0]).child("cases").child(caso.name.lowercased()).setValue(caso.toAnyObject())
        
        
        
    }
    
    @IBAction func BtnGuardar(_ sender: Any) {
        
        if usermode{
            ref!.removeValue()
            //ref!.setValue(AppDelegate.selectedItems)
            for ele in AppDelegate.selectedItems{
                
                let split = ele.name.components(separatedBy: "@")
                
                
                
                let membertemRef = ref!.child((split[0]))
                
                membertemRef.setValue(ele.toAnyObject())
            }
            AppDelegate.selectedItems.removeAll()

        }
        
        self.navigationController?.popViewController(animated: true)
        /*
        for ele in selectedItems{
            
            let split = ele.name.components(separatedBy: "@")
            
            
            let membertemRef = self.ref?.child((split[0]))
            
            membertemRef?.setValue(ele.toAnyObject())
        }
        
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

extension Array {
    func contains<Member>(obj: Member) -> Bool where Member : Equatable {
        return self.filter({$0 as? Member == obj}).count > 0
    }
}
