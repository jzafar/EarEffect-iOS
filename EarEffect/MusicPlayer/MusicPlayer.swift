//
//  MusicPlayer.swift
//  EarEffect
//
//  Created by Muhammad Zafar on 2022-07-19.
//

import Foundation
import AVFoundation
import MediaPlayer
protocol MusicPlayerDelegate {
    func changeMusic()
}

final class MusicPlayer {
    static let shared = MusicPlayer()
    private init () {
        player = AVPlayer()
    }
    var delegate: MusicPlayerDelegate?
    var playerList : [MusicFile] = []
    var player: AVPlayer?
    var playerItems = [AVPlayerItem]()
    var currentTrack = 0
    var data = [String]()
    
    func playSpotifyPlayList(list: [PlayListItems]){
        
        var musicFile : [MusicFile] = []
        var item : [String] = []
        for list in list {
            if let url = list.track.preview_url{
                let music = MusicFile(title: list.track.name, artist: list.track.artists?.first?.name, imageString: list.track.album?.images?.first?.url, source: url)
                musicFile.append(music)
                item.append(url)
            }
        }
        AudioPlayerManager.shared.play(urlStrings: item, at: 0)
//        playerList.removeAll()
//        playerList = musicFile
//        playMusic()
    }
    
    func playMusic() {
        let url = URL(string: "https://www.learningcontainer.com/wp-content/uploads/2020/02/Kalimba.mp3")!
//        player = AVPlayer(url: url!)
//        ////      self.allowsPictureInPicturePlayback = false
//        player!.play()
//        playerItems.removeAll()
        for clip in playerList {
//            guard let url = URL(string: clip.source) else {
//                fatalError("Could not load url")
//            }
            playerItems.append(AVPlayerItem(url: url))
        }
        currentTrack = 0
        if playerItems.count > 0 {
            playTrack()
        }
    }
}
extension MusicPlayer {
    func previousTrack() {
        if currentTrack - 1 < 0 {
            currentTrack = (playerItems.count - 1) < 0 ? 0 : (playerItems.count - 1)
        } else {
            currentTrack -= 1
        }

        playTrack()
    }

    func nextTrack() {
        if currentTrack + 1 > playerItems.count {
            currentTrack = 0
        } else {
            currentTrack += 1;
        }

        playTrack()
    }

    func playTrack() {

        if playerItems.count > 0 {
            if player == nil {
                player = AVPlayer()
            }
            //player.replaceCurrentItem(with: playerItems[currentTrack])
            player!.play()
        }
    }
}
