//
//  FirebaseAuthManager.swift
//  FirebaseStarterApp
//
//  Created by Florian Marcu on 2/23/19.
//  Copyright © 2019 Instamobile. All rights reserved.
//

import FirebaseAuth
import UIKit

class FirebaseAuthManager {

    func login(credential: AuthCredential, completionBlock: @escaping (_ success: Bool) -> Void) {
        
        Auth.auth().signIn(with: credential, completion: { (firebaseUser, error) in
            completionBlock(error == nil)
        })
    }

    func createUser(email: String, password: String, completionBlock: @escaping (_ success: Bool) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) {(authResult, error) in
            if let user = authResult?.user {
                print(user)
                completionBlock(true)
            } else {
                completionBlock(true)
            }
        }
    }

    func signIn(email: String, pass: String, completionBlock: @escaping (_ success: Bool) -> Void) {
        Auth.auth().signIn(withEmail: email, password: pass) { (result, error) in
            if let error = error, let _ = AuthErrorCode(rawValue: error._code) {
                completionBlock(false)
            } else {
                
                
                
                completionBlock(true)
            }
        }
    }
    
    func signOut() {
        do {
            UserDefaults.standard.set("", forKey: "username")
            UserDefaults.standard.set(false, forKey: "loggedin")
            UserDefaults.standard.set(false, forKey: "admin")
            UserDefaults.standard.synchronize()
            try Auth.auth().signOut()
            var rootVC : UIViewController?

            rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainPage") as! InitViewController
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = rootVC
            
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
    }
}
