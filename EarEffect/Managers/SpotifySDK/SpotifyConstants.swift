//
//  SpotifyConstants.swift
//  EarEffect
//
//  Created by Muhammad Zafar on 2022-07-19.
//

import Foundation

struct SpotifyConstants {
    
    static let baseURL = "https://api.spotify.com/v1"
    static let redirectURI = "EarEffect://loginReturn" //EarEffect%3A%2F%2FloginReturn
    static let clientID = "894fe8d8134f4d16b085e30156749c46" //9f0e47d5bc9e4bd88871a6bac2f2e53e"
    static let clientSecret = "0066d5e1e9754059835dcd8029cb9898" //"d12a9ba8737b49a89100356f90af5dbd"
    static let tokenApiURL = "https://accounts.spotify.com/api/token"
    static let scope = "user-read-private%20playlist-modify-public%20playlist-read-private%20playlist-modify-private%20user-library-read%20streaming%20user-read-email%20user-top-read%20ugc-image-upload%20user-follow-read"
    
}

extension UserDefaults{
    
    static let accessToken = "access_token"
    static let refreshToken = "refresh_token"
    static let tokenExpiryDate = "expirationDate"
//    static let refreshedToken = "refresh_token"
    
    static let playBackUri = "playBackUri"
    static let seekBarPosition = "seekBarPosition"
    static let playListIndex = "playListIndex"
    static let playingSongData = "playingSongData"
    static let spotifyUse = "spotifyUse"
    static let playingTrack = "playingTrack"
}
