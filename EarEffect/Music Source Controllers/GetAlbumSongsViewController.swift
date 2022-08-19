//
//  GetAlbumSongsViewController.swift
//  EarEffect
//
//  Created by Muhammad Zafar on 2022-07-19.
//

import UIKit

class GetAlbumSongsViewController: BaseViewController {

    @IBOutlet var tblView: UITableView!
    var stream: Streams = .spotify
    var type: AlbumOrArtist = .Albums
    var songs : SpotifyPlayListDetailsResponse?
    var spotifyPlayList: SpotifyPlayList?
    var spotifyArtistAlbum:Track?
    var playerController: PlayerViewController?
    var albumTracks: [SpotifyAudioTrack]?
    override func viewDidLoad() {
        super.viewDidLoad()
//        _ = loadPlayerView(in: playerView)
         fetchData()
    }

    func fetchData() {
        
            switch stream {
            case .spotify:
                switch type {
                case .Albums:
                    break
                case .Artists:
                    if let spotifyArtist = spotifyArtistAlbum {
                        fetchSpotifyArtistsAlbumTrack(artist: spotifyArtist)
                    }
                    
                case .PlayLists:
                    if let spotifyPlayList = spotifyPlayList {
                        fetchSpotifyPlayListSongs(playListID: spotifyPlayList)
                    }
                }
            case .amazon:
                break
            case .apple:
                break
            case .youtube:
                break
            }
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PlayerViewController" {
            self.playerController = segue.destination as? PlayerViewController
       }
    }
    
    func fetchSpotifyPlayListSongs(playListID: SpotifyPlayList) {
//        if (playListID.trackCount > 0){
            APICaller.shared.getPlayListDetails(for: playListID.id) { [weak self] results  in
                DispatchQueue.main.async {
                    switch results {
                    case .success(let response):
                        if let result = response {
                            self?.songs = result
                            self?.tblView.reloadData()
                        }
                    case .failure(let error):
                        print("error in fetching list songs \(error.localizedDescription)")
                    }
                }
            }
//        }
    }
    func fetchSpotifyArtistsAlbumTrack(artist: Track){
        if let album  = artist.album {
            APICaller.shared.getAlbumsTracks(albumID: album.id, completion: {  [weak self] results  in
                DispatchQueue.main.async {
                    switch results {
                    case .success(let response):
                        if let result = response {
                            self?.albumTracks = result
                            self?.tblView.reloadData()
                        }
                    case .failure(let error):
                        print("error in fetching list songs \(error.localizedDescription)")
                    }
                }
            })
        }
       
    }
    @IBAction func settingsButtonPressed(_ sender: UIBarButtonItem) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
        //vc.modalPresentationStyle = .overCurrentContext
        vc.modalPresentationStyle = UIModalPresentationStyle.custom
        vc.transitioningDelegate = self
        present(vc, animated: true, completion: nil)
    }
}

extension GetAlbumSongsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if type == .Artists {
            if let songs = albumTracks {
                let song = songs[indexPath.row]
                SpotifyPlayer.shared.playSong(uri: song.uri, index: indexPath.row, startingWithPosition: TimeInterval(0)) { error in
                    print(error)
                }
            }
        }
        if type == .PlayLists{
            guard let response = songs else{
                return
            }
            SpotifyPlayer.shared.playSong(uri: response.uri, index: indexPath.row, startingWithPosition: TimeInterval(0)) { error in
                print(error)
            }
        }
        
    }
}

extension GetAlbumSongsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if type == .Artists {
            return albumTracks?.count ?? 0
        }
        if type == .PlayLists{
            if let songs = songs?.tracks?.items {
                return songs.count
            }
        }
        
       return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",
                                                 for: indexPath) as! AlbumSongTableViewCell
        if type == .Artists {
            if let songs = albumTracks {
                let song = songs[indexPath.row]
                cell.setData(song: song, image: spotifyArtistAlbum?.album?.images?.first?.url)
            }
        } else {
            if let songs = songs?.tracks?.items {
                let song = songs[indexPath.row]
                cell.setData(song: song)
            }
        }
        
        return cell
    }
}
extension GetAlbumSongsViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return CardPresentationController(presentedViewController: presented, presenting: presenting)
    }
}
