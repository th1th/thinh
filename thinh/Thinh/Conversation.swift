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

protocol ConversationDelegate : class {
    func ConversationInfoUpdate(_ conversation : Conversation)
}

class Conversation: NSObject, Glossy {
    

    weak var delegate : ConversationDelegate?
    
    var id: ConversationId?

    var lastMessage: String?
    var lastTime: TimeInterval?
    var partnerID: UserId? {
        didSet{
            Api.shared().getUser(id: partnerID!).subscribe(onNext: { (user) in
                self.partnerName = user.name
                self.partnerAvatar = URL(string: user.avatar!)
                
                // TODO: Get partner online/offline status
                self.partnerOnline = true
                
                self.delegate?.ConversationInfoUpdate(self)
            })
        }
    }
    
    var partnerName: String?
    var partnerAvatar: URL?
    var partnerOnline: Bool?
    
    required init?(json: JSON) {
        super.init()
        id = FirebaseKey.conversation <~~ json
        lastMessage = FirebaseKey.lastMessage <~~ json
        lastTime = FirebaseKey.lastTime <~~ json
        ({self.partnerID = FirebaseKey.user <~~ json})()
    }
    
    func toJSON() -> JSON? {
        return jsonify([
            FirebaseKey.conversation ~~> id,
            FirebaseKey.lastMessage ~~> lastMessage,
            FirebaseKey.lastTime ~~> lastTime,
            FirebaseKey.user ~~> partnerID
            ])
    }
    
    init(id: ConversationId?, message: String?, time: TimeInterval?) {
        self.id = id
        self.lastMessage = message
        self.lastTime = time
    }
    
    // For Testing
    init(message: String?, time: TimeInterval?, name: String?, avatar:String?, online:Bool?) {
        self.lastMessage = message
        self.lastTime = time
        self.partnerName = name
        self.partnerAvatar = URL(string: avatar!)
        
        self.partnerOnline = online
    }
    
    func withUser(_ user: UserId) -> Conversation {
        self.partnerID = user
        return self
    }
}

