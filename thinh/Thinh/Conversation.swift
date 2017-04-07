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
    var lastTime: TimeInterval!
    var seen: Bool?
    var partnerID: UserId? {
        didSet{
            Api.shared().getUser(id: partnerID!).subscribe(onNext: { (user) in
                self.partner = user
                self.partnerName = user.name
                self.partnerAvatar = URL(string: user.avatar!)
                
                // TODO: Get partner online/offline status
                self.partnerOnline = user.status
                
                self.delegate?.ConversationInfoUpdate(self)
            })
        }
    }
    
    var partnerName: String?
    var partnerAvatar: URL?
    var partnerOnline: Bool?
    var partner: User?
    
    required init?(json: JSON) {
        super.init()
        id = FirebaseKey.conversation <~~ json
        lastMessage = FirebaseKey.lastMessage <~~ json
        lastTime = FirebaseKey.lastTime <~~ json
        seen = FirebaseKey.seen <~~ json
        ({self.partnerID = FirebaseKey.user <~~ json})()
    }
    
    func toJSON() -> JSON? {
        return jsonify([
            FirebaseKey.conversation ~~> id,
            FirebaseKey.lastMessage ~~> lastMessage,
            FirebaseKey.lastTime ~~> lastTime,
            FirebaseKey.user ~~> partnerID,
            FirebaseKey.seen ~~> seen
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
    
    func withSeen(_ seen: Bool) -> Conversation {
        self.seen = seen
        return self
    }
    
    
    static let cover1 = "https://firebasestorage.googleapis.com/v0/b/thinh-43483.appspot.com/o/cover%2Fcover1.jpg?alt=media&token=315368dc-8ba7-4421-8d83-92f72c8e49cd"
    static let cover2 = "https://firebasestorage.googleapis.com/v0/b/thinh-43483.appspot.com/o/cover%2Fcover2.jpg?alt=media&token=e1e9423a-1d21-4ee2-aae2-31d3366bd669"
    static let cover3 = "https://firebasestorage.googleapis.com/v0/b/thinh-43483.appspot.com/o/cover%2Fcover3.jpg?alt=media&token=a0ba91c8-fb8c-402a-ae81-dba7ac865cf7"
    static let cover4 = "https://firebasestorage.googleapis.com/v0/b/thinh-43483.appspot.com/o/cover%2Fcover4.jpg?alt=media&token=c5ad1cfe-44b7-4e97-aac6-5a2488dba20a"
    static let cover5 = "https://firebasestorage.googleapis.com/v0/b/thinh-43483.appspot.com/o/cover%2Fcover5.jpg?alt=media&token=13d05a11-9785-4daf-be65-1c92af09dc9e"
    static let cover6 = "https://firebasestorage.googleapis.com/v0/b/thinh-43483.appspot.com/o/cover%2Fcover6.jpg?alt=media&token=4daa74ff-c85b-4d95-9518-950a2ae8a245"
    static let cover7 = "https://firebasestorage.googleapis.com/v0/b/thinh-43483.appspot.com/o/cover%2Fcover7.jpg?alt=media&token=a24b8f4a-69bd-4302-b095-6361b728b2f2"
    static let cover8 = "https://firebasestorage.googleapis.com/v0/b/thinh-43483.appspot.com/o/cover%2Fcover8.jpg?alt=media&token=f7869f20-f52a-40cc-82a4-f9802257de3c"
    static let cover9 = "https://firebasestorage.googleapis.com/v0/b/thinh-43483.appspot.com/o/cover%2Fcover9.jpg?alt=media&token=1ed87ed6-0c7a-4ab7-8cf3-bcddb1737de9"
    static let cover10 = "https://firebasestorage.googleapis.com/v0/b/thinh-43483.appspot.com/o/cover%2Fcover10.jpg?alt=media&token=a20803af-a1ee-4e0d-ba9a-6333e406a53f"
    static let cover11 = "https://firebasestorage.googleapis.com/v0/b/thinh-43483.appspot.com/o/cover%2Fcover11.jpg?alt=media&token=b0fa98cb-1ed2-4deb-9966-f821a70d0b71"
    static let covers = [cover1, cover2, cover3, cover4, cover5, cover6, cover7, cover8, cover9, cover10, cover11]
    static func randomCover() -> String {
        let i = Int(arc4random_uniform(11))
        return covers[i]
    }
}

