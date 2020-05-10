//
//  Sample.swift
//  LPS2020
//
//  Created by Juan Soler Marquez on 03/01/2020.
//  Copyright © 2020 ual. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

struct Sample {
    
    let ref: DatabaseReference?
    let key: String
    let name: String
    let addedByUser: String
    var refractiveIndex: Double
    var sodium: Double
    var manganese: Double
    var silicon: Double
    var calcium: Double
    var aluminium: Double
    var potasium: Double
    var barium: Double
    var iron: Double
    var typeOfGlass: String
    var completed: Bool
    
    init(name: String, addedByUser: String, completed: Bool, key: String = "", refractiveIndex: Double, sodium: Double, manganese: Double, silicon: Double, calcium: Double, aluminium: Double, potasium: Double, barium: Double, iron: Double, typeOfGlass: String) {
        self.ref = nil
        self.key = key
        self.name = name
        self.addedByUser = addedByUser
        self.completed = completed
        self.refractiveIndex = 0
        self.sodium = sodium
        self.manganese = manganese
        self.silicon = silicon
        self.calcium = calcium
        self.aluminium = aluminium
        self.potasium = potasium
        self.barium = barium
        self.iron = iron
        self.typeOfGlass = ""
    }
    
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let name = value["name"] as? String,
            let addedByUser = value["addedByUser"] as? String,
            let completed = value["completed"] as? Bool,
            let refractiveIndex = value["refractiveIndex"] as? Double,
            let sodium = value["sodium"] as? Double,
            let manganese = value["manganese"] as? Double,
            let silicon = value["silicon"] as? Double,
            let calcium = value["calcium"] as? Double,
            let aluminium = value["aluminium"] as? Double,
            let potasium = value["potasium"] as? Double,
            let barium = value["barium"] as? Double,
            let iron = value["iron"] as? Double,

            let typeOfGlass = value["typeOfGlass"] as? String
            else {
                return nil
        }
        
        self.ref = snapshot.ref
        self.key = snapshot.key
        self.name = name
        self.addedByUser = addedByUser
        self.completed = completed
        self.refractiveIndex = refractiveIndex
        self.sodium = sodium
        self.manganese = manganese
        self.silicon = silicon
        self.calcium = calcium
        self.aluminium = aluminium
        self.potasium = potasium
        self.barium = barium
        self.iron = iron
        self.typeOfGlass = typeOfGlass
    }
    
    func toAnyObject() -> Any {
        return [
            "name": name,
            "addedByUser": addedByUser,
            "completed": completed,
            "refractiveIndex": refractiveIndex,
            "sodium": sodium,
            "manganese": manganese,
            "silicon": silicon,
            "calcium": calcium,
            "aluminium": aluminium,
            "potasium": potasium,
            "barium": barium,
            "iron" : iron,
            "typeOfGlass": typeOfGlass
        ]
    }
}
