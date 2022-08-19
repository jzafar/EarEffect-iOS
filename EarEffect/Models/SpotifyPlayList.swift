//
//  SpotifyPlayList.swift
//  EarEffect
//
//  Created by Muhammad Zafar on 2022-07-18.
//

import Foundation
struct SpotifyPlayList: Codable {
    let description: String
    let external_urls: [String:String]
    let id: String
    let images: [APIImages]?
    let name: String
    let owner: User
}

struct APIImages: Codable{
//    let height: String?
//    let width: String?
    let url: String?
}

struct User: Codable {
    let display_name: String
    let external_urls: [String:String]
    let id: String
    let type: String
}

struct SpotifyUserPlayListResponse: Codable{
    let items: [SpotifyPlayList]?
}
