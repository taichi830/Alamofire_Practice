//
//  ViewController.swift
//  AlamofirePractice
//
//  Created by taichi on 2021/12/02.
//

import UIKit
import Alamofire

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    

    @IBOutlet weak var VideoListTableView: UITableView!
    
    private var videoItems = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        VideoListTableView.delegate = self
        VideoListTableView.dataSource = self
        VideoListTableView.register(UINib(nibName: "VideoListViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        VideoListTableView.rowHeight =  UITableView.automaticDimension
        
        fetchYouTubeSearchInfo()
    }
    
    
    
    private func fetchYouTubeSearchInfo() {
        let params = ["q": "bts"]
        API.shared.request(path: .search, params: params, type: Video.self) { video in
            
            self.videoItems = video.items
            self.videoItems.enumerated().forEach { (index,video) in
                let id = video.snippet.channelId
                self.fetchYouTubeChannelInfo(id: id, index: index)
            }
        }
    }
    
    
    private func fetchYouTubeChannelInfo(id:String,index:Int) {
        let params = ["id":id]
        API.shared.request(path: .channels, params: params, type: Channel.self) { channel in
            self.videoItems[index].channel = channel
            self.VideoListTableView.reloadData()
        }
    }
    
    
    
    
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videoItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! VideoListViewCell
        
        cell.videoItem = videoItems[indexPath.row]
        
        return cell
    }
    
    
    

}

