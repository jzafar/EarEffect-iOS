//
//  AvailableStreamViewController.swift
//  EarEffect
//
//  Created by Muhammad Zafar on 2022-07-17.
//

import StoreKit
import UIKit

class AvailableStreamViewController: BaseViewController {
    @IBOutlet var btnSpotify: RoundButton!

    @IBOutlet weak var btnAppleMusic: RoundButton!
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
        
        if AppleMusicManager.shared.isSignedIn {
            btnAppleMusic.setTitle("Disconnect", for: .normal)
        } else {
            btnAppleMusic.setTitle("Connect", for: .normal)
        }
    }

    @IBAction func connectWithSpotifybtnPressed(_ sender: UIButton) {
        if SpotifyAuthManager.shared.isSignedIn {
            // logout
            return
        }

        SpotifyAuthManager.shared.login { [weak self] success in
            DispatchQueue.main.async {
                if !success {
                    let alert = UIAlertController(title: "Opps", message: "Something went wrong", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
                    self?.present(alert, animated: true)
                    return
                } else {
                    APICaller.shared.getCurrentUser { [weak self] result in
                        DispatchQueue.main.async {
                            switch result {
                            case let .success(user):
                                if let current = user {
                                    if current.product == "premium" {
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

                            case let .failure(error):
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
        AppleMusicManager.shared.requestCloudServiceAuthorization { status in
            DispatchQueue.main.async {
                switch status {
                case .notDetermined:
                    self.showOkAlert(title: "Error", message: "Application could not determine apple music.")
                case .denied:
                    self.showOkAlert(title: "Alert", message: "You have rejected apple music permissions. Please go to app setting and enable Media & Apple Music.")
                case .restricted:
                    self.showOkAlert(title: "Alert", message: "You are not allowed to use Apple Music.")
                case .authorized:
                    self.requestCloudServiceCapabilities()
                @unknown default:
                    self.showOkAlert(title: "Alert", message: "Something goes worng.")
                }
            }
        }
    }

    @IBAction func connectWithAmazonBtnPressed(_ sender: UIButton) {
    }
}

extension AvailableStreamViewController {
    func requestCloudServiceCapabilities() {
        AppleMusicManager.shared.requestCloudServiceCapabilities { [weak self] capablity, error in
            if let error = error {
                if error._code == 9 {
                    let tempUserToken = "AlQCxetXVDVq9kr4EyoBxzD0MAp/P6CJdllQuFM0EAaLaeiGczHRpGdSO43RPFSh3K7yGPFdD/uu8IZjUxUObVvmeVLPZNLByvoKNwykfHpohUbE7Qyf2Hc3pS+h+Vv4fsqKvFfkmg7648fNYD5RjvdNfDb3De62RxBQoz0LPEhksiWZb4eKaVU/iPz7AGHIIAr6Y4gr+ykGf1YH7YkeH8BZ2HmxPiCVbng8MHCRpcYqtGbB7w=="
                    UserDefaults.standard.set(tempUserToken, forKey: UserDefaults.apple_token)
                    UserDefaults.standard.synchronize()
                    self?.updateUI()
                }
                self?.showOkAlert(title: "Error", message: error.localizedDescription)
                return
            }
            if let capablity = capablity {
                if capablity.contains(.musicCatalogSubscriptionEligible) {
                    self?.showOkAlert(title: "Alert", message: "You must have valid Apple Music subscription to listen Apple Music.")
                    return
                }
                AppleMusicManager.shared.getUserToken {[weak self] token in
                    if token != nil {
                        self?.updateUI()
                        AppleMusicManager.shared.requestStorefrontCountryCode { _ in
                            
                        }
                    }
                }
            }
        }
    }
}
