//
//  Conversation.swift
//  Thinh
//
//  Created by Tran Quang Dat on 3/19/17.
//  Copyright © 2017 coderschool. All rights reserved.
//

import UIKit
import Gloss

public typealias ConversationId = String
class Conversation: NSObject, Glossy {
    
    var conversation: ConversationId?
    var lastMessage: String?
    var lastTime: TimeInterval?
    var toUser: UserId?
    
    required init?(json: JSON) {
        conversation = FirebaseKey.conversation <~~ json
        lastMessage = FirebaseKey.lastMessage <~~ json
        lastTime = FirebaseKey.lastTime <~~ json
        toUser = FirebaseKey.user <~~ json
    }
    
    func toJSON() -> JSON? {
        return jsonify([
            FirebaseKey.conversation ~~> conversation,
            FirebaseKey.lastMessage ~~> lastMessage,
            FirebaseKey.lastTime ~~> lastTime,
            FirebaseKey.user ~~> toUser
    ])
    }
    
    init(id: ConversationId?, message: String?, time: TimeInterval?) {
        self.conversation = id
        self.lastMessage = message
        self.lastTime = time
    }
    
    func withUser(_ user: UserId) -> Conversation {
        self.toUser = user
        return self
    }
}

