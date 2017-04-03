//
//  AsyncPhotoMediaItem.swift
//  *******
//
//  Created by IndrajitSinh Rayjada on 16/11/16.
//  Copyright © 2016 ******. All rights reserved.
//

import UIKit
import JSQMessagesViewController.JSQMessages
//import AlamofireImage
import Alamofire
import AlamofireImage

class AsyncPhotoMediaItem: JSQPhotoMediaItem {
    var imgView : UIImageView!
    var uRL     :NSURL?
    
    override init!(maskAsOutgoing: Bool) {
        super.init(maskAsOutgoing: maskAsOutgoing)
    }
    
    init(withURL url: NSURL, isOperator: Bool) {
        super.init()
        uRL                             = url
        appliesMediaViewMaskAsOutgoing  = (isOperator == true)
        let size                        = super.mediaViewDisplaySize()
        imgView                         = UIImageView()
        imgView.frame                   = CGRect(x: 0, y: 0, width: size.width, height: size.width)
        imgView.contentMode             = .scaleAspectFill
        imgView.clipsToBounds           = true
        imgView.backgroundColor         = UIColor.jsq_messageBubbleLightGray()
        
        let activityIndicator           = JSQMessagesMediaPlaceholderView.withActivityIndicator()
        activityIndicator?.frame         = imgView.frame
        imgView.addSubview(activityIndicator!)
        
        let filter = AspectScaledToFillSizeWithRoundedCornersFilter(
            size: size,
            radius: 0
        )
        let bubbleImageFactory = JSQMessagesBubbleImageFactory(bubble: UIImage.jsq_bubbleCompactTailless(), capInsets: UIEdgeInsets.zero)
        
        if(isOperator){
            JSQMessagesMediaViewBubbleImageMasker(bubbleImageFactory: bubbleImageFactory).applyOutgoingBubbleImageMask(toMediaView: self.imgView)
        } else {
            JSQMessagesMediaViewBubbleImageMasker(bubbleImageFactory: bubbleImageFactory).applyIncomingBubbleImageMask(toMediaView: self.imgView)
        }
        
        
        //JSQMessagesMediaViewBubbleImageMasker.applyBubbleImageMask(toMediaView: self.imgView, isOutgoing: self.appliesMediaViewMaskAsOutgoing)
        
        imgView.af_setImage(withURL: url as URL, filter: filter) { (response) in
            let image = response.result.value
            if  image != nil{
                activityIndicator?.removeFromSuperview()
                self.imgView.image = image
            }
        }
        
    }
    
    override func mediaView() -> UIView! {
        return imgView
    }
    
    override func mediaViewDisplaySize() -> CGSize {
        return imgView.frame.size
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
