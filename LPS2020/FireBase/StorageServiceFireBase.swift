//
//  StorageServiceFireBase.swift
//  LPS2020
//
//  Created by Juan Soler Marquez on 07/01/2020.
//  Copyright © 2020 ual. All rights reserved.
//

import Foundation
import UIKit
import FirebaseStorage

struct StorageServiceFireBase {
    
    //https://www.makeschool.com/online-courses/tutorials/build-a-photo-sharing-app-9f153781-8df0-4909-8162-bb3b3a2f7a81/uploading-photos-to-firebase
    
    // provide method for uploading images
    static func uploadImage(_ image: UIImage, at reference: StorageReference, completion: @escaping (URL?) -> Void) {
        
        guard let imageData = UIImageJPEGRepresentation(image, 0.1) else {
            return completion(nil)
        }
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        reference.putData(imageData, metadata: metaData, completion: { (metadata, error) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                print("Upload failed :: ",error.localizedDescription)
                return completion(nil)
            }
            
            completion(metadata?.downloadURL())
        })
    }
}
