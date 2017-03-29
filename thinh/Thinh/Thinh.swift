//
//  Thinh.swift
//  Thinh
//
//  Created by Tran Quang Dat on 3/26/17.
//  Copyright © 2017 coderschool. All rights reserved.
//

import UIKit
import Gloss

typealias ThinhId = String
class Thinh: NSObject, Glossy  {
//    var id: ThinhId?
    var from: UserId?
    var to: UserId?
    var message: String?
    var media: URL?
    var date: TimeInterval?
    var friend: Bool?
    
    required init?(json: JSON) {
//        id = FirebaseKey.id <~~ json
        from = FirebaseKey.from <~~ json
        to = FirebaseKey.to <~~ json
        message = FirebaseKey.message <~~ json
        media = FirebaseKey.media <~~ json
        date = FirebaseKey.date <~~ json
        friend = FirebaseKey.friend <~~ json
    }
    
    func toJSON() -> JSON? {
        return jsonify([
//            FirebaseKey.id ~~> id,
            FirebaseKey.from ~~> from,
            FirebaseKey.to ~~> to,
            FirebaseKey.message ~~> message,
            FirebaseKey.media ~~> media,
            FirebaseKey.date ~~> date,
            FirebaseKey.friend ~~> friend])
    }
    
    override init() {
        self.date = Date.currentTimeInMillis()
        self.from = Api.shared().userId()
    }
    
//    func withId(_ id: ThinhId) -> Thinh {
//        self.id = id
//        return self
//    }
    
    func withFrom(_ from: UserId) -> Thinh {
        self.from = from
        return self
    }
    
    func withTo(_ to: UserId) -> Thinh {
        self.to = to
        return self
    }
    
    func withMessage(_ message: String?) -> Thinh {
        self.message = message
        return self
    }
    
    func withMedia(_ media: URL?) -> Thinh {
        self.media = media
        return self
    }
    
    func withFriend(_ friend: Bool) -> Thinh {
        self.friend = friend
        return self
    }
}
