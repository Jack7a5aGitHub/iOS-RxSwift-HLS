//
//  VideoPlayerView.swift
//  iOS-RxSwift-HLS
//
//  Created by Jack Wong on 2019/01/19.
//  Copyright © 2019 Jack Wong. All rights reserved.
//

import AVFoundation
import UIKit

final class VideoPlayerView: UIView {
    
    //  Add player property so the video the layer shows can be updated
    //  getter , setter
    var player: AVPlayer? {
        get {
            return playerLayer.player
        }
        
        set {
            playerLayer.player = newValue
        }
    }
    //  Override the layerClass
    // provides touch handling and accessibility features
    override class var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
    
    //  Add accessor for playerLayer so you don't need to
    var playerLayer: AVPlayerLayer {
        return layer as! AVPlayerLayer
    }
}
