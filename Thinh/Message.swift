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
class Message: NSObject, Decodable {

    var date: TimeInterval?
    var from: UserId?
    var to: UserId?
    var message: String?
    
    required init?(json: JSON) {
        date = FirebaseKey.date <~~ json
        from = FirebaseKey.from <~~ json
        to = FirebaseKey.to <~~ json
        message = FirebaseKey.message <~~ json
    }
}
