//
//  SpotifyPlayer.swift
//  EarEffect
//
//  Created by Muhammad Zafar on 2022-07-21.
//

import CoreAudioTypes
import Foundation

protocol SpotifyPlayerDelegate {
    func startPlayingTrack(track: SPTPlaybackTrack?)
    func receiveNotification(notification: SpPlaybackEvent)
    func loadPlayingSongData(track: SpotifyPlayBackTrack)
    func changeSeekBarPosition(position: Double)
}

class SpotifyPlayer: NSObject {
    static let shared = SpotifyPlayer()
    override private init() {}
    var delegate: SpotifyPlayerDelegate?
    var audioController = SPTAudioStreamingController.sharedInstance()!
    var playBackUri: String = ""
    var playListIndex: UInt = 0
    var isPlaying: Bool = false
    var playingTrack: SPTPlaybackTrack?
    var seekBarPosition: TimeInterval = 0
    var coreAudio = EarEffectCoreAudioController()

    func startAudioController() -> Bool {
        do {
            let result: () = try audioController.start(withClientId: SpotifyConstants.clientID, audioController: coreAudio, allowCaching: true)
            print(result)
            audioController.delegate = self
            audioController.playbackDelegate = self
            audioController.diskCache = SPTDiskCache()
            return true

        } catch let error {
            print(error.localizedDescription)
            return false
        }
    }

    var isPlayingSong: Bool {
        guard audioController.initialized else {
            return false
        }
        guard audioController.loggedIn else {
            return false
        }
        return isPlaying
    }

    /// Supported URI types: Tracks, Albums and Playlists
    func playSong(uri: String, index: Int, startingWithPosition: TimeInterval, completion: @escaping (Bool) -> Void) {
        if audioController.initialized {
            if audioController.loggedIn {
                playBackUri = uri
                playListIndex = UInt(index)
                seekBarPosition = startingWithPosition
                startPlayingSong(playBackUri: uri, startingWith: UInt(index), startingWithPosition: startingWithPosition)
                completion(true)
            } else {
                loginAudioController(uri: uri, index: index, startingWithPosition: startingWithPosition) { succes in
                    completion(succes)
                }
            }
        } else {
            if startAudioController() {
                loginAudioController(uri: uri, index: index, startingWithPosition: startingWithPosition) { succes in
                    completion(succes)
                }
            } else {
                completion(false)
            }
        }
    }

    func loginAudioController(uri: String, index: Int, startingWithPosition: TimeInterval, completion: @escaping (Bool) -> Void) {
        SpotifyAuthManager.shared.withValidToken { [weak self] accessToken in
            self?.playBackUri = uri
            self?.playListIndex = UInt(index)
            self?.seekBarPosition = startingWithPosition
            self?.audioController.login(withAccessToken: accessToken)
            completion(false)
        }
    }

    func startPlayingSong(playBackUri: String, startingWith: UInt, startingWithPosition: TimeInterval) {
        audioController.playSpotifyURI(playBackUri, startingWith: startingWith, startingWithPosition: startingWithPosition) { [weak self] error in
            print(error?.localizedDescription ?? "Error in playing")
            if error == nil {
                self?.isPlaying = true
            }
        }
    }

    // MARK: Play/Pause

    func playPauseBtnPressed(completion:@escaping (Error?) -> Void) {
        if let playBackState = audioController.playbackState {
            audioController.setIsPlaying(!playBackState.isPlaying, callback: completion)
        } else {
            if playBackUri.count > 0 {
                playSong(uri: playBackUri, index: Int(playListIndex), startingWithPosition: seekBarPosition) { _ in
                }
            }
        }
    }

    // MARK: Skip Next

    func skipNextBtnPressed() {
        if audioController.initialized {
            audioController.skipNext(nil)
        }
    }

    // MARK: Skip Previous

    func skipPreviousBtnPressed() {
        if audioController.initialized {
            audioController.skipPrevious(nil)
        }
    }

