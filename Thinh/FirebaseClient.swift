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
import FacebookCore
import RxSwift

class Api: NSObject {
    
    private var database: FIRDatabaseReference
    private var userDb: FIRDatabaseReference
    private var thinhDb: FIRDatabaseReference
    private var conversationDb: FIRDatabaseReference
    private var userFriendDb: FIRDatabaseReference
    private var userThinhDb: FIRDatabaseReference
    private var userConversationDb: FIRDatabaseReference
    private let botId = "fuckFirebase"
    
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
    
    private func userId() -> String? {
        return FIRAuth.auth()?.currentUser?.uid
    }
   

    func login(accessToken: String) {
        loginWithFacebook(accessToken: accessToken)
            .observeOn(MainScheduler.instance)
        
    }

    private func loginWithFacebook(accessToken: String) -> Observable<Bool> {
        return Observable<Bool>.create({ (obsever) -> Disposable in
            let credential = FIRFacebookAuthProvider.credential(withAccessToken: accessToken)
            FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
                guard error == nil else {
                    obsever.onError(error!)
                    return
                }
                obsever.onNext(true)
                obsever.on(.next(true))
            })
            return Disposables.create()
        })
    }
    
    func isLogin() -> Bool {
        return userId() != nil
    }
    
    func logout() {
        do {
            LoginManager().logOut()
            try FIRAuth.auth()?.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "didLogOut"), object: nil)
    }
    
    func getAllConversation() -> Observable<[Conversation]> {
       return Observable<[Conversation]>.create({ subcriber -> Disposable in
            self.userConversationDb.child(self.userId()!).observe(.value, with: { snapshot in
                print(snapshot)
                
            })
            return Disposables.create()
       })
    }
    
    func createNewConversation(forUser: UserId, andUser: UserId) -> ConversationId {
        let key = conversationDb.childByAutoId().key
        sendBotMessage(id: key, user1: forUser, user2: andUser)
        return key
    }
    
    func getMessageOfConversation(id: ConversationId) -> Observable<[Message]> {
        return Observable<[Message]>.create { (subcriber) -> Disposable in
            self.conversationDb.child(id).observe(.value, with: { snapshot in
                print(snapshot)
            })
            return Disposables.create()
        }
    }
    
    func sendBotMessage(id: ConversationId, user1: UserId, user2: UserId) -> MessageId {
        let message = Message(from: botId, to: user1, message: FirebaseKey.botMessage)
        // set this for bot message only
        message.user1 = user1
        message.user2 = user2
        return sendMessage(id: id, message: message)
    }
    
    func sendMessage(id: ConversationId, message: Message) -> MessageId {
        let key = conversationDb.child(id).childByAutoId().key
        // create new message
        conversationDb.child(id).child(key).setValue(message.toJSON())
        // update user conversation
        let conversation = Conversation(id: id, message: message.message, time: message.date)
        userConversationDb.child(message.user1!).child(message.user2!).setValue(conversation.toJSON())
        userConversationDb.child(message.user2!).child(message.user2!).setValue(conversation.toJSON())
        return key
    }
    
    func getStrangerList() {
        
    }
    
    func getFriendList() {
        
    }
    
    func createMockData() {
        deleteDb()
        let users = createMockUser()
        let id = createMockConversation(users: users)
        createMockMessage(users: users, id: id)
    }
    
    private func deleteDb() {
        database.setValue(nil)
    }
    
    private func createMockUser()  -> [User] {
        let users = User.mock()
        for user in users {
            let key = userDb.childByAutoId().key
            user.withId(id: key)
            userDb.child(key).setValue(user.toJSON()!)
        }
        return users
    }
    
    private func createMockConversation(users: [User]) -> ConversationId {
        return createNewConversation(forUser: users[0].id!, andUser: users[1].id!)
        
    }
    
    private func createMockMessage(users: [User], id: ConversationId) {
        let messages = Message.mock(from: users[0].id!, to: users[1].id!)
        for message in messages {
            sendMessage(id: id, message: message)
        }
    }
    
    private func createMockThinh() {
        
    }
}
