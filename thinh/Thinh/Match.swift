//
//  Match.swift
//  Thinh
//
//  Created by Tran Quang Dat on 4/4/17.
//  Copyright © 2017 coderschool. All rights reserved.
//

import UIKit
import Gloss

typealias MatchId = String
class Match: NSObject, Glossy {
    var id: MatchId?
    var AName: String?
    var BName: String?
    var AAvatar: String?
    var BAvatar: String?
    var AMessage: String?
    var BMessage: String?
    var AMedia: URL?
    var BMedia: URL?
    
    required init?(json: JSON) {
        id = FirebaseKey.id <~~ json
        AName = FirebaseKey.AName <~~ json
        BName = FirebaseKey.BName <~~ json
        AAvatar = FirebaseKey.AAvatar <~~ json
        BAvatar = FirebaseKey.BAvatar <~~ json
        AMessage = FirebaseKey.AMessage <~~ json
        BMessage = FirebaseKey.BMessage <~~ json
        AMedia = FirebaseKey.AMedia <~~ json
        BMedia = FirebaseKey.BMedia <~~ json
    }
    
    func toJSON() -> JSON? {
        return jsonify([
                FirebaseKey.id ~~> id,
                FirebaseKey.AName ~~> AName,
                FirebaseKey.BName ~~> BName,
                FirebaseKey.AAvatar ~~> AAvatar,
                FirebaseKey.BAvatar ~~> BAvatar,
                FirebaseKey.AMessage ~~> AMessage,
                FirebaseKey.BMessage ~~> BMessage,
                FirebaseKey.AMedia ~~> AMedia,
                FirebaseKey.BMedia ~~> BMedia
            ])
    }
    
    init(_ id: MatchId) {
        self.id = id
    }
    
//    func withId(_ id: MatchId) -> Match {
//        self.id = id
//        return self
//    }
    
    func withAName(_ name: String) -> Match {
        self.AName = name
        return self
    }
    
    func withBName(_ name: String) -> Match {
        self.BName = name
        return self
    }
    func withAAvatar(_ avatar: String) -> Match {
        self.AAvatar = avatar
        return self
    }
    func withBAvatar(_ avatar: String) -> Match {
        self.BAvatar = avatar
        return self
    }
    
    func withAMessage(_ message: String?) -> Match {
        self.AMessage = message
        return self
    }
    
    func withBMessage(_ message: String?) -> Match {
        self.BMessage = message
        return self
    }
    
    func withAMedia(_ media: URL?) -> Match {
        self.AMedia = media
        return self
    }
    
    func withBMedia(_ media: URL?) -> Match {
        self.BMedia = media
        return self
    }
}