    // MARK: Shuffle

    func shufflePlayList(shuffle: Bool, completion:@escaping (Error?) -> Void) {
        if audioController.initialized {
            audioController.setShuffle(shuffle) { error in
                print("error in shuffle \(String(describing: error?.localizedDescription))")
                completion(error)
            }
        }
    }

    // MARK: Repeat
    /// repeatValue = 0 repeat off
    /// repeatValue = 2 repeat onc
    func repeatSong(repeatValue: Int, completion:@escaping (Error?) -> Void) {
        if audioController.initialized {
            audioController.setRepeat(SPTRepeatMode(rawValue: UInt(repeatValue))!) { error in
                print("error in repeatSong \(String(describing: error?.localizedDescription))")
                completion(error)
            }
        }
    }

    // MARK: Seek
    func seekToPosition(timeInterval: TimeInterval, completion:@escaping (Error?) -> Void){
        if audioController.initialized {
            audioController.seek(to: timeInterval) { error in
                completion(error)
            }
        }
    }
    
    func loadPlayingSongData(completion:@escaping (Bool) -> Void) {
        SpotifyAuthManager.shared.withValidToken { [weak self] _ in
            if let songUri = UserDefaults.standard.value(forKey: UserDefaults.playBackUri) as? String {
                if let track = self?.getPlayBackTrackInfo() {
                    self?.delegate?.loadPlayingSongData(track: track)
                }
                self?.playListIndex = UInt(UserDefaults.standard.value(forKey: UserDefaults.playListIndex) as? Int ?? 0)
                self?.seekBarPosition = UserDefaults.standard.value(forKey: UserDefaults.seekBarPosition) as? TimeInterval ?? 0
                self?.playBackUri = songUri
            }
            completion(true)
        }
    }

    func getPlayBackTrackInfo() -> SpotifyPlayBackTrack? {
        if let data = UserDefaults.standard.object(forKey: UserDefaults.playingSongData) as? Data {
            let track = SpotifyPlayBackTrack(data: data)
            return track
        }
        return nil
    }
    
    func getSeekBarPosition() -> TimeInterval{
        let position = UserDefaults.standard.value(forKey: UserDefaults.seekBarPosition) as? TimeInterval ?? 0
        return position
    }
    
    func cachePlayingSong() {
        UserDefaults.standard.set(playBackUri, forKey: UserDefaults.playBackUri)
        UserDefaults.standard.set(seekBarPosition, forKey: UserDefaults.seekBarPosition)
        UserDefaults.standard.set(playListIndex, forKey: UserDefaults.playListIndex)
        if let playingTrack = self.playingTrack {
            UserDefaults.standard.set(playingTrack.indexInContext, forKey: UserDefaults.playListIndex)
            let playTrack = SpotifyPlayBackTrack(name: playingTrack.name, uri: playingTrack.uri, playbackSourceUri: playingTrack.playbackSourceUri, playbackSourceName: playingTrack.playbackSourceName, artistName: playingTrack.artistName, artistUri: playingTrack.artistUri, albumName: playingTrack.albumName, albumUri: playingTrack.albumUri, albumCoverArtURL: playingTrack.albumCoverArtURL, duration: playingTrack.duration, indexInContext: playingTrack.indexInContext)
            UserDefaults.standard.set(playTrack.encode(), forKey: UserDefaults.playingSongData)
        }
        UserDefaults.standard.synchronize()
    }
}

