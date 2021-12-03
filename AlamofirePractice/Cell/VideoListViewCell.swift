//
//  TimeLineTableViewCell.swift
//  AlamofirePractice
//
//  Created by taichi on 2021/12/02.
//

import UIKit
import Nuke

class VideoListViewCell: UITableViewCell {

    var videoItem: Item? {
        didSet {
            if let url = URL(string: videoItem?.snippet.thumbnails.high.url ?? ""){
                Nuke.loadImage(with: url, into: thumbnailsImageView)
            }
            if let channelUrl = URL(string: videoItem?.channel?.items[0].snippet.thumbnails.high.url ?? ""){
                Nuke.loadImage(with: channelUrl, into: channelImageView)
            }
            titleLabel.text = videoItem?.snippet.title
            descriptionLabel.text = videoItem?.snippet.description
        }
    }
    
    @IBOutlet weak var thumbnailsImageView: UIImageView!
    
    @IBOutlet weak var channelImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        channelImageView.layer.cornerRadius = channelImageView.frame.height/2
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
