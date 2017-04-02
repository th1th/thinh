//
//  PreviewView.swift
//  Thinh
//
//  Created by Linh Le on 4/2/17.
//  Copyright © 2017 coderschool. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

class PreviewView: UIView {
    var videoPreviewLayer: AVCaptureVideoPreviewLayer {
        return layer as! AVCaptureVideoPreviewLayer
    }
    
    var session: AVCaptureSession? {
        get {
            return videoPreviewLayer.session
        }
        set {
            videoPreviewLayer.session = newValue
        }
    }
    
    // MARK: UIView
    
    override class var layerClass: AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }
}
