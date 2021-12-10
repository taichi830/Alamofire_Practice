//
//  VideoListViewModel.swift
//  AlamofirePractice
//
//  Created by taichi on 2021/12/09.
//

import Foundation
import Alamofire
import RxSwift
import RxCocoa

class VideoListViewModel {
    private let disposeBag = DisposeBag()
    private var searchWordStream = PublishSubject<String>()
    private var eventsStream = PublishSubject<Video?>()
    private var channelStream = PublishSubject<Channel?>()
    
    var searchWord: AnyObserver<String> {
        searchWordStream.asObserver()
    }
    var events: Observable<Video?> {
        eventsStream.asObservable()
    }
    var channels: Observable<Channel?> {
        channelStream.asObservable()
    }
    
    
    init() {
        
        let fetchYouTubeSearchInfo = searchWordStream.flatMapLatest { word -> Observable<Video?> in
            let params = ["q": word]
            return API.shared.fetchVideos(path: .search, params: params, type: Video.self)
        }
        
        let fetchYouTubeChannelInfo = fetchYouTubeSearchInfo.flatMap { video -> Observable<Channel?> in
            let id = video?.items[1].snippet.channelId
            print("ssksksksks:",id ?? "hello")
            let params = ["id": id ?? ""]
            return API.shared.fetchVideos(path: .channels, params: params, type: Channel.self)
        }
        
        Observable.zip(fetchYouTubeSearchInfo, fetchYouTubeChannelInfo)
            .subscribe { video,channel in
                self.eventsStream.onNext(video)
                self.channelStream.onNext(channel)
            }
            .disposed(by: disposeBag)
        
    }
    
    private func fetchYouTubeSearchInfo(word:String) -> Observable<Video?> {
        let params = ["q": word]
        return API.shared.fetchVideos(path: .search, params: params, type: Video.self)
    }
    
    private func fetchYouTubeChannelInfo(video:Video) -> Observable<Channel?> {
        let id = video.items[0].snippet.channelId
        let params = ["id":id]
        return API.shared.fetchVideos(path: .channels, params: params, type: Channel.self)
    }
    
    
    
    
}
