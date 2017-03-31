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
    
    
    static func mock(from: UserId, to: UserId, i: Int) -> [Message] {
        let ms = [m1, m2, m3, m4, m5, m6, m7, m8, m9, m10]
        let texts = ms[i]
        
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
    
    static let m1 = ["Hello, Guy", "Hi", "How're you", "I'm fine", "How abt your final project", "We're doing it well", "What's your guy finished?", "We're done the chat stuff and tha thinh  is now ready to launch", "Sound great!", "Yeah, man"]
    
    static let m2 = ["Hey, I got married", "Oh, dats gud!", "No, dats bad. she's ugly", "Oh, dats bad!", "No, dats gud, shes rich", "Oh, dats gud!", "No dats bad she wont give me a cent", "Dats bad!", "No dats gud she bought me a big house", "Oh dats gud!", "No dats bad the house burn down!"]
    
    static let m3 = ["Do u known anything abt a bunch of taco trucks right outside of the White House", "They're here? Great",
                     "Joe, they're blocking the entrance", "He has his wall and I have mine", "Damn it, Joe", "I used Trump's credit card. He's paying for this wall"]
    
    static let m4 = ["I cant believe thay arrested zimmerman", "There was that part where he killed someon", "He's bein' tried in the media! We dont have all the fact! Dont rush to judgement!", "Uh-hub. Let's just skip forward ten minutes to the end of the conversation! Go on", "And why cant there be a white entertainment channel!!"]
    static let m5 = ["You are in very critical condition, you are dying and you dont' have much time", "OMG, thats terrible. HOw long have I got?", "10", "10 what? days, weeks, months or years?", "10...9...8...7...6...", "!!!!"]
    static let m6 = ["Do you think I'm cute?", "No;)", "Am I pretty?", "No", "Does that mean I'm beautiful? <3", "No it means your ugly"]
    static let m7 = ["Where do u live?", "With my parents", "Where does ur parents live?", "With me", "Where do you all live?", "Together", "Where is your house?", "Next to my neighbors house", "Where is your neighbors house?", "If I tell you, you wont believe me", "Tell me", "Next to my house"]
    static let m8 = ["Daddddd", "What's up", "Want some updog for dinner?", "What?", "Do you want some updog for dinner", "What's updog?", "Not much! You?;)", "Sometimes I wish U would act like U R almost 18"]
    static let m9 = ["Em yêu anh", "Anh cũng thế", "Anh cũng yêu em hả, ahihi", "Không, anh cũng yêu anh"]
    static let m10 = ["Còn thời lên ngựa bắn cung ...", "Hết thời xuống ngựa... Cầm thun bắn ruồi..", "Nhà sạch thì mát..", "Bát sạch tốn xà bông.", "Nếu thích Mon chế..", "Thì phải tích cực chế nhưng đừng làm ô uế hình tượng Mon..."]
}

