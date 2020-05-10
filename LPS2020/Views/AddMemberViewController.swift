//
//  AddMemberViewController.swift
//  LPS2020
//
//  Created by Juan Soler Marquez on 05/01/2020.
//  Copyright © 2020 ual. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class AddMemberViewController: UIViewController {

    
    var ref = Database.database().reference(withPath: "members")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnGuardar(_ sender: Any) {
        let items = emailText.text!.components(separatedBy: "@")
        
        let member = Member(name: emailText.text!,
                            otro: emailText.text!,
                            admin: SwitchAdmin.isOn)
        
        let sampleItemRef = self.ref.child(items[0])
        
        sampleItemRef.setValue(member.toAnyObject()){ (error, ref) in
            if error != nil {
                print(error?.localizedDescription ?? "Failed to update value")
                self.showPopup(isSuccess: false)

            } else {
                print("Success update newValue to database")
                self.showPopup(isSuccess: true)


            }

        }
        
        
        
        
    }
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var SwitchAdmin: UISwitch!
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
        func showPopup(isSuccess: Bool) {
            let successMessage = "Member was sucessfully created."
            let errorMessage = "Something went wrong. Please try again"
            let alert = UIAlertController(title: isSuccess ? "Success": "Error", message: isSuccess ? successMessage: errorMessage, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Done", style: UIAlertAction.Style.default, handler: {action in     self.navigationController?.popViewController(animated: true)
}))
            self.present(alert, animated: true, completion: nil)
        }
}
