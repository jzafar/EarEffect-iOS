//
//  ApplePlayer.swift
//  EarEffect
//
//  Created by Muhammad Zafar on 2022-08-11.
//

import Foundation
import MediaPlayer

@objcMembers
class ApplePlayer: NSObject {
    static let shared = ApplePlayer()
    static let didUpdateState = NSNotification.Name("didUpdateState")
    
    let musicPlayerController = MPMusicPlayerController.systemMusicPlayer
    
    override private init() {
        super.init()
        musicPlayerController.beginGeneratingPlaybackNotifications()
        
        let notificationCenter = NotificationCenter.default
        
        notificationCenter.addObserver(self,
                                       selector: #selector(handleMusicPlayerControllerNowPlayingItemDidChange),
                                       name: .MPMusicPlayerControllerNowPlayingItemDidChange,
                                       object: musicPlayerController)
        
        notificationCenter.addObserver(self,
                                       selector: #selector(handleMusicPlayerControllerPlaybackStateDidChange),
                                       name: .MPMusicPlayerControllerPlaybackStateDidChange,
                                       object: musicPlayerController)
    }
    
    deinit {
        /*
         It is important to call `MPMusicPlayerController.endGeneratingPlaybackNotifications()` so that
         playback notifications are no longer generated.
         */
        musicPlayerController.endGeneratingPlaybackNotifications()
        
        // Remove all notification observers.
        let notificationCenter = NotificationCenter.default
        
        notificationCenter.removeObserver(self,
                                          name: .MPMusicPlayerControllerNowPlayingItemDidChange,
                                          object: musicPlayerController)
        notificationCenter.removeObserver(self,
                                          name: .MPMusicPlayerControllerPlaybackStateDidChange,
                                          object: musicPlayerController)
    }
    
    // MARK: Notification Observing Methods
    
    func handleMusicPlayerControllerNowPlayingItemDidChange() {
       
    }
    
    func handleMusicPlayerControllerPlaybackStateDidChange() {
       
    }
    
    // MARK: Playback Loading Methods
    
    func beginPlayback(itemCollection: MPMediaItemCollection) {
        musicPlayerController.setQueue(with: itemCollection)
        
        musicPlayerController.play()
    }
    
    func beginPlayback(itemID: String) {
        musicPlayerController.setQueue(with: [itemID])
        
        musicPlayerController.play()
    }
    
    // MARK: Playback Control Methods
    
    func togglePlayPause() {
        if musicPlayerController.playbackState == .playing {
            musicPlayerController.pause()
        } else {
            musicPlayerController.play()
        }
    }
    
    func skipToNextItem() {
        musicPlayerController.skipToNextItem()
    }
    
    func skipBackToBeginningOrPreviousItem() {
        if musicPlayerController.currentPlaybackTime < 5 {
            // If the currently playing `MPMediaItem` is less than 5 seconds into playback then skip to the previous item.
            musicPlayerController.skipToPreviousItem()
        } else {
            // Otherwise skip back to the beginning of the currently playing `MPMediaItem`.
            musicPlayerController.skipToBeginning()
        }
    }
}
