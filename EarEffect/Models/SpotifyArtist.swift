//
//  SpotifyArtist.swift
//  EarEffect
//
//  Created by Muhammad Zafar on 2022-07-18.
//

import Foundation

struct SpotifyArtist: Codable {
    let id: String
    let name: String
    let type: String
    let uri: String
    let externalUrls: ExternalUrls
//    let followers: Followers
//    let genres: [String]?
    let href: String
    let images: [APIImages]?
//    let popularity: Int
    enum CodingKeys: String, CodingKey {
        case externalUrls = "external_urls"
        case href, id, images, name, type, uri
    }
}
struct Artists: Codable {
    let artists: ArtistsItems
}
struct ArtistsItems: Codable {
    let items: [SpotifyArtist]
}
