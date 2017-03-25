//
//  ConversationViewCell.swift
//  Thinh
//
//  Created by Viet Dang Ba on 3/23/17.
//  Copyright © 2017 coderschool. All rights reserved.
//

import UIKit
import NSDate_TimeAgo

class ConversationViewCell: UITableViewCell {

    @IBOutlet weak var partnerImg: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var lastMessageLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var thinhImg: UIImageView!
    
    var conversation : Conversation? {
        didSet{
            partnerImg.setImageWith((conversation?.partnerAvatar)!)
            nameLabel.text = conversation?.partnerName
            lastMessageLabel.text = conversation?.lastMessage
            
            // Handle time interval
            //timeLabel.text = conversation?.lastTime
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
