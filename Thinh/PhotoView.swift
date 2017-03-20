//
//  PhotoView.swift
//  Thinh
//
//  Created by Linh Le on 3/19/17.
//  Copyright © 2017 coderschool. All rights reserved.
//

import UIKit

class PhotoView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBAction func onClickedThinh(_ sender: UIButton) {
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    init?(coder aDecoder: NSCoder) {
        //
        super.init(coder: aDecoder)
        initSubviews()
    }
    init(frame: CGRect) {
        //
        super.init(frame: frame)
        initSubviews()
    }
    func initSubviews() {
        // standard initialization logic
        let nib = UINib(nibName: "CaptionableImageView", bundle: nil)
        nib.instantiateWithOwner(self, options: nil)
        contentView.frame = bounds
        addSubview(contentView)
    }

}
