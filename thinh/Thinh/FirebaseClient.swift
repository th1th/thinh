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
import SCRecorder
import FBSDKCoreKit

class Api: NSObject {
    
    fileprivate var database: FIRDatabaseReference
    fileprivate var userDb: FIRDatabaseReference
    fileprivate var thinhDb: FIRDatabaseReference
    fileprivate var conversationDb: FIRDatabaseReference
    fileprivate var userFriendDb: FIRDatabaseReference
    fileprivate var userThinhDb: FIRDatabaseReference
    fileprivate var userConversationDb: FIRDatabaseReference
    fileprivate var storage: FIRStorageReference
    fileprivate var conversationStorage: FIRStorageReference
    fileprivate var matchDb: FIRDatabaseReference
    fileprivate var dataStorage: FIRStorageReference
    
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
        matchDb = database.child(FirebaseKey.match)
        storage = FIRStorage.storage().reference()
        conversationStorage = storage.child(FirebaseKey.conversation)
        dataStorage = storage.child(FirebaseKey.data)
    }
    
    func userId() -> String? {
//        return FIRAuth.auth()?.currentUser?.uid   // me
//        return "WR3OioP6R0UTPUoWItWyJX5g4p62" // Linh Le
//        return "S5cirBWXUiOGnareVEEWbjaIJN02" // Harley
//        return "VUoc532PABTXwHAc5ceaIAtem9D2" // Mark
//        return "3JqA5vuaFhMbd8bS5Y82RSB9G092"   // Donald Trump
//        return "SyHSwBEV7zYR1FEzuqBTevOJVsH3"
//        return "cdP7J0LNP2gUG3BeEq29N8JHDt72" // Dang Viet
        return "tpe0qfm577eZ3VgCaatP42cPk2n2"    // Kim Lien
    }

    /*
     login with facebook
    */
    func login(accessToken: String) -> Observable<Bool> {
        return loginWithFacebook(accessToken)
    }

    // TODO: get user info from facebook
    fileprivate func loginWithFacebook(_ accessToken: String) -> Observable<Bool> {
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
                self.isUserExist(user.uid).subscribe(onNext: { (exist) in
                    if !exist {
                        self.createUser(user.uid, user: User(user: user))
                    }
                })
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
        updateUserStatus(false)
        do {
            LoginManager().logOut()
            try FIRAuth.auth()?.signOut()
            UserDefaults.standard.set(nil, forKey: "Thinh_CurrentUser")
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "didLogOut"), object: nil)
    }
    
    /*
     check if user login for first time
    */
    fileprivate func isUserExist(_ id: UserId) -> Observable<Bool> {
        return Observable.create({ (subcriber) -> Disposable in
            self.userDb.observeSingleEvent(of: .value, with: { (snapshot) in
                if snapshot.hasChild(id) {
                    subcriber.onNext(true)
                } else {
                    subcriber.onNext(false)
                }
            })
            return Disposables.create()
        })
    }
    
    /*
     update the current user status: online and offline
     use when user open and close the app
    */
    func updateUserStatus(_ status: Bool) {
        userDb.child(userId()!).updateChildValues(["status": status]) { (error, reference) in
            if error != nil {
                print(error!.localizedDescription)
            }
        }
    }
    
    fileprivate func createUser(_ id: UserId, user: User)  {
        userDb.child(id).setValue(user.toJSON()) { (error, reference) in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
        }
    }
    
    /*
     update user info
    */
    func updateUser(_ user: User) {
        userDb.child(user.id!).updateChildValues(user.toJSON()!)
    }
    
    /*
     update user image
    */
    func updateAvatar(_ avatar: UIImage) {
        uploadImage(avatar).subscribe(onNext: { (url) in
            self.userDb.child(self.userId()!).updateChildValues([FirebaseKey.avatar: url.absoluteString])
        })
    }
    
    /*
     update user cover
    */
    func updateUserCover(_ cover: UIImage) {
        uploadImage(cover).subscribe(onNext: { (url) in
            self.userDb.child(self.userId()!).updateChildValues([FirebaseKey.cover: url.absoluteString])
        })
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
            self.userConversationDb.child(self.userId()!).observe(.value, with: { snapshot in
                var conversations = [Conversation]()
                print(snapshot)
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
     update cover for conversation
    */
    func updateCover(_ cover: UIImage, forConversation id: ConversationId) {
        uploadImage(cover).subscribe(onNext: { (url) in
            self.conversationDb.child(id).child(FirebaseKey.cover).setValue(url.absoluteString)
        })
    }
    
    /*
     get conversation cover 
    */
    func getCoverForConversation(_ id: ConversationId) -> Observable<URL>{
        return Observable<URL>.create({ (subcriber) -> Disposable in
            self.conversationDb.child(id).child(FirebaseKey.cover).observeSingleEvent(of: .value, with: { (snapshot) in
                guard let url = URL(string: snapshot.value as! String) else {
                    subcriber.onError(ThinhError.unknownUser)
                    return
                }
                subcriber.onNext(url)
            })
            return Disposables.create()
        })
    }
    
    
    /*
     create new conversation when 2 user matched:
        - stranger dop thinh
        - both friend tha thinh
    */
    func createNewConversation(forUser: UserId, andUser: UserId) -> ConversationId {
        let key = conversationDb.childByAutoId().key
        createFriendRelationship(between: forUser, and: andUser)
        conversationDb.child(key).child(FirebaseKey.cover).setValue(Conversation.randomCover())
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
    func setTyping(_ conversation: ConversationId, typing: Bool) {
        conversationDb.child(conversation).child(FirebaseKey.isTyping).child(userId()!).setValue(typing)
    }
    
    /*
     send the userId of typing user
    */
    func observeIsTyping(_ conversation: ConversationId) -> Observable<(UserId, Bool)> {
        return Observable<(UserId, Bool)>.create({ (subcriber) -> Disposable in
            self.conversationDb.child(conversation).child(FirebaseKey.isTyping).observe(.childChanged, with: { (snapshot) in
                guard let isTyping = snapshot.value as? Bool else {
                    return
                }
                subcriber.onNext((snapshot.key, isTyping))
                
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
            self.conversationDb.child(id).child(FirebaseKey.messages).observe(.childAdded, with: { snapshot in
                if let message = Message(json: snapshot.value as! JSON) {
                    print(message.message)
                    print(message.media)
                    print("----------")
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
        let key = conversationDb.child(id).child(FirebaseKey.messages).childByAutoId().key
        // create new message
        conversationDb.child(id).child(FirebaseKey.messages).child(key).setValue(message.toJSON())
        // update user conversation
        if (message.message != nil) {
            // update last message
            let conversation = Conversation(id: id, message: message.message, time: message.date)
            userConversationDb.child(message.user1!).child(message.user2!).setValue(conversation.withUser(message.user2!).withSeen(true).toJSON())
            userConversationDb.child(message.user2!).child(message.user1!).setValue(conversation.withUser(message.user1!).withSeen(false).toJSON())
        }   // photo message don't update last message
        return key
    }
    
    /*
     current user has seen new message from user B
    */
    func hasSeenConversation(_ conversation: ConversationId, from B: UserId) {
        user(userId()!, hasSeenConversation: conversation, from: B)
    }
    
    /*
    User A has seen this conversation
    */
    fileprivate func user(_ A: UserId, hasSeenConversation conversation: ConversationId, from B: UserId) {
        self.userConversationDb.child(A).child(B).updateChildValues([FirebaseKey.seen: true])
    }
    
    /*
     send message with image
    */
    func sendMessage(to A: UserId, conversation: ConversationId, image: UIImage) {
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
        let message = Message(from: User.botId, to: user1, message: FirebaseKey.botMessage)
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
            self.getFriendIdOf(user: id).subscribe(onNext: { (id) in
                self.userDb.child(id).observe(.value, with: { (snapshot) in
                    guard let data = snapshot.value as? JSON else {
                        subcriber.onError(ThinhError.unknownUser)
                        return
                    }
                    guard let user = User(json: data) else {
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
    fileprivate func getFriendIdOf(user: UserId) -> Observable<UserId> {
        return Observable<UserId>.create { (subcriber) -> Disposable in
            self.userFriendDb.child(user).observe(.childAdded, with: { (snapshot) in
                subcriber.onNext(snapshot.key)
            })
            
            return Disposables.create()
        }
    }
    
    /*
     get all friend id one all the time
     */
    fileprivate func getFriendIdsOf(user: UserId) -> Observable<[UserId]> {
        return Observable<[UserId]>.create { (subcriber) -> Disposable in
            self.userFriendDb.child(user).observeSingleEvent(of: .value, with: { (snapshot) in
                guard let data = snapshot.value as? [UserId: TimeInterval] else {
                    subcriber.onError(ThinhError.unknownUser)   // FIXME
                    return
                }
                var keys = [UserId]()
                for datum in data {
                    keys.append(datum.key)
                }
                subcriber.onNext(keys)
            })
            
            return Disposables.create()
        }
    }
    
    /*
     get stranger related to me
    */
    func getMyStrangerList() -> Observable<User> {
        return getStrangerOf(userId()!)
    }
    
    /*
     get stranger related to user id
    */
    fileprivate func getStrangerOf(_ id: UserId) -> Observable<User> {
        return Observable<User>.create({ (subcriber) -> Disposable in
            self.getFriendIdsOf(user: id).subscribe(onNext: { (users) in
                
                self.getAllUser().subscribe(onNext: { (user) in
                    if !users.contains(user.id!) && user.id! != User.botId {
                        subcriber.onNext(user)
                    }
                })
            })
            return Disposables.create()
        })
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
                subcriber.onCompleted()
            })
            return Disposables.create()
        }
    }
    
    func getMyStrangerThinh() -> Observable<Thinh> {
        return getStrangerThinh(userId()!)
    }
    
    /*
     get stranger thinh stream
    */
    func getStrangerThinh(_ id: UserId) -> Observable<Thinh> {
        return Observable<Thinh>.create({ (subcriber) -> Disposable in
            self.thinhDb.child(id).observe(.childAdded, with: { (snapshot) in
                guard let data = snapshot.value as? JSON else {
                    subcriber.onError(ThinhError.unknownThinh)
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
     current user dop thinh from user A, also tha thinh user A back
    */
    func dopthinh(_ A: UserId) {
        thathinh(A)
    }
    
    /*
     current user tha thinh user A only, also dop thinh
    */
    func thathinh(_ A: UserId) {
        thathinh(A: A, B: userId()!, message: nil)
        
    }
    
    /*
     current user tha thinh user A with image
     */
    func thathinh(_ A: UserId, image: UIImage) {
        uploadImage(image).subscribe(onNext: { (url) in
            let message = Message(from: self.userId()!, to: A, media: url)
            self.thathinh(A: A, B: self.userId()!, message: message)
        }, onError: { (error) in
            print("thathing \(error.localizedDescription)")
        }, onCompleted: {
            print("thathinh complete")
        }, onDisposed: nil)
    }
    
    func thathinh(_ A: UserId, video: String) {
        // TODO: implement
    }
    
    /*
     current user tha thinh user A with message
    */
    func thathinh(_ A: UserId, message: String) {
        let message = Message(from: userId()!, to: A, message: message)
        thathinh(A: A, B: userId()!, message: message)
    }
    
    func thathinh(_ A: UserId, message: String, image: UIImage) {
        uploadImage(image).subscribe(onNext: { (url) in
            let sms = Message(from: self.userId()!, to: A, message: message, media: url)
            self.thathinh(A: A, B: self.userId()!, message: sms)
        }, onError: { (error) in
            print("thathing \(error.localizedDescription)")
        }, onCompleted: { 
            print("thathinh complete")
        }, onDisposed: nil)
    }
    
    /*
     user B tha thinh user A, also for test, with message as wrapper
    */
    fileprivate func thathinh(A: UserId, B: UserId, message: Message?) {
        has(B, recievedThinhFrom: A).subscribe(onNext: { (thinh) in
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
                    if thinh.hasSomething() {
                        self.sendMessage(id: id, message: Message(thinh: thinh))
                    }
                    if message != nil {
                        self.sendMessage(id: id, message: message!)
                    }
//                    self.sendMatchNotification(for: thinh, message: message)
                    self.deleteThinh(B, to: A)
                })
            } else {
                let thinh = self.createThinhPackage(from: B, to: A, with: message?.message, with: message?.media)
                self.checkFriendRelationship(between: B, and: A).subscribe(onNext: { (friend) in
                    thinh.friend = friend
                    self.setThinhPackage(thinh)
                })
            }
        })
    }
    
    
    /*
     check if current have recieve thinh from user A, return that thinh
    */
    fileprivate func has(_ B: UserId, recievedThinhFrom A: UserId) -> Observable<Thinh?> {
        return Observable<Thinh?>.create({ (subcriber) -> Disposable in
            self.thinhDb.child(B).observeSingleEvent(of: .value, with: { (snapshot) in
                if snapshot.hasChild(A) {
                    let data = snapshot.childSnapshot(forPath: A)
                    subcriber.onNext(Thinh(json: data.value as! JSON))
                } else {
                    subcriber.onNext(nil)
                }
                subcriber.onCompleted()

            })
            return Disposables.create()
        })
    }
    
    /*
     create thinh package from current user to user A
    */
    fileprivate func createThinhPackage(from B: UserId, to A: UserId, with message: String?, with media: URL?) -> Thinh {
        let thinh = Thinh().withFrom(B).withTo(A).withMessage(message).withMedia(media)
        return thinh
    }
    
    /*
     set thinh package to database
    */
    fileprivate func setThinhPackage(_ thinh: Thinh) {
        thinhDb.child(thinh.to!).child(thinh.from!).setValue(thinh.toJSON())
    }
    
    /*
     send the match notification to both user
    */
//    fileprivate func sendMatchNotification(for thinh: Thinh, message: Message?) {
//        let key = matchDb.childByAutoId().key
//        let match = Match(key).withAMessage(thinh.message).withAMedia(thinh.media).withBMessage(message?.message).withBMedia(message?.media)
//        
//        self.getUser(id: thinh.from!).flatMap { (user) -> Observable<User> in
//            match.withAName(user.name!).withAAvatar(user.avatar!)
//            return self.getUser(id: thinh.to!)
//        }.subscribe(onNext: { (user) in
//            match.withBName(user.name!).withBAvatar(user.avatar!)
//            self.matchDb.child(thinh.to!).child(match.id!).setValue(match.toJSON())
//            self.matchDb.child(thinh.from!).child(match.id!).setValue(match.toJSON())
//        })
//        
//    }
    
    /*
     observe match notification of me
    */
//    func observeMyMatchNotification() -> Observable<Match> {
//        return observeMatchNotification(userId()!)
//    }
    
    
    /*
     observe match notification
    */
//    fileprivate func observeMatchNotification(_ userId: UserId) -> Observable<Match> {
//        return Observable<Match>.create({ (subcriber) -> Disposable in
//            self.matchDb.child(userId).observe(.childAdded, with: { (snapshot) in
//                guard let match = Match(json: snapshot.value as! JSON) else {
//                    return
//                }
//                subcriber.onNext(match)
//            })
//            return Disposables.create()
//        })
//    }
    
    /*
     delete match notification of current user
    */
    func deleteMyMatch(_ matchId: MatchId) {
        deleteMatch(userId()!, matchId)
    }
    
    /*
     delete match notification of user
    */
    fileprivate func deleteMatch(_ userId: UserId, _ matchId: MatchId) {
        matchDb.child(userId).child(matchId).setValue(nil)
    }
    
    
    /*
     upload image and return back an url
    */
    fileprivate func uploadImage(_ image: UIImage) -> Observable<URL> {
        return Observable<URL>.create({ (subcriber) -> Disposable in
            let data = UIImageJPEGRepresentation(image, 0.2)
            let name = "\(Date.currentTimeInMillis()).jpg"
            self.dataStorage.child(name).put(data!, metadata: nil, completion: { (metadata, error) in
                guard error == nil else {
                    subcriber.onError(error!)
                    return
                }
                guard let url = metadata?.downloadURL as? URL  else {
                    subcriber.onError(ThinhError.uploadImageFailed)
                    return
                }
                
                subcriber.onNext(url)
            })
            return Disposables.create()
        })
        
    }
    
    fileprivate func uploadVideo(_ video: String) {
        // TODO: upload video from file path
        
    }
    
    /*
     delete current user's thinh from User
     */
    func dropThinh(_ from: UserId) {
        deleteThinh(from, to: userId()!)
    }
    
    
    fileprivate func deleteThinh(_ from: UserId, to:UserId) {
        self.thinhDb.child(to).child(from).setValue(nil)
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
        for i in 0..<users.count - 5 {
            for j in 0..<5 {
                let id = createMockConversation(user1: users[i].id!, user2: users[i+j+1].id!)
                createMockMessage(user1: users[i].id!, user2: users[i+j+1].id!, id: id)
            }
            if i != 0 && i % 2 == 0 {
                createMockThinh(users[i].id!, users[0].id!)
                
            }
            if i != 1  && i % 2 == 1 {
                createMockThinh(users[i].id!, users[1].id!)
            }
            if i != 17 && i % 3 == 0 {

                createMockThinh(users[i].id!, users[17].id!)
            }
        }
    }

    
    private func deleteDb() {
        database.setValue(nil)
    }
    
    
    private func createMockUser()  -> [User] {
        let bot = User.createBot()
        createUser(bot.id!, user: bot)
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
        let messages = Message.mock(from: user1, to: user2, i: Int(arc4random_uniform(10)))
        for message in messages {
            sendMessage(id: id, message: message)
        }
    }

    private func createMockThinh(_ from: UserId, _ to: UserId) {
        thathinh(A: to, B: from, message: nil)
    }
    
    func createMockThinh(_ from: UserId, _ to: UserId, message: String) {
        var sms: Message? = nil
        sms = Message(from: from, to: to, message: message)
        thathinh(A: to, B: from, message: sms)
    }
    
    fileprivate func createMockThinh(_ from: UserId, _ to: UserId, message: String, image: UIImage) {
        self.uploadImage(image).subscribe(onNext: { (url) in
            let sms = Message(from: from, to: to, message: message, media: url)
            self.thathinh(A: to, B: from, message: sms)
        })
    }
    
    fileprivate func createMockThinh(_ from: UserId, _ to: UserId, image: UIImage) {
        self.uploadImage(image).subscribe(onNext: { (url) in
            let message = Message(from: from, to: to, media: url)
            self.thathinh(A: to, B: from, message: message)
        })
    }
    
    private func test() {
        
    }
}
