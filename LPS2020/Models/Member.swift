//
//  Cases.swift
//  LPS2020
//
//  Created by Juan Soler Marquez on 03/01/2020.
//  Copyright © 2020 ual. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

struct Member : Equatable{
    
    let ref: DatabaseReference?
    let key: String
    let name: String
    let otro: String
    var admin: Bool
    
    init(name: String, otro: String, admin: Bool, key: String = "") {
        self.ref = nil
        self.key = key
        self.name = name
        self.otro = otro
        self.admin = admin
    }
    
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let name = value["name"] as? String,
            let otro = value["otro"] as? String,
            let admin = value["admin"] as? Bool else {
                return nil
        }
        
        self.ref = snapshot.ref
        self.key = snapshot.key
        self.name = name
        self.otro =  otro
        self.admin = admin
    }
    
    func toAnyObject() -> Any {
        return [
            "name": name,
            "otro": otro,
            "admin": admin
        ]
    }
    
    static func ==(lhs:Member, rhs:Member) -> Bool { // Implement Equatable
        return lhs.name == rhs.name
    }
}

