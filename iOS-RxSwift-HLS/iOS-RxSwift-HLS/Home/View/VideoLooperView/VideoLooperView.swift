//
//  VideoLooperView.swift
//  iOS-RxSwift-HLS
//
//  Created by Jack Wong on 2019/01/20.
//  Copyright © 2019 Jack Wong. All rights reserved.
//

import AVFoundation
import UIKit

final class VideoLooperView: UIView {

    // MARK: - Property
    let clips: [MovieClips]
    let videoPlayerView = VideoPlayerView()
    
    @objc private let player = AVQueuePlayer()
    private var token: NSKeyValueObservation?
    
    init(clips: [MovieClips]) {
        self.clips = clips
        print("clips", self.clips)
        super.init(frame: .zero)
        
        initializePlayer()
        addGestureRecognizers()
    }
    private func addSubview() {
        
    }
    // call video player to play preview which came from HomeViewController
    private func initializePlayer() {
        videoPlayerView.player = player
        addAllVideosToPlayer()
        player.volume = 0.0
        player.play()
        // to loop the videos infinitely
        token = player.observe(\.currentItem) { [weak self] player, _ in
            if player.items().count == 1 {
                self?.addAllVideosToPlayer()
            }
        }
    }
    
    private func addAllVideosToPlayer() {
        for video in clips {
            let asset = AVURLAsset(url: video.url)
            let item = AVPlayerItem(asset: asset)
            player.insert(item, after: player.items().last)
        }
    }
    
    // Add methods to pause and play when the view leaves the screen
    func pause() {
        player.pause()
    }
    
    func play() {
        player.play()
    }
    
    // MARK - Gestures
    
    //  Add single and double tap gestures to the video looper
    func addGestureRecognizers() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(VideoLooperView.wasTapped))
        let doubleTap = UITapGestureRecognizer(target: self,
                                               action: #selector(VideoLooperView.wasDoubleTapped))
        doubleTap.numberOfTapsRequired = 2
        
        tap.require(toFail: doubleTap)
        addGestureRecognizer(tap)
        addGestureRecognizer(doubleTap)
    }
    
    //  Single tapping should toggle the volume
    @objc func wasTapped() {
        print(#function)
        player.volume = player.volume == 1.0 ? 0.0 : 1.0
    }
    
    //  Double tapping should toggle the rate between 2x and 1x
    @objc func wasDoubleTapped() {
        print(#function)
        player.rate = player.rate == 1.0 ? 2.0 : 1.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension VideoLooperView {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        videoPlayerView.frame = bounds
        addSubview(videoPlayerView)
    }
}
