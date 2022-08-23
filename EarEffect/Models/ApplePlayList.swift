//
//  ApplePlayList.swift
//  EarEffect
//
//  Created by Muhammad Zafar on 2022-08-10.
//

import Foundation
struct ApplePlayList: Codable {
    let attributes: PlayListAttributes
    let type: String
    let href: String
    let id: String
}
struct PlayListAttributes: Codable {
    let name: String
    let playParams: PlayParams?
}
struct PlayParams: Codable {
    let id: String
    let kind: String
    let isLibrary: Bool
}
struct ApplePlayListResponse:Codable {
    let next: String?
    let data: [ApplePlayList]?
    let meta: Meta?
}
