//
//  Channel.swift
//  AlamofirePractice
//
//  Created by taichi on 2021/12/02.
//

import Foundation

class Channel:Decodable {
    
    let items:[ChannelItem]
}

class ChannelItem:Decodable {
    let snippet:ChannelSnippet
}

class ChannelSnippet:Decodable {
    let thumbnails:Thumbnail
}
