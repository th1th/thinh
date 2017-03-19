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
class Conversation: NSObject, Decodable {
    
    var conversation: ConversationId?
    var lastMessage: String?
    var lastTime: TimeInterval?
    
    required init?(json: JSON) {
        conversation = FirebaseKey.conversation <~~ json
        lastMessage = FirebaseKey.lastMessage <~~ json
        lastTime = FirebaseKey.lastTime <~~ json
    }
}

