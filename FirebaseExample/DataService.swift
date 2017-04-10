//
//  DataService.swift
//  FirebaseExample
//
//  Created by Sugeet Goyal on 11/04/17.
//  Copyright © 2017 Sugeet Goyal. All rights reserved.
//

import Foundation
import Firebase

let BASE_URL = "https://fir-example-b32ae.firebaseio.com"

class DataService {
    static let dataService = DataService()
    
    private var _BASE_REF = FIRDatabase.database().reference(fromURL: "\(BASE_URL)")
    private var _ITEM_REF = FIRDatabase.database().reference(fromURL: "\(BASE_URL)/items")

    var BASE_REF: FIRDatabaseReference {
        return _BASE_REF
    }
    
    var ITEM_REF: FIRDatabaseReference {
        return _ITEM_REF
    }
}
