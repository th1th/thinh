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
    var status: Bool?
    var caption: String?
    
    static var currentUser = User.init(user: (FIRAuth.auth()?.currentUser)!)
    
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
        self.status = FirebaseKey.status <~~ json
        self.caption = FirebaseKey.caption <~~ json
    }
    
    func toJSON() -> JSON? {
        return jsonify([
            FirebaseKey.avatar ~~> avatar,
            FirebaseKey.gender ~~> gender,
            FirebaseKey.name ~~> name,
            FirebaseKey.phone ~~> phone,
            FirebaseKey.prefer ~~> prefer,
            FirebaseKey.id ~~> id,
            FirebaseKey.status ~~> status,
            FirebaseKey.caption ~~> caption])
    }
    
    override init() {
        
    }
    
    init(user: FIRUser) {
        self.avatar = user.photoURL?.absoluteString
        self.name = user.displayName
        self.id = user.uid
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
    
    func withId(_ id: UserId) -> User {
        self.id = id
        return self
    }
    
    func withStatus(_ status: Bool) -> User {
        self.status = status
        return self
    }
    
    
    
    
    static func mock() -> [User] {
        let names = ["Dat Tran", "Viet Dang", "Linh Le", "Dave Vo", "Harley", "Tan", "Coderschool"]
        let links = [avatar1, avatar2, avatar3, avatar4, avatar5, avatar6, avatar7]
        let ids = [user1, user2, user3, user4, user5, user6, user7]
        var users = [User]()
        for i in 0..<7 {
            let user = User(json:
                [FirebaseKey.name: names[i],
                 FirebaseKey.gender: Sex.male.rawValue,
                 FirebaseKey.avatar: links[i],
                 FirebaseKey.phone: "0938481680",
                 FirebaseKey.id: ids[i],
                 FirebaseKey.prefer: Sex.female.rawValue,
                 FirebaseKey.caption: "Sống nội tâm, yêu màu tím, thích thể hiện. Đàn ông đích thực"
                ])
            users.append(user!)
        }
        return users
    }
    
    // mock user data
    static let user1 = "S5cirBWXUiOGnareVEEWbjaIJN02"
    static let user2 = "WR3OioP6R0UTPUoWItWyJX5g4p62"   // Mr.Linh
    static let user3 = "WhEZVoiMDpTA4QkdI8dHCZFyG752"
    static let user4 = "cdP7J0LNP2gUG3BeEq29N8JHDt72"
    static let user5 = "7ufjet2By0UHMVtf0MINZ4gC63H3"
    static let user6 = "rsu1wVrOsDeBBlfriSkhMsW6sKm2"
    static let user7 = "yIoo1rv5FvaEusPooUF3HXtwt7G2"
    static let avatar1 = "https://firebasestorage.googleapis.com/v0/b/thinh-43483.appspot.com/o/mock%2F1.jpg?alt=media&token=5574f907-7260-4e3d-ae3e-e951dd4816a0"
    static let avatar2 = "https://firebasestorage.googleapis.com/v0/b/thinh-43483.appspot.com/o/mock%2F2.jpg?alt=media&token=09218ddf-2df7-45e4-a676-3544d4e8fe6c"
    static let avatar3 = "https://firebasestorage.googleapis.com/v0/b/thinh-43483.appspot.com/o/mock%2F3.jpg?alt=media&token=190b9e47-f245-4918-86ee-c92179c0d60b"
    static let avatar4 = "https://firebasestorage.googleapis.com/v0/b/thinh-43483.appspot.com/o/mock%2F4.jpg?alt=media&token=7f444e1c-b2f4-4ee7-8b13-55714d56879a"
    static let avatar5 = "https://firebasestorage.googleapis.com/v0/b/thinh-43483.appspot.com/o/mock%2F5.jpg?alt=media&token=01cb085a-65ae-469d-b2f8-0ab2a82e3c38"
    static let avatar6 = "https://firebasestorage.googleapis.com/v0/b/thinh-43483.appspot.com/o/mock%2F6.png?alt=media&token=2396158b-200f-4b7b-82a9-f208fa582147"
    static let avatar7 = "https://firebasestorage.googleapis.com/v0/b/thinh-43483.appspot.com/o/mock%2F7.jpg?alt=media&token=452ab287-8dca-41b0-a3dd-a74fb3301d95"
    
}
