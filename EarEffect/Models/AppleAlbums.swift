//
//  AppleAlbums.swift
//  EarEffect
//
//  Created by Muhammad Zafar on 2022-08-10.
//

import Foundation

struct AppleAlbums: Codable {
    let attributes: Attributes
    let type: String
    let href: String
    let id: String
}

struct Attributes: Codable {
    let genreNames: [String]?
    let trackCount: UInt64
    let artistName: String?
    let name: String
    let artwork: Artwork?
}
struct AppleAlbumResponse:Codable {
    let next: String?
    let data: [AppleAlbums]?
    let meta: Meta?
}
struct Meta: Codable{
    let total: UInt64?
}
