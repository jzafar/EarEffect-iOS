//
//  SpotifyPlayBackTrack.swift
//  EarEffect
//
//  Created by Muhammad Zafar on 2022-07-22.
//

import Foundation

struct SpotifyPlayBackTrack {
    let name: String
    let uri: String
    let playbackSourceUri: String
    let playbackSourceName: String?
    let artistName: String?
    let artistUri: String?
    let albumName: String?
    let albumUri: String?
    let albumCoverArtURL: String?
    let duration: TimeInterval
    let indexInContext: UInt
    
}
extension SpotifyPlayBackTrack {
    func encode() -> Data {
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWith: data)
        archiver.encode(name, forKey: "name")
        archiver.encode(uri, forKey: "uri")
        archiver.encode(playbackSourceUri, forKey: "playbackSourceUri")
        archiver.encode(playbackSourceName, forKey: "playbackSourceName")
        archiver.encode(artistName, forKey: "artistName")
        archiver.encode(artistUri, forKey: "artistUri")
        archiver.encode(albumName, forKey: "albumName")
        archiver.encode(albumUri, forKey: "albumUri")
        archiver.encode(albumCoverArtURL, forKey: "albumCoverArtURL")
        archiver.encode(duration, forKey: "duration")
        archiver.encode(indexInContext, forKey: "indexInContext")
        archiver.finishEncoding()
        return data as Data
    }

    init?(data: Data) {
        let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
        defer {
            unarchiver.finishDecoding()
        }
        let name = unarchiver.decodeObject(forKey: "name") as? String
        let uri = unarchiver.decodeObject(forKey: "uri") as? String
        let playbackSourceUri = unarchiver.decodeObject(forKey: "playbackSourceUri") as? String
        let playbackSourceName = unarchiver.decodeObject(forKey: "playbackSourceName") as? String
        let artistName = unarchiver.decodeObject(forKey: "artistName") as? String
        let artistUri = unarchiver.decodeObject(forKey: "artistUri") as? String
        let albumName = unarchiver.decodeObject(forKey: "albumName") as? String
        let albumUri = unarchiver.decodeObject(forKey: "albumUri") as? String
        let albumCoverArtURL = unarchiver.decodeObject(forKey: "albumCoverArtURL") as? String
        let duration = unarchiver.decodeDouble(forKey: "duration") as Double
        let indexInContext = unarchiver.decodeObject(forKey: "indexInContext") as? String ?? "0"
        self.name = name ?? ""
        self.uri = uri ?? ""
        self.playbackSourceUri = playbackSourceUri ?? ""
        self.playbackSourceName = playbackSourceName ?? ""
        self.artistUri = artistUri ?? ""
        self.artistName = artistName ?? ""
        self.albumName = albumName ?? ""
        self.albumUri = albumUri ?? ""
        self.albumCoverArtURL = albumCoverArtURL ?? ""
        self.duration = duration
        let index = Int(indexInContext)
        self.indexInContext = UInt(index ?? 0)
    }
}
