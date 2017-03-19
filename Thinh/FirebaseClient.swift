//
//  FirebaseClient.swift
//  Thinh
//
//  Created by Tran Quang Dat on 3/19/17.
//  Copyright © 2017 coderschool. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FacebookLogin

class Api: NSObject {
    
    private var database: FIRDatabaseReference
    private var userDb: FIRDatabaseReference
    private var thinhDb: FIRDatabaseReference
    private var conversationDb: FIRDatabaseReference
    private var userFriendDb: FIRDatabaseReference
    private var userThinhDb: FIRDatabaseReference
    private var userConversationDb: FIRDatabaseReference
    
    static private var _shared: Api!
    
    static func shared() -> Api {
        if (_shared == nil) {
            _shared = Api()
        }
        return _shared
    }
    
    override init() {
        database = FIRDatabase.database().reference()
        userDb = database.child(FirebaseKey.user)
        thinhDb = database.child(FirebaseKey.thinh)
        conversationDb = database.child(FirebaseKey.conversation)
        userFriendDb = database.child(FirebaseKey.userFriend)
        userThinhDb = database.child(FirebaseKey.userThinh)
        userConversationDb = database.child(FirebaseKey.userConversation)
    }
   

    func login() {
        // TODO
    }
    
    func isLogin() -> Bool {
        return FIRAuth.auth()?.currentUser != nil
    }
    
    func logout() {
        do {
            LoginManager().logOut()
            try FIRAuth.auth()?.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "didLogOut"), object: nil)
    }
    
    
    func getAllConversation() {
        
    }
    
    func getConversationById(id: ConversationId) {
        
    }
    
    func sendMessage(id: ConversationId, message: String) {
        
    }
    
    func getStrangerList() {
        
    }
    
    func getFriendList() {
        
    }
    
    
    
    

}
