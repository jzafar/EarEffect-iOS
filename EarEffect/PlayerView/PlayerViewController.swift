//
//  PlayerViewController.swift
//  EarEffect
//
//  Created by Muhammad Zafar on 2022-07-22.
//

import Kingfisher
import UIKit
class PlayerViewController: UIViewController {
    @IBOutlet var songImage: UIImageView!

    @IBOutlet weak var btnShuffle: UIButton!
    @IBOutlet var lblTitle: UILabel!

    @IBOutlet weak var btnRepeat: UIButton!
    @IBOutlet var lblTotalTime: UILabel!
    @IBOutlet var lblZeroTime: UILabel!
    @IBOutlet var slider: HorizontalSlider!
    @IBOutlet var btnPlayerView: UIButton!
    let spotifyPlayer = SpotifyPlayer.shared
    @IBOutlet var btnPlay: UIButton!
    var isChangingSlider = false
    override func viewDidLoad() {
        super.viewDidLoad()
        songImage.layer.cornerRadius = 5.0
        slider.addTarget(self, action: #selector(PlayerViewController.handleSliderValueChanged(_:)), for: .valueChanged)
        let touchRecognizer = UITapGestureRecognizer(target: self, action: #selector(PlayerViewController.handleTouchGesture(_:)))
        slider.addGestureRecognizer(touchRecognizer)
    }

    override func viewWillAppear(_ animated: Bool) {
        spotifyPlayer.delegate = self
        self.updateUI()
        spotifyPlayer.loadPlayingSongData {_ in }
       
    }

    override func viewWillDisappear(_ animated: Bool) {
        spotifyPlayer.delegate = nil
    }

    @objc func handleTouchGesture(_ gesture: UITapGestureRecognizer) {
        print("handleTouchGesture called \(gesture.state.rawValue)")
//        if gesture.state == .began {
//            isChangingSlider = true
//        }
//        if gesture.state == .ended {
//            isChangingSlider = false
//        }
    }

    @IBAction func repeatBtnPressed(_ sender: UIButton) {
        var repeatValue = 0
        if !sender.isSelected {
            repeatValue = 2
        }
        spotifyPlayer.repeatSong(repeatValue: repeatValue) { error in
            if error == nil {
                sender.isSelected = !sender.isSelected
            }
        }
    }

    @IBAction func previousTrackBtnPressed(_ sender: UIButton) {
        spotifyPlayer.skipPreviousBtnPressed()
    }

    @IBAction func playButtonPressed(_ sender: UIButton) {
        spotifyPlayer.playPauseBtnPressed { error in
            if error == nil {
                sender.isSelected = !sender.isSelected
            }
        }
    }

    @IBAction func nextBtnPressed(_ sender: UIButton) {
        spotifyPlayer.skipNextBtnPressed()
    }

    @IBAction func shuffleBtnPressed(_ sender: UIButton) {
        spotifyPlayer.shufflePlayList(shuffle: !sender.isSelected){ error in
            if error == nil {
                sender.isSelected = !sender.isSelected
            }
        }
    }

    func updateUI(_ notification: SpPlaybackEvent? = nil) {
        DispatchQueue.main.async {
            if let track = self.spotifyPlayer.playingTrack {
                self.lblTitle.text = track.name
                let url = URL(string: track.albumCoverArtURL ?? "")
                self.songImage.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"))
                self.lblTotalTime.text = TimeUtility.stringFromTimeInterval(interval: track.duration)
            } else {
                self.lblTitle.text = ""
                self.songImage.image = UIImage(named: "")
                self.slider.isHidden = true
                self.lblZeroTime.isHidden = true
                self.lblTotalTime.isHidden = true
            }
            if let state = self.spotifyPlayer.audioController.playbackState {
                if state.isPlaying {
                    self.btnPlay.isSelected = true
                }
                if state.isRepeating {
                    self.btnRepeat.isSelected = true
                } else {
                    self.btnRepeat.isSelected = false
                }
                if state.isShuffling {
                    self.btnShuffle.isSelected = true
                } else {
                    self.btnShuffle.isSelected = false
                }
                self.slider.value = Float(state.position)
                self.lblZeroTime.text = TimeUtility.stringFromTimeInterval(interval: state.position)
            } else {
                self.btnPlay.isSelected = false
                self.btnRepeat.isSelected = false
                self.btnShuffle.isSelected = false
            }
        }
    }

    @objc func handleSliderValueChanged(_ sender: Any) {
        if let slider = sender as? UISlider {
            print("slider value \(slider)")
            spotifyPlayer.seekToPosition(timeInterval: TimeInterval(slider.value)) { error in
                if error == nil {
                }
            }
        }
    }
}

extension PlayerViewController: SpotifyPlayerDelegate {
    func changeSeekBarPosition(position: Double) {
        DispatchQueue.main.async {
            if self.slider.isHidden {
                self.slider.isHidden = false
                self.lblZeroTime.isHidden = false
                self.lblTotalTime.isHidden = false
            }
            if !self.isChangingSlider {
                self.slider.value = Float(position)
            }
            self.lblZeroTime.text = TimeUtility.stringFromTimeInterval(interval: position)
        }
    }

    func loadPlayingSongData(track: SpotifyPlayBackTrack) {
        DispatchQueue.main.async {
            self.lblTitle.text = track.name
            let url = URL(string: track.albumCoverArtURL ?? "")
            self.slider.maximumValue = Float(track.duration)
            self.slider.minimumValue = 0.0
            self.slider.value = Float(self.spotifyPlayer.getSeekBarPosition())
            self.lblZeroTime.text = TimeUtility.stringFromTimeInterval(interval: self.spotifyPlayer.getSeekBarPosition())
            self.lblTotalTime.text = TimeUtility.stringFromTimeInterval(interval: track.duration)
            self.slider.isHidden = false
            self.lblZeroTime.isHidden = false
            self.lblTotalTime.isHidden = false
            self.songImage.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"))
            
        }
    }

    func receiveNotification(notification: SpPlaybackEvent) {
        updateUI(notification)
    }

    func startPlayingTrack(track: SPTPlaybackTrack?) {
        updateUI()
    }
}
