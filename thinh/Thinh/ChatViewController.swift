//
//  ChatViewController.swift
//  Thinh
//
//  Created by Viet Dang Ba on 3/22/17.
//  Copyright © 2017 coderschool. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import AFNetworking

class ChatViewController: JSQMessagesViewController {
    
    lazy var outgoingBubbleImageView: JSQMessagesBubbleImage = self.setupOutgoingBubble()
    lazy var incomingBubbleImageView: JSQMessagesBubbleImage = self.setupIncomingBubble()
    
    var conversation:Conversation?
    
    var senderAvatar:URL?
    
    var current_user:User?
    
    var messages = [JSQMessage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
            self.current_user = User.currentUser
            
            self.senderDisplayName = self.current_user?.name
            self.senderAvatar = URL(string: (self.current_user?.avatar)!)
            self.senderId = self.current_user?.id

            self.title = conversation?.partnerName
        
        collectionView?.collectionViewLayout.incomingAvatarViewSize = CGSize(width: kJSQMessagesCollectionViewAvatarSizeDefault, height:kJSQMessagesCollectionViewAvatarSizeDefault )
        collectionView?.collectionViewLayout.outgoingAvatarViewSize = CGSize(width: kJSQMessagesCollectionViewAvatarSizeDefault, height:kJSQMessagesCollectionViewAvatarSizeDefault )
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    
        observeMessages()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
    }
    
    private func addMessage(withId id: String, name: String, text: String) {
        if let message = JSQMessage(senderId: id, displayName: name, text: text) {
            messages.append(message)
        }
    }
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
       
        // Handle sending new message here
        //let newMessage = Message(from: (self.current_user?.id)!, to: (self.conversation?.partnerID)!, message: text)
        //Api.shared().sendMessage(id: (self.conversation?.id)!, message: newMessage)
        Api.shared().sendMessage(to: (self.conversation?.partnerID)!, conversation: (self.conversation?.id)!, text: text)
        
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        
        finishSendingMessage()
    }
    
    private func observeMessages() {
        // Query messages
        Api.shared().getMessageOfConversation(id: (self.conversation?.id)!).subscribe(onNext: { messages in
            self.messages.removeAll()
            for message in messages {
                if(message.from == self.current_user?.id){
                    self.addMessage(withId: message.from!, name : (self.current_user?.name)!, text: message.message!)
                } else {
                    self.addMessage(withId: message.from!, name : (self.conversation?.partnerName)!, text: message.message!)
                }
                
            }
            self.finishReceivingMessage()
        })
        
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        let message = messages[indexPath.item]
        

        var imageDataSource:JSQMessageAvatarImageDataSource?
        let ImageView = UIImageView()
        
        if(message.senderId == self.current_user?.id){
            ImageView.setImageWith(URLRequest(url: self.senderAvatar!), placeholderImage: nil, success: { (_, _, image) in
                imageDataSource = JSQMessagesAvatarImageFactory.avatarImage(with: image, diameter: 30)
            }) { (_, _, error) in
                
            }
        } else if (message.senderId == ""){
            // Handle Bot message
        } else {
            // Handler partner image
            ImageView.setImageWith(URLRequest(url: (conversation?.partnerAvatar)!), placeholderImage: nil, success: { (_, _, image) in
                imageDataSource = JSQMessagesAvatarImageFactory.avatarImage(with: image, diameter: 30)
            }) { (_, _, error) in
                
            }
        }
    
        return imageDataSource
    }
    
    
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    private func setupOutgoingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
    }
    
    private func setupIncomingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = messages[indexPath.item]
        if message.senderId == self.senderId {
            return outgoingBubbleImageView
        } else {
            return incomingBubbleImageView
        }
    }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        let message = messages[indexPath.item]
        
        if message.senderId == senderId {
            cell.textView?.textColor = UIColor.white
        } else {
            cell.textView?.textColor = UIColor.black
        }
        return cell
    }
    
    
    @IBAction func onBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
