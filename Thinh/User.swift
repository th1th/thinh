//
//  UserState.swift
//  Thinh
//
//  Created by Linh Le on 3/18/17.
//  Copyright © 2017 coderschool. All rights reserved.
//

import UIKit
import Firebase
import Gloss

public typealias UserId = String
class User: NSObject, Decodable {

    var avatar: String?
    var gender: Sex?
    var name: String?
    var phone: String?
    var prefer: Sex?
    
    enum Sex: String {
        case male = "male"
        case female = "female"
        case unknown = "unknown"
    }
    
    
    
    required init?(json: JSON) {
        self.avatar = FirebaseKey.avatar <~~ json
        self.gender = FirebaseKey.gender <~~ json
        self.name = FirebaseKey.name <~~ json
        self.phone = FirebaseKey.phone <~~ json
        self.prefer = FirebaseKey.prefer <~~ json
    }
}
