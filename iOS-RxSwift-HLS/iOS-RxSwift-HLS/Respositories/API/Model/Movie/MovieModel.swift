//
//  MovieModel.swift
//  iOS-RxSwift-HLS
//
//  Created by Jack Wong on 2019/01/15.
//  Copyright © 2019 Jack Wong. All rights reserved.
//

import Alamofire
import RxSwift
import Foundation

struct SearchResult: Decodable {
    let results: [MovieInfo]
}

struct MovieInfo: Decodable {
    
    let artworkUrl100: String?
    let previewUrl: String?
    let trackName: String?
    let shortDescription: String?
    
}

struct MovieModel {
    
    private let baseURL = EndPoint.getPhoto.path

    func getObservableMovie() -> Observable<[MovieInfo]> {
        return Observable.create { subscriber in
            let requestParameter = GetMovieParameter()
            let router = Router.getMovie(requestParameter: requestParameter)
            let request = APIClient.request(router: router, completionHandler: { response in
                let decoder = JSONDecoder()
                switch response {
                case .success(let result):
                    guard let data = result else {
                        fatalError()
                    }
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let fetchResult = try? decoder.decode(SearchResult.self, from: data)
                    guard let movies = fetchResult?.results else {
                        subscriber.onNext([])
                        subscriber.onCompleted()
                        return
                    }
                    subscriber.onNext(movies)
                    subscriber.onCompleted()
                case .failure(let error):
                    LogHelper.log("error_code: \((error as NSError).code)")
                    LogHelper.log("error_description: \((error as NSError).description)")
                }
            })
            return Disposables.create {
                request.cancel()
        }
    }

    }
    func getObservablePreviewList() -> Observable<[String]> {
        return Observable.create { subscriber in
            let requestParameter = GetMovieParameter()
            let router = Router.getMovie(requestParameter: requestParameter)
            let request = APIClient.request(router: router, completionHandler: { response in
                let decoder = JSONDecoder()
                switch response {
                case .success(let result):
                    guard let data = result else {
                        fatalError()
                    }
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let fetchResult = try? decoder.decode(SearchResult.self, from: data)
                    guard let movies = fetchResult?.results else {
                        subscriber.onNext([])
                        subscriber.onCompleted()
                        return
                    }
                    var previewList = [String]()
                    for item in movies {
                        guard let previewUrl = item.previewUrl else {
                            continue
                        }
                        previewList.append(previewUrl)
                    }
                    subscriber.onNext(previewList)
                    subscriber.onCompleted()
                case .failure(let error):
                    LogHelper.log("error_code: \((error as NSError).code)")
                    LogHelper.log("error_description: \((error as NSError).description)")
                }
            })
            return Disposables.create {
                request.cancel()
            }
        }
        
    }
}
