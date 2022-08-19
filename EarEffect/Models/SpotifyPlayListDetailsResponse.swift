//
//  SpotifyPlayListDetailsResponse.swift
//  EarEffect
//
//  Created by Muhammad Zafar on 2022-07-18.
//

import Foundation
struct SpotifyPlayListDetailsResponse: Codable {
    let collaborative: Bool
    let welcomeDescription: String?
    let externalUrls: ExternalUrls?
//    let followers: Followers?
    let href, id: String
    let images: [APIImages]?
    let name: String
    let owner: Owner
    let welcomePublic: Bool
    let snapshotID: String
    let tracks: Tracks?
    let type, uri: String

    enum CodingKeys: String, CodingKey {
        case collaborative
        case welcomeDescription = "description"
        case externalUrls = "external_urls"
        case href, id, images, name, owner
        case welcomePublic = "public"
        case snapshotID = "snapshot_id"
        case tracks, type, uri
    }
}



// MARK: - Owner
struct Owner: Codable {
    let externalUrls: ExternalUrls
//    let followers: Followers
    let href, id, type, uri: String
    let displayName: String

    enum CodingKeys: String, CodingKey {
        case externalUrls = "external_urls"
        case href, id, type, uri
        case displayName = "display_name"
    }
}

// MARK: - Tracks
struct Tracks: Codable {
    let href: String
    let items: [PlayListItems]?
    let limit: Int
    let next: String?
    let offset: Int?
    let previous: String?
    let total: Int
}

struct PlayListItems: Codable{
    let track: SpotifyAudioTrack
}
