//
//  AppleArtist.swift
//  EarEffect
//
//  Created by Muhammad Zafar on 2022-08-10.
//

import Foundation

struct AppleArtist: Codable{
    let attributes: ArtistAttributes
    let type: String
    let href: String
    let id: String
}
struct ArtistAttributes: Codable {
    let name: String
}
struct AppleArtistResponse:Codable {
    let next: String?
    let data: [AppleArtist]?
    let meta: Meta?
}
