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
import Photos
import ImagePicker



class ChatViewController: JSQMessagesViewController {
    
    lazy var outgoingBubbleImageView: JSQMessagesBubbleImage = self.setupOutgoingBubble()
    lazy var incomingBubbleImageView: JSQMessagesBubbleImage = self.setupIncomingBubble()
    
    var conversation:Conversation?
    
    var senderAvatar:URL?
    
    var current_user:User?
    
    var messages = [JSQMessage]()
    
    private var localTyping = false
    var isTyping: Bool {
        get {
            return localTyping
        }
        set {
            localTyping = newValue
            // Update isTyping field in database
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.current_user = User.currentUser
        
        self.senderDisplayName = self.current_user?.name
        self.senderAvatar = URL(string: (self.current_user?.avatar)!)
        self.senderId = self.current_user?.id
        
        self.title = conversation?.partnerName
        
//        self.inputToolbar.contentView.textView.becomeFirstResponder()
        //self.hideKeyboard()
        
        collectionView?.collectionViewLayout.incomingAvatarViewSize = CGSize(width: kJSQMessagesCollectionViewAvatarSizeDefault, height:kJSQMessagesCollectionViewAvatarSizeDefault )
        collectionView?.collectionViewLayout.outgoingAvatarViewSize = CGSize(width: kJSQMessagesCollectionViewAvatarSizeDefault, height:kJSQMessagesCollectionViewAvatarSizeDefault )
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        observeMessages()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        //self.inputToolbar.contentView.textView.becomeFirstResponder()
        observeTyping()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.inputToolbar.contentView.textView.resignFirstResponder()
    }
    
    private func addMessage(withId id: String, name: String, text: String) {
        if let message = JSQMessage(senderId: id, displayName: name, text: text) {
            messages.append(message)
        }
    }
    
    private func addPhotoMessage(withId id: String, name: String, mediaItem: JSQPhotoMediaItem) {
        if let message = JSQMessage(senderId: id, displayName: "", media: mediaItem) {
            messages.append(message)
            collectionView.reloadData()
        }
    }
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        
        Api.shared().sendMessage(to: (self.conversation?.partnerID)!, conversation: (self.conversation?.id)!, text: text)
        
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        
        finishSendingMessage()
        isTyping = false
    }
    
    private func observeMessages() {
        // Query messages
        Api.shared().getMessageOfConversation(id: (self.conversation?.id)!).subscribe(onNext: { messages in
            self.messages.removeAll()
            
            var messsage_sender_name : String?
            for message in messages {
                if(message.from == self.current_user?.id){
                    messsage_sender_name = self.current_user?.name
                } else {
                    
                    messsage_sender_name = self.conversation?.partnerName
                }
                
                // handle media message here
                if(true){
                    self.addMessage(withId: message.from!, name : messsage_sender_name!, text: message.message!)
                } else {
                    //self.addPhotoMessage(withId: <#T##String#>, name: <#T##String#>, mediaItem: <#T##JSQPhotoMediaItem#>)
                }
                
            }
            self.finishReceivingMessage()
        })
        
    }
    
    
    override func didPressAccessoryButton(_ sender: UIButton) {
        let picker = ImagePickerController()
        picker.delegate = self
        picker.imageLimit = 1
//        if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)) {
//            picker.sourceType = UIImagePickerControllerSourceType.camera
//        } else {
//            picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
//        }
        
        present(picker, animated: true, completion:nil)
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
        let bubbleImageFactory = JSQMessagesBubbleImageFactory(bubble: UIImage.jsq_bubbleCompactTailless(), capInsets: UIEdgeInsets.zero)
        return bubbleImageFactory!.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
    }
    
    private func setupIncomingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory(bubble: UIImage.jsq_bubbleCompactTailless(), capInsets: UIEdgeInsets.zero)
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
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, attributedTextForMessageBubbleTopLabelAt indexPath: IndexPath) -> NSAttributedString? {
        let message = messages[indexPath.item]
        
        
        if message.senderId == self.senderId {
            return nil
        }
        
        return NSAttributedString(string: message.senderDisplayName)
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout, heightForMessageBubbleTopLabelAt indexPath: IndexPath) -> CGFloat {
        
        let currentMessage = self.messages[indexPath.item]
        
        if currentMessage.senderId == self.senderId {
            return 0.0
        }
        
        if indexPath.item - 1 > 0 {
            let previousMessage = self.messages[indexPath.item - 1]
            if previousMessage.senderId == currentMessage.senderId {
                return 0.0
            }
        }
        
        return kJSQMessagesCollectionViewCellLabelHeightDefault;
    }
    
    // handle isTyping
    
    private func observeTyping() {

        // Inside observe block
        // set self.showTypingIndicator
        // scroll to bottom self.scrollToBottom(animated: true)
    
    }
    override func textViewDidChange(_ textView: UITextView) {
        super.textViewDidChange(textView)
        // If the text is not empty, the user is typing
        isTyping = textView.text != ""
    }

    
    
    @IBAction func onBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onTap(_ sender: Any) {
        view.endEditing(true)
    }
}

extension ChatViewController: ImagePickerDelegate {
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]){
        imagePicker.dismiss(animated: true, completion: nil)
        let image = images[0]
        // Send photo message
        Api.shared().sendMessage(to: (self.conversation?.partnerID)!, conversation: (self.conversation?.id)!, image: image)
        
    }
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
    
    }
    
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]){
    
    }
    
}

extension UIViewController
{
    func hideKeyboard()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard()
    {
        print("Hrere ")
        view.endEditing(true)
    }
}