extension SpotifyPlayer: SPTAudioStreamingPlaybackDelegate {
    func audioStreaming(_ audioStreaming: SPTAudioStreamingController, didStartPlayingTrack trackUri: String) {
        isPlaying = true
        playingTrack = audioStreaming.metadata.currentTrack
        delegate?.startPlayingTrack(track: playingTrack)
        print("Starting trackUri \(trackUri) name \(String(describing: playingTrack?.name))")
        seekBarPosition = 0
        cachePlayingSong()
//        coreAudio.controllerStartsPlaying()
        // If context is a single track and the uri of the actual track being played is different
        // than we can assume that relink has happended.
//        let isRelinked = SPTAudioStreamingController.sharedInstance().metadata.currentTrack!.playbackSourceUri.contains("spotify:track") && !(SPTAudioStreamingController.sharedInstance().metadata.currentTrack!.playbackSourceUri == trackUri)
//        print("Relinked \(isRelinked)")
    }

    func audioStreaming(_ audioStreaming: SPTAudioStreamingController!, didReceive event: SpPlaybackEvent) {
        print("Receive event rawValue \(event.rawValue)")
        switch event {
        case SPPlaybackNotifyPause:
            print("Receive event SPPlaybackNotifyPause")
            isPlaying = false
        case SPPlaybackNotifyPlay:
            print("Receive event SPPlaybackNotifyPlay")
            isPlaying = true
        case SPPlaybackNotifyTrackChanged: // The current track or its metadata has changed
            break
        case SPPlaybackNotifyNext: break
        case SPPlaybackNotifyPrev: break
        case SPPlaybackNotifyShuffleOn: break
        case SPPlaybackNotifyShuffleOff: break
        case SPPlaybackNotifyRepeatOn: break
        case SPPlaybackNotifyRepeatOff: break
        /**
         * \brief This device has become the active playback device
         *
         * This event occurs when the users moves playback to this device using
         * Spotify Connect, or when playback is moved to this device as a side-effect
         * of invoking one of the SpPlayback...() functions.
         *
         * When this event occurs, it may be a good time to initialize the audio
         * pipeline of the application.  You should not unpause when you receive this
         * event -- wait for SPPlaybackNotifyPlay.
         *
         * \see SpPlaybackIsActiveDevice
         */
        case SPPlaybackNotifyBecameActive: break
        /**
         * \brief This device is no longer the active playback device
         *
         * This event occurs when the user moves playback to a different device using
         * Spotify Connect.
         *
         * When this event occurs, the application should stop producing audio
         * immediately. The application should not take any other action. Specifically,
         * the application must not invoke any of the SpPlayback...() functions
         * unless requested by some subsequent user interaction.
         *
         * \see SpPlaybackIsActiveDevice
         */
        case SPPlaybackNotifyBecameInactive: break
        case SPPlaybackNotifyMetadataChanged: break
        default:
            break
        }

        delegate?.receiveNotification(notification: event)
    }

    func audioStreaming(_ audioStreaming: SPTAudioStreamingController, didStopPlayingTrack trackUri: String) {
        print("Finishing: \(trackUri)")
        isPlaying = false
    }

    func audioStreaming(_ audioStreaming: SPTAudioStreamingController!, didChangePosition position: TimeInterval) {
//        print("didChangePosition position \(position)")
        seekBarPosition = position
        delegate?.changeSeekBarPosition(position: position)
        UserDefaults.standard.set(seekBarPosition, forKey: UserDefaults.seekBarPosition)
        UserDefaults.standard.synchronize()
    }
}

extension SpotifyPlayer: SPTAudioStreamingDelegate {
    func audioStreamingDidLogin(_ audioStreaming: SPTAudioStreamingController) {
        startPlayingSong(playBackUri: playBackUri, startingWith: playListIndex, startingWithPosition: seekBarPosition)
    }

    func audioStreamingDidLogout(_ audioStreaming: SPTAudioStreamingController!) {
        print("audio streaming did logout")
        isPlaying = false
    }

    func audioStreamingDidDisconnect(_ audioStreaming: SPTAudioStreamingController!) {
        isPlaying = false
    }
    
    func audioStreaming(_ audioStreaming: SPTAudioStreamingController!, didReceiveError error: Error!) {
        print("audio streaming didReceiveError \(error.localizedDescription)")
    }
}
