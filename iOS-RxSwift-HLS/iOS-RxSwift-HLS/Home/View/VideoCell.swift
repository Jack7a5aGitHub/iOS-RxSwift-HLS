//
//  VideoCell.swift
//  iOS-RxSwift-HLS
//
//  Created by Jack Wong on 2019/01/15.
//  Copyright © 2019 Jack Wong. All rights reserved.
//

import Kingfisher
import UIKit

final class VideoCell: UITableViewCell {

    // MARK: - IBOutlet
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var previewImageView: UIImageView!
    @IBOutlet private var desciptionLabel: UILabel!
    
    var previewUrl = ""
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    static var identifier: String {
        return self.className
    }
    
    static var nibName: String {
        return self.className
    }
    func configure(with movieInfo: MovieInfo) {
        guard let title = movieInfo.trackName,
              let previewImageUrl = movieInfo.artworkUrl100,
              let description = movieInfo.shortDescription,
              let previewUrl = movieInfo.previewUrl else {
                return
        }
        titleLabel.text = title
        desciptionLabel.text = description
        self.previewUrl = previewUrl
        previewImageView.kf.setImage(with: URL(string: previewImageUrl))
    }
    
}
