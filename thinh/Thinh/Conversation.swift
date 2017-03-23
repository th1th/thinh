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
    var partnerID: UserId? {
        didSet{
            let disposable = Api.shared().getUser(id: partnerID!).subscribe(onNext: { (user) in
                self.partnerName = user.name
                self.partnerAvatar = URL(string: user.avatar!)
                
                // TODO: Get partner online/offline status
                self.partnerOnline = true
            })
            disposable.dispose()
        }
    }
    
    var partnerName: String?
    var partnerAvatar: URL?
    var partnerOnline: Bool?
    
    required init?(json: JSON) {
        conversation = FirebaseKey.conversation <~~ json
        lastMessage = FirebaseKey.lastMessage <~~ json
        lastTime = FirebaseKey.lastTime <~~ json
        partnerID = FirebaseKey.user <~~ json
    }
    
    func toJSON() -> JSON? {
        return jsonify([
            FirebaseKey.conversation ~~> conversation,
            FirebaseKey.lastMessage ~~> lastMessage,
            FirebaseKey.lastTime ~~> lastTime,
            FirebaseKey.user ~~> partnerID
            ])
    }
    
    init(id: ConversationId?, message: String?, time: TimeInterval?) {
        self.conversation = id
        self.lastMessage = message
        self.lastTime = time
    }
    
    func withUser(_ user: UserId) -> Conversation {
        self.partnerID = user
        return self
    }
}

