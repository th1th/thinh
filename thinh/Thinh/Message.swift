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
    var media: URL?
    
    // for bot message
    var user1: UserId?
    var user2: UserId?
    
    required init?(json: JSON) {
        date = FirebaseKey.date <~~ json
        from = FirebaseKey.from <~~ json
        to = FirebaseKey.to <~~ json
        message = FirebaseKey.message <~~ json
        media = FirebaseKey.media <~~ json
    }
    
    func toJSON() -> JSON? {
        return jsonify([
            FirebaseKey.date ~~> date,
            FirebaseKey.from ~~> from,
            FirebaseKey.to ~~> to,
            FirebaseKey.message ~~> message,
            FirebaseKey.media ~~> media])
    }
    
    init(from: UserId, to: UserId, message: String) {
        date = Date.currentTimeInMillis()
        self.from = from
        self.user1 = from
        self.to = to
        self.user2 = to
        self.message = message
    }
    
    init(from: UserId, to:UserId, media: URL) {
        date = Date.currentTimeInMillis()
        self.from = from
        self.to = to
        self.user1 = from
        self.user2 = to
        self.media = media
    }
    
    init(thinh: Thinh) {
        date = Date.currentTimeInMillis()
        self.from = thinh.from
        self.user1 = thinh.from
        self.to = thinh.to
        self.user2 = thinh.to
        self.message = thinh.message
        self.media = thinh.media 
    }
    
    func refreshTime() -> Message {
        self.date = Date.currentTimeInMillis()
        return self
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
