//
//  GetMovieParameter.swift
//  iOS-RxSwift-HLS
//
//  Created by Jack Wong on 2019/01/15.
//  Copyright © 2019 Jack Wong. All rights reserved.
//

import Alamofire

final class GetMovieParameter: WebAPIRequestParameterProtocol {
    
    var path = EndPoint.getMovie.path
    var httpMethod = HTTPMethod.get
    var parameter: [String: Any] = [:]
    var header = [
        "Content-Type": "application/json"
    ]
    
    /// 初期化
    ///
    init() {
        parameter = ["term": "Marvel",
                     "country": "JP",
                     "media": "movie",
                     "entity": "movie",
                     "limit": "10",
                     "lang": "ja_jp"]
    }
    
}

