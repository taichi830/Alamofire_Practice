//
//  Video.swift
//  AlamofirePractice
//
//  Created by taichi on 2021/12/02.
//

import Foundation

class Video:Decodable {
    let kind:String
    let items:[Item]
}

class Item:Decodable {
    let snippet:Snippet
    var channel:Channel?
}

class Snippet:Decodable {
    let publishedAt:String
    let channelId:String
    let title:String
    let description:String
    let thumbnails:Thumbnail
}

class Thumbnail:Decodable {
    let medium:ThumbnailInfo
    let high:ThumbnailInfo
}

class ThumbnailInfo:Decodable {
    let url:String
    let width:Int?
    let height:Int?
}
