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
    
    required init?(json: JSON) {
        conversation = FirebaseKey.conversation <~~ json
        lastMessage = FirebaseKey.lastMessage <~~ json
        lastTime = FirebaseKey.lastTime <~~ json
    }
    
    func toJSON() -> JSON? {
        return jsonify([
            FirebaseKey.conversation ~~> conversation,
            FirebaseKey.lastMessage ~~> lastMessage,
            FirebaseKey.lastTime ~~> lastTime
    ])
    }
    
    init(id: ConversationId?, message: String?, time: TimeInterval?) {
        self.conversation = id
        self.lastMessage = message
        self.lastTime = time
    }
    
    
//    func withLastMessage(_ message: String) -> Conversation {
//        self.lastMessage = message
//        return self
//    }
//    
//    func withLastTime(_ time: TimeInterval) -> Conversation {
//        self.lastTime = time
//        return self
//    }
}

