//
//  ConnectedStreamsViewController.swift
//  EarEffect
//
//  Created by Muhammad Zafar on 2022-07-16.
//

import UIKit
class ConnectedStreamsViewController: BaseViewController {
    @IBOutlet weak var spotifyView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if SpotifyAuthManager.shared.isSignedIn {
            spotifyView.isHidden = false
        } else {
            spotifyView.isHidden = true
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func spotifyBtnPressed(_ sender: RoundButton) {
        
    }
    
}
