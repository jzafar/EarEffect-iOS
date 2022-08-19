//
//  MusicTableViewHeader.swift
//  EarEffect
//
//  Created by Muhammad Zafar on 2022-07-18.
//

import UIKit

class MusicTableViewHeader: UITableViewHeaderFooterView {

    @IBOutlet weak var imageView: UIImageView!
    
    func setStream(stream: Streams){
        switch stream {
        case .spotify:
            imageView.image = UIImage(named: "Spotify_logo_with_text")
        case .amazon:
            imageView.image = UIImage(named: "amazon")
        case .apple:
            imageView.image = UIImage(named: "apple-music")
        case .youtube:
            imageView.image = UIImage(named: "Spotify_logo_with_text")
        }
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
