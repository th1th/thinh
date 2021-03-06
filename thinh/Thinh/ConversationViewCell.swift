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
            partnerImg.image = nil
            nameLabel.text = ""
            lastMessageLabel.text = ""
            timeLabel.text = ""
            statusImage.image = nil
            
            // Check seen here
            if(conversation?.seen)!{
                lastMessageLabel.textColor = UIColor.lightGray
                timeLabel.textColor = UIColor.lightGray
                
                nameLabel.font = UIFont.systemFont(ofSize: 15, weight: UIFontWeightMedium)
            } else {
                lastMessageLabel.textColor = UIColor.black
                lastMessageLabel.font = UIFont.systemFont(ofSize: 13, weight: UIFontWeightMedium)
                
                timeLabel.textColor = UIColor.black
                timeLabel.font = UIFont.systemFont(ofSize: 13, weight: UIFontWeightMedium)
                
                nameLabel.font = UIFont.systemFont(ofSize: 15, weight: UIFontWeightBold)
            }
            
            if conversation?.partnerAvatar != nil {
                partnerImg.setImageWith(URLRequest(url: (conversation?.partnerAvatar)!), placeholderImage: nil, success: { (_, _, image) in
                    self.partnerImg.image = JSQMessagesAvatarImageFactory.avatarImage(with: image, diameter: 60).avatarImage
                    self.nameLabel.text = self.conversation?.partnerName
                    
                    self.statusImage.layer.borderColor = UIColor.white.cgColor
                    self.statusImage.layer.borderWidth = 2.0
                    self.statusImage.layer.cornerRadius = self.statusImage.frame.height/2
                    // Handle online/offline
                    if let is_online = self.conversation?.partnerOnline {
                        if(is_online){
                            self.statusImage.image = #imageLiteral(resourceName: "online")
                        } else {
                            self.statusImage.image = #imageLiteral(resourceName: "offline")
                        }
                        
                    } else {
                        self.statusImage.image = #imageLiteral(resourceName: "offline")
                    }
                    
                }) { (_, _, error) in
                    
                }
            } else {
                self.nameLabel.text = ""
            }
            

            lastMessageLabel.text = conversation?.lastMessage
            print("Time \(conversation?.lastTime)")
            // Handle time interval
            let timeAgo = NSDate(timeIntervalSince1970: ((conversation?.lastTime)!/1000))
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
