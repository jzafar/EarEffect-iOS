//
//  AvailableStreamViewController.swift
//  EarEffect
//
//  Created by Muhammad Zafar on 2022-07-17.
//

import UIKit

class AvailableStreamViewController: BaseViewController {
    @IBOutlet var btnSpotify: RoundButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }

    func updateUI() {
        if SpotifyAuthManager.shared.isSignedIn {
            btnSpotify.setTitle("Disconnect", for: .normal)
        } else {
            btnSpotify.setTitle("Connect", for: .normal)
        }
    }

    @IBAction func connectWithSpotifybtnPressed(_ sender: UIButton) {
        if SpotifyAuthManager.shared.isSignedIn {
            // logout
            return
        }

        SpotifyAuthManager.shared.login { [weak self] success in
            DispatchQueue.main.async {
                if  !success {
                    let alert = UIAlertController(title: "Opps", message: "Something went wrong", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
                    self?.present(alert, animated: true)
                    return
                }
                else {
                    APICaller.shared.getCurrentUser { [weak self] result in
                        DispatchQueue.main.async {
                            switch result {
                                
                            case .success(let user):
                                if let current = user {
                                    if current.product == "premium"{
                                        self?.updateUI()
                                        SpotifyAuthManager.shared.saveSpotifyUser(user: current)
                                    } else {
                                        SpotifyAuthManager.shared.clearCache()
                                        let alert = UIAlertController(title: "", message: "You Must be Premium member of Spotify to use our App.", preferredStyle: .alert)
                                        alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
                                        self?.present(alert, animated: true)
                                        return
                                    }
                                }
                                
                            case .failure(let error):
                                SpotifyAuthManager.shared.clearCache()
                                print("fetching User info \(error.localizedDescription)")
                                let alert = UIAlertController(title: "", message: "You Must be Premium member of Spotify to use our App.", preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
                                self?.present(alert, animated: true)
                                return
                            }
                        }
                    }
                }
               
            }
        }
    }

    @IBAction func connectWithAppleMusicBtnPressed(_ sender: UIButton) {
    }

    @IBAction func connectWithAmazonBtnPressed(_ sender: UIButton) {
    }

//    func handleSignIn(success: Bool) {
//        if success {
//            btnSpotify.setTitle("Connected", for: .normal)
//        } else {
//            let alert = UIAlertController(title: "Opps", message: "Something went wrong", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
//
//            present(alert, animated: true)
//        }
//    }
}
