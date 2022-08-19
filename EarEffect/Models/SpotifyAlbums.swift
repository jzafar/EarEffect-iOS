//
//  SpotifyAlbums.swift
//  EarEffect
//
//  Created by Muhammad Zafar on 2022-07-18.
//

import Foundation
struct SpotifyAlbum: Codable {
    let album_type: String
    let available_markets: [String]
    let id: String
    let images: [APIImages]?
    
    let name: String
    let release_date: String
    let total_tracks: Int
    let artists: [SpotifyArtist]
}

struct Album:Codable{
    let items:[SpotifyAlbum]
}
