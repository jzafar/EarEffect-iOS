//
//  ConnectedStreams.swift
//  EarEffect
//
//  Created by Muhammad Zafar on 2022-07-18.
//

import Foundation
struct ConnectedStreams {
    
    static func getConnectedStream() -> [Streams] {
        var streams: [Streams] = []
        if SpotifyAuthManager.shared.isSignedIn {
            streams.append(.spotify)
        }
        return streams
    }
}

enum Streams {
    case spotify
    case amazon
    case apple
    case youtube
}
