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
    private var channelIDStream = PublishSubject<String>()
    private var eventsStream = PublishSubject<Video?>()
    private var channelStream = PublishSubject<Channel?>()
    
    var searchWord: AnyObserver<String> {
        searchWordStream.asObserver()
    }
    var channelID: AnyObserver<String>{
        channelIDStream.asObserver()
    }
    var events: Observable<Video?> {
        eventsStream.asObservable()
    }
    var channels: Observable<Channel?> {
        channelStream.asObservable()
    }
    
    
    init() {
        
        searchWordStream.flatMapLatest { word -> Observable<Video?> in
            let params = ["q": word]
            return API.shared.fetchVideos(path: .search, params: params, type: Video.self)
        }
        .subscribe(eventsStream)
        .disposed(by: disposeBag)
    
        
        channelIDStream.flatMap { id -> Observable<Channel?> in
            let params = ["id":id]
            return API.shared.fetchVideos(path: .channels, params: params, type: Channel.self)
        }
        .subscribe(channelStream)
        .disposed(by: disposeBag)
        
        
    }
    
    
    
    
}
