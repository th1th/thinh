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
    
    var senderImage = UIImage()
    var botImage = UIImage()
    var partnerImage = UIImage()
    
    var conversation:Conversation?
    
    var senderAvatar:URL?
    
    var current_user:User?
    
    
    var messages = [JSQMessage]()
    
    var selectedImage : UIImage?
    
    private var localTyping = false
    var isTyping: Bool {
        get {
            return localTyping
        }
        set {
            localTyping = newValue
            // Update isTyping field in database
//            Api.shared().isTyping((self.conversation?.id)!, i
            Api.shared().setTyping((self.conversation?.id)!, typing: localTyping)
            
        }
    }
    
    func loadAvatarImage(){
        let SenderImageView = UIImageView()
        let BotImageView = UIImageView()
        let PartnerImageView = UIImageView()
        
        SenderImageView.af_setImage(withURL: self.senderAvatar!) { (reponse) in
            self.senderImage = reponse.result.value!
            self.collectionView.reloadData()
        }
    
        BotImageView.af_setImage(withURL: URL(string: User.botAvatar)!) { (response) in
            self.botImage = response.result.value!
            self.collectionView.reloadData()
        }
        
        PartnerImageView.af_setImage(withURL: (self.conversation?.partnerAvatar)!) { (reponse) in
            self.partnerImage = reponse.result.value!
            self.collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.current_user = User.currentUser
        
        self.senderDisplayName = self.current_user?.name
        self.senderAvatar = URL(string: (self.current_user?.avatar)!)
        self.senderId = self.current_user?.id
        
        let button =  UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        button.backgroundColor = UIColor(red: 217/255.0, green: 243/255.0, blue: 239/255.0, alpha: 1.0)
        button.setTitleColor(UIColor.black, for: .normal)
        button.setTitle(conversation?.partnerName, for: .normal)
        button.addTarget(self, action: #selector(self.clickOnTitle), for: .touchUpInside)
        self.navigationItem.titleView = button
        
        
        
        self.automaticallyScrollsToMostRecentMessage = true
        //self.inputToolbar.contentView.textView.becomeFirstResponder()
        
       
        
        collectionView?.collectionViewLayout.incomingAvatarViewSize = CGSize(width: kJSQMessagesCollectionViewAvatarSizeDefault, height:kJSQMessagesCollectionViewAvatarSizeDefault )
        collectionView?.collectionViewLayout.outgoingAvatarViewSize = CGSize(width: kJSQMessagesCollectionViewAvatarSizeDefault, height:kJSQMessagesCollectionViewAvatarSizeDefault )
        
        collectionView.collectionViewLayout.messageBubbleFont = UIFont(name: "HelveticaNeue-Light", size: 17)
        
        
        let imgBackground:UIImageView = UIImageView(frame: self.view.bounds)
        imgBackground.contentMode = UIViewContentMode.scaleAspectFill
        imgBackground.clipsToBounds = true
        //imgBackground.setImageWith(self.senderAvatar!)
        imgBackground.image = #imageLiteral(resourceName: "food")
        self.collectionView?.backgroundView = imgBackground
        
        self.navigationController?.navigationBar.tintColor = UIColor(red: 78/255.0, green: 221/255.0, blue: 200/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 217/255.0, green: 243/255.0, blue: 239/255.0, alpha: 1.0)

        observeMessages()
        
        observeTyping()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true) 
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        loadAvatarImage()
        self.scrollToBottom(animated: true)
        //self.inputToolbar.contentView.textView.becomeFirstResponder()
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
    
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
    
    private func observeMessages() {
        // Query messages
        Api.shared().getMessageOfConversation(id: (self.conversation?.id)!).subscribe(onNext: { message in
            
            var message_sender_name:String?
            
            if(message.from == self.current_user?.id){
                message_sender_name = self.current_user?.name
            } else if( message.from == self.conversation?.partnerID) {
                message_sender_name = self.conversation?.partnerName
            } else {
                message_sender_name = ""
            }
            
            // handle media message here
            if(message.media == nil){
                self.addMessage(withId: message.from!, name : message_sender_name!, text: message.message!)
            } else {
                self.addPhotoMessage(withId: message.from!, name: message_sender_name!, mediaItem: AsyncPhotoMediaItem(withURL: message.media! as NSURL, isOperator: (message.from == self.current_user?.id)))
                if let text = message.message {
                    self.addMessage(withId: message.from!, name : message_sender_name!, text: text)
                }
            }
            
            
            self.finishReceivingMessage()

        })
        
    }
    
    
    override func didPressAccessoryButton(_ sender: UIButton) {
        let picker = ImagePickerController()
        picker.delegate = self
        picker.imageLimit = 1
        present(picker, animated: true, completion:nil)
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        let message = messages[indexPath.item]
        
        
        var imageDataSource:JSQMessageAvatarImageDataSource?
        
        if(message.senderId == self.current_user?.id){
            imageDataSource = JSQMessagesAvatarImageFactory.avatarImage(with: self.senderImage, diameter: 30)
        } else if (message.senderId == self.conversation?.partnerID){
            imageDataSource = JSQMessagesAvatarImageFactory.avatarImage(with: self.partnerImage, diameter: 30)
            
        } else {
            imageDataSource = JSQMessagesAvatarImageFactory.avatarImage(with: self.botImage, diameter: 30)
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
        return bubbleImageFactory!.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleGreen())
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
        
        if currentMessage.senderId != self.conversation?.partnerID {
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
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, attributedTextForCellTopLabelAt indexPath: IndexPath) -> NSAttributedString? {

        if (self.messages[indexPath.item].senderId != current_user?.id && self.messages[indexPath.item].senderId != conversation?.partnerID){
            let text = "\u{1F496}"
            let attribs = [
                NSFontAttributeName: UIFont.boldSystemFont(ofSize: 18),
                NSForegroundColorAttributeName: UIColor.lightGray
                ] as [String : Any]
            
            return NSAttributedString(string: text, attributes: attribs)
        } else {
            return nil
        }
        
        
        
    }
    override func collectionView(_ collectionView: JSQMessagesCollectionView, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout, heightForCellTopLabelAt indexPath: IndexPath) -> CGFloat {
        if (self.messages[indexPath.item].senderId != current_user?.id && self.messages[indexPath.item].senderId != conversation?.partnerID){
            return kJSQMessagesCollectionViewCellLabelHeightDefault + 5
        } else {
            return 0.0
        }
        

    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, didTapMessageBubbleAt indexPath: IndexPath!) {
        if let media = messages[(indexPath.row)].media as? AsyncPhotoMediaItem{
           // Go to full screen
            if let image = media.imgView.image {
                selectedImage = image
                performSegue(withIdentifier: "fullImage", sender: self)
            }
        }
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, didTapAvatarImageView avatarImageView: UIImageView!, at indexPath: IndexPath!) {
        if(messages[(indexPath.row)].senderId == conversation?.partnerID){
            performSegue(withIdentifier: "UserDetail", sender: self)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "fullImage"){
            let destView = segue.destination as! ImageViewController
            destView.image = selectedImage
        } else if(segue.identifier == "UserDetail"){
            let destView = segue.destination as! UserDetailViewController
            destView.user = self.conversation?.partner
            destView.showCloseButton = false
        }
        
        
    }
    
    // handle isTyping
    
    private func observeTyping() {

        // Inside observe block
        // set self.showTypingIndicator
        // scroll to bottom
        Api.shared().observeIsTyping((self.conversation?.id!)!).subscribe(onNext: { (user, typing) in
            print("User ID \(user)")
            if(user == self.conversation?.partnerID){
                self.showTypingIndicator = typing
                self.scrollToBottom(animated: true)
            }
        })
    
    }
    override func textViewDidChange(_ textView: UITextView) {
        super.textViewDidChange(textView)
        // If the text is not empty, the user is typing
        isTyping = textView.text != ""
    }
    
    func clickOnTitle(button: UIButton) {
        performSegue(withIdentifier: "UserDetail", sender: self)
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

extension ChatViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func addTapGestures() {
        let gesture = UITapGestureRecognizer(target: self, action: Selector("tapAndHideKeyboard:"))
        gesture.delegate = self
        self.collectionView.addGestureRecognizer(gesture)
    }
    
    func tapAndHideKeyboard(gesture: UITapGestureRecognizer) {
        print("Tap")
        if(gesture.state == UIGestureRecognizerState.ended) {
            if(self.inputToolbar.contentView.textView.isFirstResponder) {
                self.inputToolbar.contentView.textView.resignFirstResponder()
            }
        }
    }
}

