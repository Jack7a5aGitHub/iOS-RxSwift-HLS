//
//  MovieClips.swift
//  iOS-RxSwift-HLS
//
//  Created by Jack Wong on 2019/01/20.
//  Copyright © 2019 Jack Wong. All rights reserved.
//

import UIKit

final class MovieClips: NSObject {
    
    var url: URL
    
    init(url: URL) {
        self.url = url
        super.init()
    }
    class func allClips(movies: [String]) -> [MovieClips] {
        var clips: [MovieClips] = []

        for movie in movies {
            
            guard let previewUrl = URL(string: movie) else {
                continue
            }
            let clip = MovieClips(url: previewUrl)
            clips.append(clip)
        }
        return clips
    }
}
