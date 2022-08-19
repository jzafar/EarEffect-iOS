//
//  SpotifyAuthResponse.swift
//  EarEffect
//
//  Created by Muhammad Zafar on 2022-07-18.
//

import Foundation

struct SpotifyAuthResponse: Codable {
    let access_token: String
    let expires_in: Int
    let refresh_token: String?
    let scope: String
    let token_type: String
}
