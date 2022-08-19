//
//  MusicDataTableViewCell.swift
//  EarEffect
//
//  Created by Muhammad Zafar on 2022-07-18.
//

import UIKit

class MusicDataTableViewCell: UITableViewCell {
    @IBOutlet weak var btnSongs: RoundButton!
    
    @IBOutlet weak var btnAlbums: RoundButton!
    @IBOutlet weak var btnArtist: RoundButton!
    @IBOutlet weak var btnPlayList: RoundButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configureStream(stream:Streams){
        btnAlbums.streamButton = stream
        btnSongs.streamButton = stream
        btnArtist.streamButton = stream
        btnPlayList.streamButton = stream
    }
    @IBAction func artistsBtnPressed(_ sender: RoundButton) {
    }
    
    @IBAction func albumsBtnPressed(_ sender: RoundButton) {
    }
    @IBAction func songBtnPressed(_ sender: RoundButton) {
    }
    @IBAction func playListBtnPressed(_ sender: RoundButton) {
    }
    
}
