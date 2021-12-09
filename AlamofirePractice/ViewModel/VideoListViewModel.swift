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
    
    var searchWord: AnyObserver<String> {
        searchWordStream.asObserver()
    }
    var events: Observable<Video?> {
        eventsStream.asObservable()
    }
    
    
    init() {
        
        searchWordStream.flatMapLatest { word -> Observable<Video?> in
            print("word:",word)
            return self.fetchYouTubeSearchInfo(word: word)
        }
        .subscribe(eventsStream)
        .disposed(by: disposeBag)
    }
    
    private func fetchYouTubeSearchInfo(word:String) -> Observable<Video?> {
        let params = ["q": word]
        return API.shared.fetchVideos(path: .search, params: params, type: Video.self)
    }
    
    private func fetchYouTubeChannelInfo(id:String,index:Int) -> Observable<Video?> {
        let params = ["id":id]
        return API.shared.fetchVideos(path: .channels, params: params, type: Channel.self)
    }
    
    
    
    
}
