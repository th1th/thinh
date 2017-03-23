//
//  Constant.swift
//  Thinh
//
//  Created by Tran Quang Dat on 3/19/17.
//  Copyright © 2017 coderschool. All rights reserved.
//

import UIKit

/**
 * Struct to store all key in our database
 **/
struct FirebaseKey {
    
    // child 
    static let user = "user"
    static let thinh = "thinh"
    static let conversation = "conversation"
    static let userConversation = "user-conversation"
    static let userFriend = "user-friend"
    static let userThinh = "user-thinh"
    
    // user key
    static let avatar = "avatar"
    static let description = "description"
    static let birthday = "birthday"
    static let facebookId = "facebookId"
    static let gender = "gender"
    static let phone = "phone"
    static let prefer = "prefer"
    static let name = "name"
    static let id = "id"
    static let status = "status"
    
    // conversation
    static let from = "from"
    static let to = "to"
    static let message = "message"
    static let date = "date"
    
    // thinh
    static let friend = "friend"
    // from, to, date
    
    // user conversation
    // conversation
    static let lastTime = "lastTime"
    static let lastMessage = "lastMessage"
    
    static let botMessage = "Congra! Everyone shold love thinh"
}

enum ThinhError: Error {
    case unknownUser
    // TODO: more error
}
