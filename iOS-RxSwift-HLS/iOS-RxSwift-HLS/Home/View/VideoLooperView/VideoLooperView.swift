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
    let playerView = UIView()
    let cancelButton = UIButton()
    let playButton = UIButton()
    
    @objc private let player = AVQueuePlayer()
    private var token: NSKeyValueObservation?
    
    init(clips: [MovieClips]) {
        self.clips = clips
        super.init(frame: .zero)
        initializePlayer()
        addSubview()
        addGestureRecognizers()
    }
    private func addSubview() {
        
        playerView.backgroundColor = .black
        cancelButton.setTitleAndColor(text: "✖️", fontSize: 16, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        playButton.setTitleAndColor(text: "▶️", fontSize: 16, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        cancelButton.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        playButton.addTarget(self, action: #selector(playVideo), for: .touchUpInside)
        addSubview(playerView)
        addSubview(cancelButton)
        addSubview(playButton)
    }
    @objc private func dismiss() {
        self.removeFromSuperview()
    }
    @objc private func playVideo() {
        if player.isPlaying {
            pause()
            playButton.setTitleAndColor(text: "▶️", fontSize: 16, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        } else {
            play()
            playButton.setTitleAndColor(text: "⏸", fontSize: 16, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        }
    }
    // call video player to play preview which came from HomeViewController
    private func initializePlayer() {
        videoPlayerView.player = player
        addAllVideosToPlayer()
        player.volume = 0.0
        
       // player.play()
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
      
        player.volume = player.volume == 1.0 ? 0.0 : 1.0
    }
    
    //  Double tapping should toggle the rate between 2x and 1x
    @objc func wasDoubleTapped() {

        player.rate = player.rate == 1.0 ? 2.0 : 1.0
    }
 
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension VideoLooperView {
    override func layoutSubviews() {
        super.layoutSubviews()
         playButton.anchor(top: self.topAnchor, leading: nil, bottom: self.bottomAnchor, trailing: self.trailingAnchor, padding: UIEdgeInsets(top: 15, left: 0, bottom: 15, right: 0), size: CGSize(width: 30, height: 30))
        cancelButton.anchor(top: self.topAnchor, leading: nil, bottom: self.bottomAnchor, trailing: playButton.leadingAnchor, padding: UIEdgeInsets(top: 15, left: 0, bottom: 15, right: 0), size: CGSize(width: 30, height: 30))
        playerView.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: cancelButton.leadingAnchor)
        videoPlayerView.frame = playerView.frame
        addSubview(videoPlayerView)
    }
}

extension AVPlayer {
    
    var isPlaying: Bool {
        if (self.rate != 0 && self.error == nil) {
            return true
        } else {
            return false
        }
    }
    
}
