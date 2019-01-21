//
//  Extension+UIButton.swift
//  iOS-RxSwift-HLS
//
//  Created by Jack Wong on 2019/01/21.
//  Copyright © 2019 Jack Wong. All rights reserved.
//

import UIKit

extension UIButton {
    
    func setTitleAndColor(text: String, fontSize size: CGFloat, fontColor color: UIColor) {
        self.setTitle(text, for: .normal)
        self.titleLabel?.font = UIFont.systemFontOfSize(size: size)
        self.setTitleColor(color, for: .normal)
    }
    
}
