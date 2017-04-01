//
//  ContactTableViewCell.swift
//  Thinh
//
//  Created by Linh Le on 3/26/17.
//  Copyright © 2017 coderschool. All rights reserved.
//

import UIKit

class ContactTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var statusImage: UIImageView!
    
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var ThaThinhButton: UIButton!
    var user:User!
    
    @IBAction func onClickThaThinhButton(_ sender: UIButton) {
        print("[xx]thathinh \(user.name)")
        Api.shared().thathinh((user?.id)!)
        UIView.transition(with: self.ThaThinhButton.imageView!,
                          duration: 0.3,
                          options: .transitionCrossDissolve,
                          animations: {
                            self.ThaThinhButton.imageView?.image = UIImage(named: "ThaThinh")
        },
                          completion: nil)
        
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
