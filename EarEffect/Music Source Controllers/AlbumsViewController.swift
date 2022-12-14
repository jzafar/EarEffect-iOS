//
//  AlbumsViewController.swift
//  EarEffect
//
//  Created by Muhammad Zafar on 2022-07-18.
//

import MapKit
import UIKit

class AlbumsViewController: BaseViewController {
    var stream: Streams = .spotify
    var type: AlbumOrArtist = .Albums
    @IBOutlet var collectionView: UICollectionView!
    var spotifyPlayLists: [SpotifyPlayList] = []
    var spotifyArtists: [SpotifyArtist] = []
    var playerController: PlayerViewController?
    var artitsAlabum: [Track]?
    var spotifySelectedArtist: SpotifyArtist?
    var shouldFetchArtistAlbum = false
    override func viewDidLoad() {
        super.viewDidLoad()
        if let spotifySelectedArtist = spotifySelectedArtist {
            fetchSpotifyArtists(artist: spotifySelectedArtist)
        } else {
            switch stream {
            case .spotify:
                switch type {
                case .Albums:
                    fetchSpotifyAlbums()
                case .Artists:
                    fetchArtist()
                case .PlayLists:
                    fetchSpotifyPlayLists()
                }

            case .apple: break
            case .amazon: break
            case .youtube: break
            }
        }
    }

    func fetchSpotifyArtists(artist: SpotifyArtist){
        APICaller.shared.getArtistTopSongs(artistID: artist.id, completion: {  [weak self] results  in
            DispatchQueue.main.async {
                switch results {
                case .success(let response):
                    if let result = response {
                        //self?.songs = result
                        self?.artitsAlabum = result
                        self?.collectionView.reloadData()
                    }
                case .failure(let error):
                    print("error in fetching list songs \(error.localizedDescription)")
                }
            }
        })
    }
    
    private func fetchSpotifyAlbums() {
        APICaller.shared.getAlbums { [weak self] results in
            switch results {
            case let .success(albums): break
            case let .failure(error): break
            }
        }
    }

    private func fetchArtist(){
        APICaller.shared.getArtists { [weak self] results in
            DispatchQueue.main.async {
                switch results {
                case .success(let artists):
                    if let artists = artists {
                        self?.spotifyArtists = artists
                        self?.collectionView.reloadData()
                    }
                    
                case .failure(let error):
                    print("fail to get artists \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func fetchSpotifyPlayLists() {
        APICaller.shared.getUserPlayList {[weak self] results in
            DispatchQueue.main.async {
                switch results {
                case .success(let playList):
                    self?.spotifyPlayLists = playList ?? []
                    self?.collectionView.reloadData()
                case .failure(let error):
                    print("fail to get playlist \(error.localizedDescription)")
                }
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GetAlbumSongsViewController" {
            let vc = segue.destination as! GetAlbumSongsViewController
            guard let indexPath = sender as? IndexPath else { return }
            switch stream {
            case .spotify:
                switch type {
                case .Albums:
                    break
                case .Artists:
                    if let artitsAlabum = artitsAlabum {
                        let artist = artitsAlabum[indexPath.row]
                        vc.type = .Artists
                        vc.stream = stream
                        vc.spotifyArtistAlbum = artist
                    }
                    
                case .PlayLists:
                    let playList = spotifyPlayLists[indexPath.row]
                    vc.type = .PlayLists
                    vc.stream = stream
                    vc.spotifyPlayList = playList
                }

            case .apple: break
            case .amazon: break
            case .youtube: break
            }
        } else if segue.identifier == "PlayerViewController" {
                self.playerController = segue.destination as? PlayerViewController
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

extension AlbumsViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath) as! AlbumCollectionViewCell
        if let artitsAlabum = artitsAlabum {
            let playList = artitsAlabum[indexPath.row]
            if let image = playList.album?.images?.first?.url {
                cell.setData(name: playList.name, image: URL(string: image))
            } else {
                cell.setData(name: playList.name, image: nil)
            }
        } else {
            switch stream {
            case .spotify:
                switch type {
                case .Albums:
                    break
                case .Artists:
                    let artist = spotifyArtists[indexPath.row]
                    if let image = artist.images?.first?.url {
                        cell.setData(name: artist.name, image: URL(string: image))
                    } else {
                        cell.setData(name: artist.name, image: nil)
                    }
                case .PlayLists:
                    let playList = spotifyPlayLists[indexPath.row]
                    if let image = playList.images?.first?.url {
                        cell.setData(name: playList.name, image: URL(string: image))
                    } else {
                        cell.setData(name: playList.name, image: nil)
                    }
                    
                }

            case .apple: break
            case .amazon: break
            case .youtube: break
            }
        }
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        if let artitsAlabum = artitsAlabum {
            return artitsAlabum.count
        } else {
        switch stream {
        case .spotify:
            switch type {
            case .Albums:
                return 0
            case .Artists:
                return spotifyArtists.count
            case .PlayLists:
                return spotifyPlayLists.count
            }

        case .apple: break
        case .amazon: break
        case .youtube: break
        }
        return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if type == .Artists && shouldFetchArtistAlbum {
            let inst = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AlbumsViewController") as! AlbumsViewController
            inst.type = .Artists
            inst.stream = .spotify
            inst.spotifySelectedArtist = self.spotifyArtists[indexPath.row]
            inst.shouldFetchArtistAlbum = false
            self.navigationController?.pushViewController(inst, animated: true)
        } else {
            performSegue(withIdentifier: "GetAlbumSongsViewController", sender: indexPath)
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfSections section: Int) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let leftAndRightPaddings: CGFloat = 20.0
        let numberOfItemsPerRow: CGFloat = 2.0

        let width = (collectionView.frame.width - leftAndRightPaddings) / numberOfItemsPerRow
        return CGSize(width: width, height: width)
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CollectionViewSectionHeader", for: indexPath) as? CollectionViewSectionHeader {
            switch type {
            case .Albums:
                sectionHeader.sectionHeaderlabel.text = "Albums"
            case .Artists:
                sectionHeader.sectionHeaderlabel.text = "Artists"
            case .PlayLists:
                sectionHeader.sectionHeaderlabel.text = "PlayLists"
            }
            return sectionHeader
        }
        return UICollectionReusableView()
    }
}
extension AlbumsViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return CardPresentationController(presentedViewController: presented, presenting: presenting)
    }
}
