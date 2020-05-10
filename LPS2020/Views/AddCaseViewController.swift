//
//  AddCaseViewController.swift
//  LPS2020
//
//  Created by Juan Soler Marquez on 05/01/2020.
//  Copyright © 2020 ual. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase


class AddCaseViewController: UIViewController {
    
    var CaseName:String?
    let ref = Database.database().reference(withPath: "case-items")
    var selectedItems: [Member] = []

    let refMember = Database.database().reference(withPath: "members")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = CaseName

        // Do any additional setup after loading the view.
    }
    
    @IBAction func BtnAddMember(_ sender: Any) {
        
        if (nameText.text!.count > 0) {
            self.performSegue(withIdentifier: "AddMemberToCase", sender: nil)
        }else {
            let alert = UIAlertController(title: "Error", message: "Debe introducir primero el nombre del caso", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Done", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    @IBAction func BtnGuardar(_ sender: Any) {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        
        let caseItem = Case(name: nameText.text!,
                            addedByUser: AppDelegate.user!.email,
                            completed: false, fecha:formatter.string(from: date))
        
        let caseItemRef = Database.database().reference(withPath: "case-items").child(nameText.text!.lowercased())
        
        
        caseItemRef.setValue(caseItem.toAnyObject())
        
        Database.database().reference(withPath: "case-items").child(nameText.text!.lowercased()).child("members")
        
        for ele in AppDelegate.selectedItems{
            
            let split = ele.name.components(separatedBy: "@")
            
            refMember.child(split[0]).child("cases").child(caseItem.name.lowercased()).setValue(caseItem.toAnyObject())
            
            let membertemRef = caseItemRef.child("members").child((split[0]))
            
            membertemRef.setValue(ele.toAnyObject())
        }
        AppDelegate.selectedItems.removeAll()
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    @IBOutlet weak var nameText: UITextField!
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        
        if segue.identifier == "AddMemberToCase"{
            let allMembersTableViewController = segue.destination as! AllMembersTableViewController
                allMembersTableViewController.ref =  Database.database().reference(withPath: "case-items").child(nameText.text!).child("members")
            
                allMembersTableViewController.refMember = Database.database().reference(withPath: "members")
            
                allMembersTableViewController.caseName = nameText.text!
            
            print("AddMemberToCase")
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
