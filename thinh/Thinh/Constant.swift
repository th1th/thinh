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
    static let isTyping = "isTyping"
    static let messages = "messages"
    static let match = "match"
    static let data = "data"
    static let cover = "cover"
    
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
    static let caption = "caption"
    static let lat = "lat"
    static let lon = "lon"
    
    // conversation
    static let from = "from"
    static let to = "to"
    static let message = "message"
    static let date = "date"
    static let media = "media"
    static let seen = "seen"
    
    // thinh
    static let friend = "friend"
    // from, to, date
    
    // media
    static let width = "width"
    static let heigh = "heigh"
    static let url = "url"
    
    
    // user conversation
    // conversation
    static let lastTime = "lastTime"
    static let lastMessage = "lastMessage"
    
    // match
    static let AName = "AName"
    static let BName = "BName"
    static let AAvatar = "AAvatar"
    static let BAvatar = "BAvatar"
    static let AMessage = "AMessage"
    static let BMessage = "BMessage"
    static let AMedia = "AMedia"
    static let BMedia = "BMedia"
    
    static let botMessage = "Congra! Everyone should love thinh"
}

enum ThinhError: Error {
    case loginFailed
    case unknownUser
    case sendMessage
    case uploadImageFailed
    case unknownThinh
}
