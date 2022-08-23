//
//  AppleTrack.swift
//  EarEffect
//
//  Created by Muhammad Zafar on 2022-08-10.
//

import Foundation
struct AppleTrack: Codable {
    let id: String
    let type: String
    let href: String
    let attributes: TrackAttributes
}
struct TrackAttributes: Codable{
    let trackNumber: UInt64
    let albumName: String?
    let genreNames: [String]?
    let durationInMillis: Int
    let discNumber: Int?
    let artistName: String?
    let name: String
    let artwork: Artwork?
    let playParams: PlayParams?
}
struct AppleTrackResponse:Codable {
    let data: [AppleTrack]?
    let meta: Meta?
    let next: String?
}
