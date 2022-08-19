//
//  AlbumSongTableViewCell.swift
//  EarEffect
//
//  Created by Muhammad Zafar on 2022-07-19.
//

import UIKit
import Kingfisher

class AlbumSongTableViewCell: UITableViewCell {

    @IBOutlet weak var lblSongImage: UIImageView!
    @IBOutlet weak var lblDuration: UILabel!
    @IBOutlet weak var lblSongTitle: UILabel!
    @IBOutlet weak var lblArtistNmae: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(song:PlayListItems){
        lblSongTitle.text = song.track.name
        lblArtistNmae.text = song.track.artists?.first?.name
        let time = TimeUtility.secondsToHoursMinutesSeconds(song.track.duration_ms)
        
        lblDuration.text = time
        if let image = song.track.album?.images?.first?.url{
            let url = URL(string: image)
            lblSongImage.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"))
            
        }
    }
    
    func setData(song:SpotifyAudioTrack, image:String?){
        lblSongTitle.text = song.name
        lblArtistNmae.text = song.artists?.first?.name
        let time = TimeUtility.secondsToHoursMinutesSeconds(song.duration_ms)
        lblDuration.text = time
        if let image = image{
            let url = URL(string: image)
            lblSongImage.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"))
            
        }
    }
}

extension Int {
    var msToSeconds: Double { Double(self) / 1000 }
}
extension TimeInterval {
    var hour: Int {
        Int((self/3600).truncatingRemainder(dividingBy: 3600))
    }
}
