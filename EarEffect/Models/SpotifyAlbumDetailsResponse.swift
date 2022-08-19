//
//  SpotifyAlbumDetailsResponse.swift
//  EarEffect
//
//  Created by Muhammad Zafar on 2022-07-18.
//

import Foundation
struct SpotifyAlbumDetailsResponse: Codable{
    let album_type: String
    let artists: [SpotifyArtist]?
    let available_markets : [String]
    let external_urls: [String: String]
    let id : String
    let images: [APIImages]
    let label: String
    let name: String
    let tracks: TrackResponse
}

struct TrackResponse:Codable{
    let items: [SpotifyAudioTrack]
}

struct SpotifyAudioTrack:Codable{
    let album: SpotifyAlbum?
    let artists: [SpotifyArtist]?
    let available_markets : [String]
    let disc_number: Int
    let duration_ms: Int
    let explicit: Bool
    let external_urls: [String: String] 
    let id : String
    let name: String
    let preview_url: String?
    let uri: String
}
