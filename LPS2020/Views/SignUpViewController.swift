//
//  StartViewController.swift
//  LPS2020
//
//  Created by Juan Soler Marquez on 30/12/2019.
//  Copyright © 2019 ual. All rights reserved.
//

import UIKit
import FirebaseStorage
import Photos
import AudioToolbox
// import Toaster


class SignUpViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {

    @IBOutlet weak var userPhotoImageView: UIImageView!
    
    let imagePicker = UIImagePickerController()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self


        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func uploadImageButtonClick(_ sender: UIButton) {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    @IBOutlet weak var usernameText: UITextField!
    
    @IBOutlet weak var passwordText: UITextField!
    
    @IBAction func BtnCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

    @IBAction func BtnSignup(_ sender: Any) {
        //let data = Data()
        let storageRef = Storage.storage().reference()
        let imageData = userPhotoImageView.image!.jpegData(compressionQuality: 0.75)

        let items = usernameText.text!.components(separatedBy: "@")

        let photoRef = storageRef.child("images/"+items[0]+".jpg")
        
        print("images/"+items[0]+".jpg")

        // Upload the file to the path "images/rivers.jpg"
        _ = photoRef.putData(imageData!, metadata: nil) { (metadata, error) in
            guard let metadata = metadata else {
                // Uh-oh, an error occurred!
                print("error uploading photo1")
                return
            }
            // Metadata contains file metadata such as size, content-type.
            _ = metadata.size
            // You can also access to download URL after upload.
            photoRef.downloadURL { (url, error) in
                guard url != nil else {
                    // Uh-oh, an error occurred!
                    print("error uploading photo2")

                    return
                }
            }
        }
        
        let signUpManager = FirebaseAuthManager()
            
        if let email = usernameText.text, let password = passwordText.text {
            signUpManager.createUser(email: email, password: password) {[weak self] (success) in
                guard let `self` = self else { return }
                var message: String = ""
                if (success) {
                    message = "User was sucessfully created."
                } else {
                    message = "There was an error."
                }
                let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Done", style: .cancel, handler: nil))
                self.display(alertController: alertController)
            }
        }
    }
    
    
   
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var imagen : UIImage!
        
        if let img = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            
            imagen = img
            
        }
            
        else if let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            
            imagen = img
            
        }
        
        if (info[UIImagePickerController.InfoKey.imageURL] as? NSURL) != nil{
            //let path = url.path!
            // let imagenName = path.la
            
        }
        userPhotoImageView.image = imagen
        
        // labelSaluda.text
        
        
        
        dismiss(animated:true, completion:nil)
        
    }
    
    
    
    
    func display(alertController: UIAlertController) {
        self.present(alertController, animated: true, completion: nil)
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
