//
//  AlbumCollectionViewCell.swift
//  EarEffect
//
//  Created by Muhammad Zafar on 2022-07-18.
//

import UIKit

import Kingfisher

class AlbumCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imageView: UIImageView!

    lazy var urlSession: URLSession = {
        // Configure the `URLSession` instance that is going to be used for making network calls.
        let urlSessionConfiguration = URLSessionConfiguration.default

        return URLSession(configuration: urlSessionConfiguration)
    }()
    
    func setData(name: String, image: URL?){
        self.lblName.text = name
//        imageView.setImage(url: <#T##String#>, placeholderImage: <#T##UIImage?#>)
        imageView.kf.setImage(with: image, placeholder: UIImage(named: "placeholder"))
    }
    
    func setAppleArtistArtwork(artist: AppleArtist) {
        self.lblName.text = artist.attributes.name
//        artwork(width: 200, height: 200, id: artist.id) { url in
//            self.imageView.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"))
//        }
//        
    }
    
}

class CollectionViewSectionHeader: UICollectionReusableView {
    @IBOutlet weak var sectionHeaderlabel: UILabel!
}

extension AlbumCollectionViewCell {
    func artwork(width: Int = 1024, height: Int = 1024, id: String, completion: @escaping(URL?) -> Void){

        let countryCode = UserDefaults.standard.string(forKey: UserDefaults.country_code) ?? "jp"
        let url = URL(string: "https://music.apple.com/\(countryCode)/artist/\(id)")!
        let urlReq = URLRequest(url: url)
        let task = urlSession.dataTask(with: urlReq) { data, response, error in
            guard error == nil, let urlResponse = response as? HTTPURLResponse, urlResponse.statusCode == 200 else {
                completion(nil)
                return
            }

            do {
                guard let data = data else {
                    return
                }
                let str = String(decoding: data, as: UTF8.self)
                let json = try JSONSerialization.jsonObject(with: data)
                
                completion(nil)
            } catch {
                print("An error occurred: \(error.localizedDescription)")
            }
        }

        task.resume()
        
        
//        return await withCheckedContinuation { continuation in
//            OpenGraph.fetch(url: url) { result in
//                switch result {
//                    case .success(let og):
//                        let image = og[.image]?.resizeArtwork(width: width, height: height)
//
//                        if let image = image, let url = URL(string: image) {
//                            continuation.resume(returning: url)
//                        } else {
//                            continuation.resume(returning: nil)
//                        }
//                    case .failure(_):
//                        continuation.resume(returning: nil)
//                }
//            }
//        }
    }
}

extension String {
    func resizeArtwork(width: Int, height: Int) -> String? {
        do {
            let regex = try NSRegularExpression(pattern: "/\\d+x\\d+cw", options: .caseInsensitive)
            let newImage = regex.stringByReplacingMatches(in: self, options: [], range: NSRange(0..<self.utf16.count), withTemplate: "/\(width)x\(height)cc")
            return newImage
        } catch {
            return nil
        }
    }
}
