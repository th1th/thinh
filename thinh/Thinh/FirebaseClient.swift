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
import FirebaseStorage

class Api: NSObject {
    
    fileprivate var database: FIRDatabaseReference
    fileprivate var userDb: FIRDatabaseReference
    fileprivate var thinhDb: FIRDatabaseReference
    fileprivate var conversationDb: FIRDatabaseReference
    fileprivate var userFriendDb: FIRDatabaseReference
    fileprivate var userThinhDb: FIRDatabaseReference
    fileprivate var userConversationDb: FIRDatabaseReference
    fileprivate let botId = "fuckFirebase"
    fileprivate var storage: FIRStorageReference
    fileprivate var conversationStorage: FIRStorageReference
    
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
        storage = FIRStorage.storage().reference()
        conversationStorage = storage.child(FirebaseKey.conversation)
    }
    
    func userId() -> String? {
        return FIRAuth.auth()?.currentUser?.uid
    }
   

    /*
     login with facebook
    */

    func login(accessToken: String) -> Observable<Bool> {
        return loginWithFacebook(accessToken: accessToken)

    }

    fileprivate func loginWithFacebook(accessToken: String) -> Observable<Bool> {
        return Observable<Bool>.create({ (obsever) -> Disposable in
            let credential = FIRFacebookAuthProvider.credential(withAccessToken: accessToken)
            FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
                guard error == nil else {
                    obsever.onError(error!)
                    return
                }
                guard let user = user else {
                    obsever.onNext(false)
                    return
                }
                self.createUser(user.uid, user: User(user: user))
            })
            return Disposables.create()
        })
    }
    
    /*
     check if has user logined
    */
    func isLogin() -> Bool {
        return userId() != nil
    }
    
    
    /*
     logout of service
    */
    func logout() {
        do {
            LoginManager().logOut()
            try FIRAuth.auth()?.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "didLogOut"), object: nil)
    }
    
    /*
     update the current user status: online and offline
     use when user open and close the app
    */
    func updateUserStatus(_ status: Bool) {
        userDb.child(userId()!).updateChildValues(["status": status]) { (error, reference) in
            if error == nil {
                print(error!.localizedDescription)
            }
        }
    }
    
    func createUser(_ id: UserId, user: User)  {
        userDb.child(id).setValue(user.toJSON()) { (error, reference) in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
        }
    }
    
    /*
     get user info using userId
    */
    func getUser(id: UserId) -> Observable<User> {
        return Observable.create({ (subcriber) -> Disposable in
            self.userDb.child(id).observe(.value, with: { (snapshot) in
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
    
    /*
     get current user info
    */
    func getCurrentUser() -> Observable<User> {
        return getUser(id: userId()!)
    }
    
    /*
     get all conversation of current login user
     FIXME: Change to child_added event in future?
    */
    
    func getAllConversation() -> Observable<[Conversation]> {
       return Observable<[Conversation]>.create({ subcriber -> Disposable in
            // TODO: child event
            self.userConversationDb.child(self.userId()!).observe(.value, with: { snapshot in
                var conversations = [Conversation]()
                for child in snapshot.children {
                    guard let data = child as? FIRDataSnapshot else {
                        return
                    }
                    conversations.append(Conversation(json: data.value as! JSON)!)
                }
                subcriber.onNext(conversations)

            })
            return Disposables.create()
       })
    }
    
    /*
     create new conversation when 2 user matched:
        - stranger dop thinh
        - both friend tha thinh
    */
    // FIXME: create new conversation between current user and user A
    func createNewConversation(forUser: UserId, andUser: UserId) -> ConversationId {
        let key = conversationDb.childByAutoId().key
        sendBotMessage(id: key, user1: forUser, user2: andUser)
        createFriendRelationship(between: forUser, and: andUser)
        return key
    }
    
    /*
     check if conversation between current user and user A has exist
    */
    fileprivate func checkIfConversationExist(between A: UserId, B: UserId) -> Observable<ConversationId?> {
       return Observable<ConversationId?>.create({ (subcriber) -> Disposable in
        self.userConversationDb.child(B).observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.hasChild(A) {
                let conversation = Conversation(json: snapshot.childSnapshot(forPath: A).value as! JSON)
                subcriber.onNext(conversation?.id)
            } else {
                subcriber.onNext(nil)
            }
        })
        return Disposables.create()
       })
    }
    
    /*
     current user is typing
     */
    func isTyping(_ conversation: ConversationId) {
        conversationDb.child(conversation).child(FirebaseKey.isTyping).setValue(true, forKey: userId()!)
    }
    
    func observeIsTyping(_ conversation: ConversationId) -> Observable<UserId> {
        return Observable<UserId>.create({ (subcriber) -> Disposable in
            self.conversationDb.child(conversation).child(FirebaseKey.isTyping).observe(.childChanged, with: { (snapshot) in
                guard let isTyping = snapshot.value as? Bool else {
                    return
                }
                if isTyping {
                    subcriber.onNext(snapshot.key)
                }
                
            })
            return Disposables.create()
        })
        
    }
    
    /*
     get the message of conversation
     use to load chat view
    */
    func getMessageOfConversation(id: ConversationId) -> Observable<Message> {
        return Observable<Message>.create { (subcriber) -> Disposable in
            self.conversationDb.child(id).observe(.childAdded, with: { snapshot in
//                var messages = [Message]()
//                for child in snapshot.children {
//                    guard let data = child as? FIRDataSnapshot else {
//                        return
//                    }
//                    messages.append(Message(json: data.value as! JSON)!)
//                }
                if let message = Message(json: snapshot.value as! JSON) {
                    subcriber.onNext(message)
                } else {
                   print("Maybe typing")
                }
            })
            return Disposables.create()
        }
    }
    
    
    
    
    
    
    
    /*
     create new text for conversationId
    */
    fileprivate func sendMessage(id: ConversationId, message: Message) -> MessageId {
        let key = conversationDb.child(id).childByAutoId().key
        // create new message
        conversationDb.child(id).child(key).setValue(message.toJSON())
        // update user conversation
        if (message.message != nil) {
            // update last message
            let conversation = Conversation(id: id, message: message.message, time: message.date)
            userConversationDb.child(message.user1!).child(message.user2!).setValue(conversation.withUser(message.user2!).toJSON())
            userConversationDb.child(message.user2!).child(message.user1!).setValue(conversation.withUser(message.user1!).toJSON())
        }   // photo message don't update last message
        return key
    }
    
    /*
     send message with image
    */
    func sendMessage(to A: UserId, conversation: ConversationId, image: UIImage) {
//        let message
        // TODO: Upload image to storage
        uploadImage(image).subscribe(onNext: { (url) in
            let message = Message(from: self.userId()!, to: A, media: url)
            self.sendMessage(id: conversation, message: message)
        })
    }
    
    /*
     send message with text
    */
    func sendMessage(to A: UserId, conversation: ConversationId, text: String) {
        let message = Message(from: userId()!, to: A, message: text)
        sendMessage(id: conversation, message: message)
    }
    
    /*
     the bot will send message when 2 user match:
     - stranger dop thinh
     - both friend tha thinh
     */
    fileprivate func sendBotMessage(id: ConversationId, user1: UserId, user2: UserId) -> MessageId {
        let message = Message(from: botId, to: user1, message: FirebaseKey.botMessage)
        // set this for bot message only
        message.user1 = user1
        message.user2 = user2
        return sendMessage(id: id, message: message)
    }
    
    /*
     return a list of all user except myself, as stream
    */
    func getAllUser() -> Observable<User> {
        return Observable<User>.create({ (subcriber) -> Disposable in
            self.userDb.observeSingleEvent(of: .value, with: { (snapshot) in
//                var users = [User]()
                for child in snapshot.children {
                    guard let data = child as? FIRDataSnapshot else {
                        return
                    }
                    let user = User(json: data.value as! JSON)
                    if user?.id != self.userId() {
                        subcriber.onNext(user!)
                    }
                }
//                subcriber.onNext(users)
            })
            return Disposables.create()
        })
    }
    
    /*
     get friend list of current user, one at the time
    */
    func getMyFriendList() -> Observable<User> {
       return getFriendList(id: userId()!)
    }
    
    /*
     get friend list of specific user, maybe public in the future
    */
    fileprivate func getFriendList(id: UserId) -> Observable<User> {
        return Observable<User>.create({ (subcriber) -> Disposable in
            self.getFriendsIdOf(user: id).subscribe(onNext: { (id) in
                self.userDb.child(id).observeSingleEvent(of: .value, with: { (snapshot) in
                    guard let user = User(json: snapshot.value as! JSON) else {
                        subcriber.onError(ThinhError.unknownUser)
                        return
                    }
                    subcriber.onNext(user)
                })
            })
            return Disposables.create()
        })
    }
    
    /*
     get all friend id one at the time
    */
    fileprivate func getFriendsIdOf(user: UserId) -> Observable<UserId> {
        return Observable<UserId>.create { (subcriber) -> Disposable in
            self.userFriendDb.child(user).observeSingleEvent(of: .value, with: { (snapshot) in
                guard let data = snapshot.value as? [UserId: TimeInterval] else {
                    subcriber.onError(ThinhError.unknownUser)   // FIXME
                    return
                }
                for datum in data {
                    subcriber.onNext(datum.key)
                }
            })
            
            return Disposables.create()
        }
    }
    
    /*
     create friend relationship when 2 stranger matched
    */
    fileprivate func createFriendRelationship(between user1: UserId, and user2: UserId) {
        let current = Date.currentTimeInMillis()
        userFriendDb.child(user1).child(user2).setValue(current)
        userFriendDb.child(user2).child(user1).setValue(current)
    }
    
    /*
     check if 2 users are friends, determine thinh behavior
    */
    fileprivate func checkFriendRelationship(between user1: UserId, and user2: UserId) -> Observable<Bool> {
        return Observable<Bool>.create { (subcriber) -> Disposable in
            self.userFriendDb.child(user1).observeSingleEvent(of: .value, with: { (snapshot) in
                subcriber.onNext(snapshot.hasChild(user2))
            })
            return Disposables.create()
        }
    }
    
    /*
     get stranger thinh stream
    */
    func getStrangerThinh() -> Observable<Thinh> {
        return Observable<Thinh>.create({ (subcriber) -> Disposable in
            self.thinhDb.queryEqual(toValue: self.userId()!, childKey: FirebaseKey.to).observe(.childAdded, with: { (snapshot) in
                guard let data = snapshot.value as? JSON else {
                    subcriber.onError(ThinhError.unknownUser)
                    return
                }
                let thinh = Thinh(json: data)!
                if !thinh.friend! {
                   subcriber.onNext(thinh)
                }
            })
            return Disposables.create()
        })
    }
    
    /*
     current user tha thinh user A
    */
    func thathinh(_ A: UserId) {
        thathinh(A: A, B: userId()!)
    }
    
    /*
     user B tha thinh user A, also for test
    */
    fileprivate func thathinh(A: UserId, B: UserId) {
        hasRecieveThinhFrom(A).subscribe(onNext: { (thinh) in
            if let thinh = thinh {
                self.checkIfConversationExist(between: A, B: B).subscribe(onNext: { (conversationId) in
                    var id: ConversationId!
                    let A = thinh.to!
                    let B = thinh.from!
                    if conversationId != nil {
                        id = conversationId
                    } else {
                        id = self.createNewConversation(forUser: A, andUser: B)
                    }
                    self.sendBotMessage(id: id, user1: A, user2: B)
                    self.sendMessage(id: id, message: Message(thinh: thinh))
                })
            } else {
                let thinh = self.createThinhPackage(for: A, with: nil, with: nil)
                self.checkFriendRelationship(between: self.userId()!, and: A).subscribe(onNext: { (friend) in
                    thinh.friend = friend
                    self.setThinhPackage(thinh)
                })
            }
        })
    }
    
    /*
     current user tha thinh user A with image
    */
    func thathinh(_ A: UserId, image: UIImage) {
        // TODO: Implement in the future
//        uploadImage(image).subscribe(onNext: { (url) in
//            createThin
//        })
    }
    
    
    /*
     check if current have recieve thinh from user A, return that thinh
    */
    fileprivate func hasRecieveThinhFrom(_ A: UserId) -> Observable<Thinh?> {
        return Observable<Thinh?>.create({ (subcriber) -> Disposable in
            self.userThinhDb.child(self.userId()!).observeSingleEvent(of: .value, with: { (snapshot) in
                if snapshot.hasChild(A) {
                    let id = snapshot.childSnapshot(forPath: A).value as! ThinhId
                    self.thinhDb.child(id).observeSingleEvent(of: .value, with: { (snapshot) in
                        subcriber.onNext(Thinh(json: snapshot.value as! JSON))
                    })
                } else {
                    subcriber.onNext(nil)
                }
            })
            return Disposables.create()
        })
    }
    
    /*
     create thinh package from current user to user A
    */
    func createThinhPackage(for A: UserId, with message: String?, with media: URL?) -> Thinh {
        let key = thinhDb.childByAutoId().key
        let thinh = Thinh().withTo(A).withMessage(message).withMedia(media).withId(key)
        return thinh
    }
    
    /*
     set thinh package to database
    */
    fileprivate func setThinhPackage(_ thinh: Thinh) {
        thinhDb.child(thinh.id!).setValue(thinh.toJSON())
        userThinhDb.child(thinh.to!).child(userId()!).setValue(thinh.date)
    }
    
    
    /*
     upload image and return back an url
    */
    fileprivate func uploadImage(_ image: UIImage) -> Observable<URL> {
        return Observable<URL>.create({ (subcriber) -> Disposable in
            let data = UIImageJPEGRepresentation(image, 0.2)
            let name = "\(Date.currentTimeInMillis()).jpg"
            self.storage.child(name).put(data!, metadata: nil, completion: { (metadata, error) in
                guard error == nil else {
                    return
                }
                subcriber.onNext((metadata?.downloadURL())!)
            })
            return Disposables.create()
        })
        
    }
    
    /*
     delete current user's thinh package with id
    */
    fileprivate func deleteThinh(_ id: ThinhId) {
        self.thinhDb.child(id).setValue(nil)
        self.userThinhDb.child(userId()!).child(id).setValue(nil)
    }
    
//    fileprivate
    
    /*
     call this when close the app
    */
    func stop() {
        database.removeAllObservers()
    }
    
}


extension Api {
    func createMockData() {
        deleteDb()
        let users = createMockUser()
        for i in 0..<users.count - 1 {
            let id = createMockConversation(user1: users[i].id!, user2: users[i+1].id!)
            createMockMessage(user1: users[i].id!, user2: users[i+1].id!, id: id)
        }
        
        // friend: 0 - 1, 1 - 2, 2 - 3, 3 - 4
        
        // case not friend, tha thinh each other
        createMockThinh(users[0].id!, users[3].id!)
        // case friend, one tha
        createMockThinh(users[0].id!, users[1].id!)
        // case friend, both tha
        createMockThinh(users[1].id!, users[2].id!)
        createMockThinh(users[2].id!, users[1].id!)

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
            userDb.child(user.id!).setValue(user.toJSON()!)
            createUser(user.id!,
                       user: user)
        }
        return users
    }
    
    
    private func createMockConversation(user1: UserId, user2: UserId) -> ConversationId {
        return createNewConversation(forUser: user1, andUser: user2)
    }
    
    private func createMockMessage(user1: UserId, user2: UserId, id: ConversationId) {
        let messages = Message.mock(from: user1, to: user2)
        for message in messages {
            sendMessage(id: id, message: message)
        }
    }
    
    private func createMockThinh(_ from: UserId, _ to: UserId) {
        thathinh(A: to, B: from)
        
    }
    
    private func test() {
        
    }
}
