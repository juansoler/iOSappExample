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

struct Case {
    
    let ref: DatabaseReference?
    let key: String
    let name: String
    let addedByUser: String
    let fecha: String
    var completed: Bool
    
    init(name: String, addedByUser: String, completed: Bool, key: String = "", fecha: String) {
        self.ref = nil
        self.key = key
        self.name = name
        self.addedByUser = addedByUser
        self.completed = completed
        self.fecha = fecha
    }
    
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let name = value["name"] as? String,
            let addedByUser = value["addedByUser"] as? String,
            let fecha = value["fecha"] as? String,
            let completed = value["completed"] as? Bool else {
                return nil
        }
        
        self.ref = snapshot.ref
        self.key = snapshot.key
        self.name = name
        self.addedByUser = addedByUser
        self.completed = completed
        self.fecha = fecha
    }
    
    func toAnyObject() -> Any {
        return [
            "name": name,
            "addedByUser": addedByUser,
            "completed": completed,
            "fecha": fecha
        ]
    }
}

