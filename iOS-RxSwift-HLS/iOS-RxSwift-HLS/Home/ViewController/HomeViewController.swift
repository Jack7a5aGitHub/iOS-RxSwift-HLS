//
//  HomeViewController.swift
//  iOS-RxSwift-HLS
//
//  Created by Jack Wong on 2019/01/15.
//  Copyright © 2019 Jack Wong. All rights reserved.
//

import AVKit
import UIKit
import RxCocoa
import RxSwift
import SVProgressHUD

final class HomeViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet private var videoTableView: UITableView!
    
    // MARK: - Property
    private var movies = [String]()
    private let disposeBag = DisposeBag()
    private var videoPreviewLooper: VideoLooperView?
    private let playerViewController = AVPlayerViewController()
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let viewModel = HomeViewModel(disposeBag: disposeBag)
        //? Add the video looper view
        registerNib()
        bindToTableView(to: viewModel)
        bindToPreview(to: viewModel)
        setupCellTapHandling()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        videoPreviewLooper?.pause()
    }
    
}

extension HomeViewController {
   
    private func registerNib() {
        let videoNib = UINib(nibName: VideoCell.nibName, bundle: nil)
        videoTableView.register(videoNib, forCellReuseIdentifier: VideoCell.identifier)
        videoTableView.delegate = self
        videoTableView.tableFooterView = UIView()
    }
    private func bindToTableView(to viewModel: HomeViewModel) {
        viewModel
            .movies.bind(to: videoTableView.rx.items(cellIdentifier: VideoCell.identifier, cellType: VideoCell.self)) {
                (_, videos, cell) in
                 cell.configure(with: videos)
            }.disposed(by: disposeBag)
       
    }
    private func bindToPreview(to viewModel: HomeViewModel) {
        viewModel.previewList.subscribe(onNext: { (previewUrls) in
            for url in previewUrls {
                self.movies.append(url)
            }
            if !self.movies.isEmpty {
                self.loadViews()
            }
        }).disposed(by: disposeBag)
    }
    private func setupCellTapHandling() {
    
        videoTableView.rx.modelSelected(MovieInfo.self)
            .subscribe(onNext: { item in
                if let  selectedRowIndexPath = self.videoTableView.indexPathForSelectedRow {
                    guard let video = item.previewUrl else {
                        return
                    }
                    guard let videoUrl = URL(string: video) else {
                        return
                    }
                    let player = AVPlayer(url: videoUrl)
                    self.playVideo(player: player)
                    self.videoTableView.deselectRow(at: selectedRowIndexPath, animated: true)
                }
            }).disposed(by: disposeBag)
    }
    
    private func playVideo(player: AVPlayer) {

        playerViewController.player = player
        present(playerViewController, animated: true) {
            player.play()
        }
        
    }
}

extension HomeViewController {
    // pass preview list to looper
    private func loadViews() {
        videoPreviewLooper = VideoLooperView(clips: MovieClips.allClips(movies: movies))
        view.addSubview(videoPreviewLooper!)
        //videoPreviewLooper?.play()
    }
    override func viewWillLayoutSubviews() {
        videoPreviewLooper?.frame = CGRect(x: 16, y: view.bounds.height - 100 - 16, width: view.bounds.width - 32, height: 60)
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
 
}
