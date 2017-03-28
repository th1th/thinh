//
//  ConversationViewCell.swift
//  Thinh
//
//  Created by Viet Dang Ba on 3/23/17.
//  Copyright © 2017 coderschool. All rights reserved.
//

import UIKit
import NSDate_TimeAgo
import JSQMessagesViewController

class ConversationViewCell: UITableViewCell {

    @IBOutlet weak var partnerImg: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var lastMessageLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var thinhImg: UIImageView!
    
    @IBOutlet weak var statusImage: UIImageView!
    var conversation : Conversation? {
        didSet{
            if conversation?.partnerAvatar != nil {
                partnerImg.setImageWith(URLRequest(url: (conversation?.partnerAvatar)!), placeholderImage: nil, success: { (_, _, image) in
                    self.partnerImg.image = JSQMessagesAvatarImageFactory.avatarImage(with: image, diameter: 60).avatarImage
                    self.nameLabel.text = self.conversation?.partnerName
                    
                    // Handle online/offline
                }) { (_, _, error) in
                    
                }
            } else {
                self.nameLabel.text = ""
            }
            

            lastMessageLabel.text = conversation?.lastMessage
            
            // Handle time interval
            let timeAgo = NSDate(timeIntervalSince1970: (conversation?.lastTime)!)
            timeLabel.text = timeAgo.dateTimeAgo()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
