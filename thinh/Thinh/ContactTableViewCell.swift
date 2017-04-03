//
//  ContactTableViewCell.swift
//  Thinh
//
//  Created by Linh Le on 3/26/17.
//  Copyright © 2017 coderschool. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer
import MobileCoreServices


@objc protocol ContactTableViewCellDelegate {
    @objc func contactTableViewCellDelegate(user: User)
}
class ContactTableViewCell: UITableViewCell,AVCapturePhotoCaptureDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var statusImage: UIImageView!
    
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var ThaThinhButton: UIButton!
    
    var user:User!
    
    var delegate: ContactTableViewCellDelegate?

    
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
        statusImage.layer.cornerRadius = statusImage.frame.height/2
        statusImage.layer.borderColor = UIColor( red: 255/255, green: 255/255, blue:255/255, alpha: 1).cgColor
        statusImage.layer.borderWidth = 2.0

        let tapGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.tapEdit(sender:)))
        addGestureRecognizer(tapGesture)
    }

    func tapEdit(sender: UILongPressGestureRecognizer) {
        utilities.log("longpress")
        delegate?.contactTableViewCellDelegate(user: user)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
extension ContactTableViewCell{
    
}
