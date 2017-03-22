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
import Gloss

class Api: NSObject {
    
    fileprivate var database: FIRDatabaseReference
    fileprivate var userDb: FIRDatabaseReference
    fileprivate var thinhDb: FIRDatabaseReference
    fileprivate var conversationDb: FIRDatabaseReference
    fileprivate var userFriendDb: FIRDatabaseReference
    fileprivate var userThinhDb: FIRDatabaseReference
    fileprivate var userConversationDb: FIRDatabaseReference
    fileprivate let botId = "fuckFirebase"
    
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
    
    fileprivate func userId() -> String? {
        return FIRAuth.auth()?.currentUser?.uid
    }
   

    func login(accessToken: String) {
        loginWithFacebook(accessToken: accessToken)
            .observeOn(MainScheduler.instance)
        
    }

    fileprivate func loginWithFacebook(accessToken: String) -> Observable<Bool> {
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
    
    func getUser(id: UserId) -> Observable<User> {
        return Observable.create({ (subcriber) -> Disposable in
            self.userDb.child(id).observeSingleEvent(of: .value, with: { (snapshot) in
                guard let json = snapshot.value as? JSON else {
                    subcriber.onError(ThinhError.unknownUser)
                    return
                }
                
                guard let user = User(json: json) else {
                    subcriber.onError(ThinhError.unknownUser)
                    return
                }
                
                subcriber.onNext(user)
                
            })
            return Disposables.create()
        })
    }
    
    func getCurrentUser() -> Observable<User> {
        return getUser(id: userId()!)
    }
    
    func getAllConversation() -> Observable<[Conversation]> {
       return Observable<[Conversation]>.create({ subcriber -> Disposable in
            // TODO: child event
            self.userConversationDb.child(self.userId()!).observe(.value, with: { snapshot in
                print(snapshot)
                guard let data = snapshot.value as? [JSON] else {
                    subcriber.onError(ThinhError.unknownUser)
                    return
                }
                var conversations = [Conversation]()
                for datum in data {
                    conversations.append(Conversation(json: datum)!)
                }
                subcriber.onNext(conversations)
                
            })
            return Disposables.create()
       })
    }
    
    func createNewConversation(forUser: UserId, andUser: UserId) -> ConversationId {
        let key = conversationDb.childByAutoId().key
        sendBotMessage(id: key, user1: forUser, user2: andUser)
        createFriendRelationship(between: forUser, and: andUser)
        return key
    }
    
    func getMessageOfConversation(id: ConversationId) -> Observable<[Message]> {
        return Observable<[Message]>.create { (subcriber) -> Disposable in
            // TODO: child event
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
        userConversationDb.child(message.user1!).child(message.user2!).setValue(conversation.withUser(message.user2!).toJSON())
        userConversationDb.child(message.user2!).child(message.user1!).setValue(conversation.withUser(message.user1!).toJSON())
        return key
    }
    
    func getStrangerList() -> Observable<[UserId]> {
        all.filter({ (user) -> Bool in
            var result = true
            friends.forEach({ (friend) in
                if user == friend {
                    result = false
                }
                
            })
            return result
            
        })
        
    }
    
    func getAllUser() -> Observable<[UserId]> {
        return Observable<[UserId]>.create({ (subcriber) -> Disposable in
            self.userFriendDb.observeSingleEvent(of: .value, with: { (snapshot) in
                guard let data = snapshot.value as? [UserId: Any] else {
                    subcriber.onError(ThinhError.unknownUser) // FIXME
                    return
                }
                var users = [UserId]()
                for datum in data {
                    users.append(datum.key)
                }
                subcriber.onNext(users)
                
            })
            return Disposables.create()
        })
    }
    
    func getMyFriendList() -> Observable<[UserId]> {
       return getFriendList(id: userId()!)
    }
    
    func getFriendList(id: UserId) -> Observable<[UserId]> {
        return Observable<[UserId]>.create { (subcriber) -> Disposable in
            self.userFriendDb.child(id).observeSingleEvent(of: .value, with: { (snapshot) in
                guard let data = snapshot.value as? [UserId: TimeInterval] else {
                    subcriber.onError(ThinhError.unknownUser)   // FIXME
                    return
                }
                var users = [UserId]()
                for datum in data {
                    users.append(datum.key)
                }
                subcriber.onNext(users)
            })
            
            return Disposables.create()
        }
       
    }
    
    fileprivate func createFriendRelationship(between user1: UserId, and user2: UserId) {
        let current = Date.currentTimeInMillis()
        userFriendDb.child(user1).child(user2).setValue(current)
        userFriendDb.child(user2).child(user1).setValue(current)
    }
    
    fileprivate func checkFriendRelationship(between user1: UserId, and user2: UserId) -> Observable<Bool> {
        return Observable<Bool>.create { (subcriber) -> Disposable in
            self.userFriendDb.child(user1).observeSingleEvent(of: .value, with: { (snapshot) in
                subcriber.onNext(snapshot.hasChild(user2))
            })
            return Disposables.create()
        }
    }
    
    func stop() {
        database.removeAllObservers()
    }
    
    
}


extension Api {
    func createMockData() {
        deleteDb()
        let users = createMockUser()
        for i in 0..<users.count - 1 {
            let id = createMockConversation(users: users, i: i, j: i + 1)
            createMockMessage(users: users, id: id, i: i, j: i + 1)
        }
        getFriendList(id: users[1].id!)
        checkFriendRelationship(between: users[1].id!, and: users[0].id!)
            .subscribe(onNext: { (friend) in
                if !friend {
                    print("This should be friend")
                }
            })
        checkFriendRelationship(between: users[1].id!, and: users[3].id!)
            .subscribe(onNext: { (friend) in
                if friend {
                    print("This should not be friend")
                }
            })
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
    
    
    private func createMockConversation(users: [User], i: Int, j: Int) -> ConversationId {
        return createNewConversation(forUser: users[i].id!, andUser: users[j].id!)
    }
    
    private func createMockMessage(users: [User], id: ConversationId, i: Int, j: Int) {
        let messages = Message.mock(from: users[i].id!, to: users[j].id!)
        for message in messages {
            sendMessage(id: id, message: message)
        }
    }
    
    private func createMockThinh() {
        
    }
    
    private func test() {
        
    }
}
