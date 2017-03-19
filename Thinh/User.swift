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
class User: NSObject, Glossy {

    var avatar: String?
    var gender: Sex?
    var name: String?
    var phone: String?
    var prefer: Sex?
    var id: UserId?
    
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
        self.id = FirebaseKey.id <~~ json
    }
    
    func toJSON() -> JSON? {
        return jsonify([
            FirebaseKey.avatar ~~> avatar,
            FirebaseKey.gender ~~> gender,
            FirebaseKey.name ~~> name,
            FirebaseKey.phone ~~> phone,
            FirebaseKey.prefer ~~> prefer])
    }
    
    override init() {
        
    }
    
    func withAvatar(_ avatar: String) -> User {
        self.avatar = avatar
        return self
    }
    
    func withGender(_ gender: Sex) -> User{
        self.gender = gender
        return self
    }
    
    func withName(_ name: String) -> User {
        self.name = name
        return self
    }
    
    
    func withPhone(_ phone: String) -> User {
        self.phone = phone
        return self
    }
    
    func withPrefer(_ prefer: Sex) -> User {
        self.prefer = prefer
        return self
    }
    
    func withId(id: UserId) -> User {
        self.id = id
        return self
    }
    
    
    static func mock() -> [User] {
        let names = ["Dat", "Viet", "Linh", "Dave", "Harley"]
        let link = "https://scontent.fsgn1-1.fna.fbcdn.net/v/t1.0-9/15622573_1085371901571808_5746077286281389946_n.jpg?oh=a4940622ada3ec2e2a47d5040158e464&oe=5972472E"
        var users = [User]()
        for name in names {
            let user = User(json:
                [FirebaseKey.name: name,
                 FirebaseKey.gender: Sex.male.rawValue,
                 FirebaseKey.avatar: link,
                 FirebaseKey.phone: "0938481680",
                 FirebaseKey.prefer: Sex.female.rawValue,
                ])
            users.append(user!)
        }
        return users
    }
    
}
