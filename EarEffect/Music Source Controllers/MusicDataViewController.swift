//
//  MusicDataViewController.swift
//  EarEffect
//
//  Created by Muhammad Zafar on 2022-07-18.
//

import UIKit

class MusicDataViewController: BaseViewController {
    @IBOutlet var tableView: UITableView!
    var type : AlbumOrArtist = .Albums
    var selectedStram: Streams = .spotify
    var connectedStreams: [Streams] = []
    var playerController: PlayerViewController?
    var isArtists = false
    @IBOutlet weak var playerView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: false)
//        _ = loadPlayerView(in: playerView)
        let nib = UINib(nibName: "MusicTableViewHeader", bundle: nil)
        tableView.register(nib, forHeaderFooterViewReuseIdentifier: "MusicTableViewHeader")

        let cell = UINib(nibName: "MusicDataTableViewCell", bundle: nil)
        tableView.register(cell, forCellReuseIdentifier: "cell")
        connectedStreams = ConnectedStreams.getConnectedStream()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        isArtists = false
    }
    @IBAction func settingBtnPressed(_ sender: UIBarButtonItem) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
        //vc.modalPresentationStyle = .overCurrentContext
        vc.modalPresentationStyle = UIModalPresentationStyle.custom
        vc.transitioningDelegate = self
        present(vc, animated: true, completion: nil)
    }
    @objc private func playListBtnPressed(_ sender: RoundButton){
        selectedStram = sender.streamButton ?? .spotify
        type = .PlayLists
        self.performSegue(withIdentifier: "AlbumsViewController", sender: self)
    }
    @objc private func songsBtnPressed(_ sender: RoundButton){
        selectedStram = sender.streamButton ?? .spotify
    }
    @objc private func albumBtnPressed(_ sender: RoundButton){
        type = .Albums
        selectedStram = sender.streamButton ?? .spotify
        self.performSegue(withIdentifier: "AlbumsViewController", sender: self)
    }
    @objc private func artistBtnPressed(_ sender: RoundButton){
        type = .Artists
        selectedStram = sender.streamButton ?? .spotify
        isArtists = true
        self.performSegue(withIdentifier: "AlbumsViewController", sender: self)
//        print(sender.streamButton)
    }
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AlbumsViewController" {
            let vc = segue.destination as? AlbumsViewController
            vc?.type = type
            vc?.stream = selectedStram
            vc?.shouldFetchArtistAlbum = isArtists
        } else if segue.identifier == "PlayerViewController" {
            self.playerController = segue.destination as? PlayerViewController
       }
        
    }
    
}
extension MusicDataViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return CardPresentationController(presentedViewController: presented, presenting: presenting)
    }
}
extension MusicDataViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let stream = connectedStreams[section]
        let view = self.tableView.dequeueReusableHeaderFooterView(withIdentifier: "MusicTableViewHeader") as! MusicTableViewHeader
        view.setStream(stream: stream)
        view.backgroundColor = .clear
        return view
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
    }
}

extension MusicDataViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
           return connectedStreams.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",
                                                 for: indexPath) as! MusicDataTableViewCell
        
        let stream = connectedStreams[indexPath.section]
        cell.configureStream(stream: stream)
        configureButtonActions(stream: stream, cell: cell)
        return cell
    }
    
    private func configureButtonActions(stream: Streams, cell: MusicDataTableViewCell){
            cell.btnPlayList.addTarget(self, action: #selector(MusicDataViewController.playListBtnPressed(_ :)), for: .touchUpInside)
            cell.btnSongs.addTarget(self, action: #selector(MusicDataViewController.songsBtnPressed(_ :)), for: .touchUpInside)
            cell.btnArtist.addTarget(self, action: #selector(MusicDataViewController.artistBtnPressed(_ :)), for: .touchUpInside)
            cell.btnAlbums.addTarget(self, action: #selector(MusicDataViewController.albumBtnPressed(_ :)), for: .touchUpInside)
    }
}
enum AlbumOrArtist {
    case Albums
    case Artists
    case PlayLists
}
