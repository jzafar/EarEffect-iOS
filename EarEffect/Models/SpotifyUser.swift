//
//  SpotifyUser.swift
//  EarEffect
//
//  Created by Muhammad Zafar on 2022-07-24.
//

import Foundation
struct SpotifyUser: Codable {
    let country, displayName, email: String?
    let explicitContent: ExplicitContent?
    let externalUrls: ExternalUrls?
//    let followers: Followers?
    let href: String?
    let id: String
    let images: [Image]?
    let product, type, uri: String

    enum CodingKeys: String, CodingKey {
        case country
        case displayName = "display_name"
        case email
        case explicitContent = "explicit_content"
        case externalUrls = "external_urls"
        case href, id, images, product, type, uri
    }
}

// MARK: - ExplicitContent
struct ExplicitContent: Codable {
    let filterEnabled, filterLocked: Bool

    enum CodingKeys: String, CodingKey {
        case filterEnabled = "filter_enabled"
        case filterLocked = "filter_locked"
    }
}

// MARK: - ExternalUrls
struct ExternalUrls: Codable {
    let spotify: String?
}

// MARK: - Followers
struct Followers: Codable {
    let href: String?
    var total: Int = 0
}

// MARK: - Image
struct Image: Codable {
    let url: String?
    let height, width: Int?
}
