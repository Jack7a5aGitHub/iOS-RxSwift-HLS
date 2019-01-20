//
//  HomeViewModel.swift
//  iOS-RxSwift-HLS
//
//  Created by Jack Wong on 2019/01/15.
//  Copyright © 2019 Jack Wong. All rights reserved.
//

import SVProgressHUD
import Foundation
import RxSwift

struct HomeViewModel {
    
    //Output
    var movies: Observable<[MovieInfo]> {
        return self.movieVariable.asObservable()
    }
    var previewList: Observable<[String]> {
        return self.previewVariable.asObservable()
    }
    // Input
    private let movieVariable = Variable<[MovieInfo]>([])
    private let previewVariable = Variable<[String]>([])
    private let keywordSubject = PublishSubject<String>()
    private let disposeBag: DisposeBag
    
    init(disposeBag: DisposeBag) {
        self.disposeBag = disposeBag
        bindObservableToGetMovie()
        bindObservableToGetPreviewList()
    }
}

extension HomeViewModel {
    // MARK: Public
    func bindObservableToGetMovie() {
        getMovie()
        .subscribeOn(ConcurrentDispatchQueueScheduler(queue: .main))
        .observeOn(MainScheduler.instance)
        .bind(to: movieVariable)
        .disposed(by: disposeBag)
    }
    func bindObservableToGetPreviewList() {
        getPreviewList()
        .subscribeOn(ConcurrentDispatchQueueScheduler(queue: .main))
        .observeOn(MainScheduler.instance)
        .bind(to: previewVariable)
        .disposed(by: disposeBag)
    }
    // MARK: Private
    private func getMovie() -> Observable<[MovieInfo]> {
        
        return MovieModel()
            .getObservableMovie()
            .catchErrorJustReturn([])
    }
    private func getPreviewList() -> Observable<[String]> {
        return MovieModel()
            .getObservablePreviewList()
            .catchErrorJustReturn([])
    }
}

