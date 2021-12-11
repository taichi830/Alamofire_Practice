//
//  ViewController.swift
//  AlamofirePractice
//
//  Created by taichi on 2021/12/02.
//

import UIKit
import Alamofire
import RxSwift
import RxCocoa
import PKHUD

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    
    @IBOutlet weak var videoListTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    private let disposeBag = DisposeBag()
    private let viewModel = VideoListViewModel()
    private var videoItems = [Item]()
    private var channels = [Channel]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        videoListTableView.delegate = self
        videoListTableView.dataSource = self
        videoListTableView.separatorStyle = .none
        videoListTableView.register(UINib(nibName: "VideoListViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        videoListTableView.rowHeight = UITableView.automaticDimension
        
        searchBar.backgroundImage = UIImage()
        searchBar.rx.searchButtonClicked.asDriver(onErrorJustReturn: ())
            .drive(onNext: { [weak self] in
                HUD.flash(.progress)
                self?.searchBar.resignFirstResponder()
                self?.searchBar.showsCancelButton = false
                self?.viewModel.searchWord.onNext(self?.searchBar.text ?? "")
            })
            .disposed(by: disposeBag)
        
        
        
        viewModel.events.subscribe { [weak self] video in
            self?.setVideos(video: video!)
        }
        .disposed(by: disposeBag)
        
        
        
        viewModel.channels.subscribe { [weak self] channel in
            self?.reloadData(channel: channel!)
        }
        .disposed(by: disposeBag)
        
    }
    
    
    private func setVideos(video:Video){
        self.videoItems = video.items
        self.videoItems.enumerated().forEach { (index,item) in
            self.viewModel.channelID.onNext(item.snippet.channelId)
        }
    }
    
    
    private func reloadData(channel:Channel){
        self.channels.append(channel)
        if channels.count == videoItems.count {
            self.videoListTableView.reloadData()
            HUD.hide()
        }
    }
    
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
    
    
    
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videoItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! VideoListViewCell
        cell.setupVideos(videoItems: videoItems[indexPath.row], channels: channels[indexPath.row])
        return cell
    }
    
    
    
    
}

