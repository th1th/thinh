//
//  Message.swift
//  Thinh
//
//  Created by Tran Quang Dat on 3/19/17.
//  Copyright © 2017 coderschool. All rights reserved.
//

import UIKit
import Gloss

public typealias MessageId = String
class Message: NSObject, Glossy {

    var date: TimeInterval?
    var from: UserId?
    var to: UserId?
    var message: String?
    
    // for bot message
    var user1: UserId?
    var user2: UserId?
    
    required init?(json: JSON) {
        date = FirebaseKey.date <~~ json
        from = FirebaseKey.from <~~ json
        to = FirebaseKey.to <~~ json
        message = FirebaseKey.message <~~ json
    }
    
    func toJSON() -> JSON? {
        return jsonify([
            FirebaseKey.date ~~> date,
            FirebaseKey.from ~~> from,
            FirebaseKey.to ~~> to,
            FirebaseKey.message ~~> message])
    }
    
    init(from: UserId, to: UserId, message: String) {
        date = NSDate().timeIntervalSince1970  * 1000
        self.from = from
        self.user1 = from
        self.to = to
        self.user2 = to
        self.message = message
    }
    
    
    static func mock(from: UserId, to: UserId) -> [Message] {
        let texts = ["Hello, Dat", "Hello, Dave", "How're you", "I'm fine", "How abt your final project", "We're doing it well", "What's your guy finished?"]
        var messages = [Message]()
        for (id, text) in texts.enumerated() {
            if id % 2 == 0 {
               let message = Message(from: from, to: to, message: text)
                messages.append(message)
            } else {
                let message = Message(from: to, to: from, message: text)
                messages.append(message)
            }
        }
        return messages
    
    }
}
