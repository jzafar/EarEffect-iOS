//
//  AppleMusicApiCaller.swift
//  EarEffect
//
//  Created by Muhammad Zafar on 2022-08-10.
//

import Foundation

class AppleMusicApiCaller {
    static let shared = AppleMusicApiCaller()
    private init() {}
    struct Constant {
        static let baseURL = "api.music.apple.com"
    }

    private var regionCode: String {
        return UserDefaults.standard.string(forKey: UserDefaults.country_code) ?? "us"
    }

    /// The instance of `URLSession` that is going to be used for making network calls.
    lazy var urlSession: URLSession = {
        // Configure the `URLSession` instance that is going to be used for making network calls.
        let urlSessionConfiguration = URLSessionConfiguration.default

        return URLSession(configuration: urlSessionConfiguration)
    }()

    enum HTTPMethod: String {
        case GET
        case POST
    }

    func fetchAlbums(completion: @escaping ([AppleAlbums]?) -> Void) {
        let playList = "/v1/me/library/albums"
        guard let urlRequest = createRequest(path: playList, type: .GET, userToken: AppleMusicManager.shared.userToken) else {
            return
        }
        let task = urlSession.dataTask(with: urlRequest) { data, response, error in
            guard error == nil, let urlResponse = response as? HTTPURLResponse, urlResponse.statusCode == 200 else {
                completion(nil)
                return
            }

            do {
                guard let data = data else {
                    return
                }
                let result = try JSONDecoder().decode(AppleAlbumResponse.self, from: data)
                completion(result.data)
            } catch {
                fatalError("An error occurred: \(error.localizedDescription)")
            }
        }

        task.resume()
    }

    func fetchSongs(completion: @escaping (AppleTrackResponse?) -> Void) {
        let playList = "/v1/me/library/songs"
        guard let urlRequest = createRequest(path: playList, type: .GET, userToken: AppleMusicManager.shared.userToken) else {
            return
        }
        let task = urlSession.dataTask(with: urlRequest) { data, response, error in
            guard error == nil, let urlResponse = response as? HTTPURLResponse, urlResponse.statusCode == 200 else {
                completion(nil)
                return
            }

            do {
                guard let data = data else {
                    return
                }
                let result = try JSONDecoder().decode(AppleTrackResponse.self, from: data)
                completion(result)
            } catch {
                fatalError("An error occurred: \(error.localizedDescription)")
            }
        }

        task.resume()
    }

    func fetchPlayList(completion: @escaping ([ApplePlayList]?) -> Void) {
        let playList = "/v1/me/library/playlists"
        guard let urlRequest = createRequest(path: playList, type: .GET, userToken: AppleMusicManager.shared.userToken) else {
            return
        }
        let task = urlSession.dataTask(with: urlRequest) { data, response, error in
            guard error == nil, let urlResponse = response as? HTTPURLResponse, urlResponse.statusCode == 200 else {
                return
            }

            do {
                guard let data = data else {
                    return
                }

//                let json = try JSONSerialization.jsonObject(with: data)
//
//                do {
//                    let decoder = JSONDecoder()
//                    let messages = try decoder.decode(ApplePlayListResponse.self, from: data)
//                    print(messages as Any)
//                } catch let DecodingError.dataCorrupted(context) {
//                    print(context)
//                } catch let DecodingError.keyNotFound(key, context) {
//                    print("Key '\(key)' not found:", context.debugDescription)
//                    print("codingPath:", context.codingPath)
//                } catch let DecodingError.valueNotFound(value, context) {
//                    print("Value '\(value)' not found:", context.debugDescription)
//                    print("codingPath:", context.codingPath)
//                } catch let DecodingError.typeMismatch(type, context) {
//                    print("Type '\(type)' mismatch:", context.debugDescription)
//                    print("codingPath:", context.codingPath)
//                } catch {
//                    print("error: ", error)
//                }
                let result = try JSONDecoder().decode(ApplePlayListResponse.self, from: data)
                completion(result.data)

            } catch {
                fatalError("An error occurred: \(error.localizedDescription)")
            }
        }

        task.resume()
    }

    func fetchArtist(completion: @escaping (AppleArtistResponse?) -> Void) {
        let playList = "/v1/me/library/artists"
        guard let urlRequest = createRequest(path: playList, type: .GET, userToken: AppleMusicManager.shared.userToken) else {
            return
        }
        let task = urlSession.dataTask(with: urlRequest) { data, response, error in
            guard error == nil, let urlResponse = response as? HTTPURLResponse, urlResponse.statusCode == 200 else {
                return
            }

            do {
                guard let data = data else {
                    return
                }
//                let json = try JSONSerialization.jsonObject(with: data)
                let result = try JSONDecoder().decode(AppleArtistResponse.self, from: data)
                completion(result)

            } catch {
                fatalError("An error occurred: \(error.localizedDescription)")
            }
        }

        task.resume()
    }

    func fetchArtistAlbums(artistId: String, completion: @escaping ([AppleAlbums]?) -> Void) {
        let playList = "/v1/me/library/artists/\(artistId)/albums"
        guard let urlRequest = createRequest(path: playList, type: .GET, userToken: AppleMusicManager.shared.userToken) else {
            return
        }
        let task = urlSession.dataTask(with: urlRequest) { data, response, error in
            guard error == nil, let urlResponse = response as? HTTPURLResponse, urlResponse.statusCode == 200 else {
                return
            }

            do {
                guard let data = data else {
                    return
                }
//                let json = try JSONSerialization.jsonObject(with: data)
                let result = try JSONDecoder().decode(AppleAlbumResponse.self, from: data)
                completion(result.data)

            } catch {
                fatalError("An error occurred: \(error.localizedDescription)")
            }
        }

        task.resume()
    }

    func fetchPlyListSongs(playListId: String, completion: @escaping (AppleTrackResponse?) -> Void) {
        let playList = "/v1/me/library/playlists/\(playListId)/tracks"
        guard let urlRequest = createRequest(path: playList, type: .GET, userToken: AppleMusicManager.shared.userToken) else {
            return
        }
        let task = urlSession.dataTask(with: urlRequest) { data, response, error in
            guard error == nil, let urlResponse = response as? HTTPURLResponse, urlResponse.statusCode == 200 else {
                return
            }

            do {
                guard let data = data else {
                    return
                }
                let result = try JSONDecoder().decode(AppleTrackResponse.self, from: data)
                completion(result)

            } catch {
                fatalError("An error occurred: \(error.localizedDescription)")
            }
        }

        task.resume()
    }

    func fetchAlbumSongs(albumId: String, completion: @escaping (AppleTrackResponse?) -> Void) {
        let playList = "/v1/me/library/albums/\(albumId)/tracks"
        guard let urlRequest = createRequest(path: playList, type: .GET, userToken: AppleMusicManager.shared.userToken) else {
            return
        }
        let task = urlSession.dataTask(with: urlRequest) { data, response, error in
            guard error == nil, let urlResponse = response as? HTTPURLResponse, urlResponse.statusCode == 200 else {
                return
            }

            do {
                guard let data = data else {
                    return
                }

                let result = try JSONDecoder().decode(AppleTrackResponse.self, from: data)
                completion(result)

            } catch {
                fatalError("An error occurred: \(error.localizedDescription)")
            }
        }

        task.resume()
    }

    func createRequest(path: String, type: HTTPMethod, userToken: String?) -> URLRequest? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = Constant.baseURL
        urlComponents.path = path
        
        let urlParameters = ["limit": "100"]
        
        var queryItems = [URLQueryItem]()
        for (key, value) in urlParameters {
            queryItems.append(URLQueryItem(name: key, value: value))
        }
        
        urlComponents.queryItems = queryItems
        
        var urlRequest = URLRequest(url: urlComponents.url!)
        urlRequest.httpMethod = type.rawValue

        urlRequest.addValue("Bearer \(AppleMusicManager.shared.developerToken)", forHTTPHeaderField: "Authorization")
        if let token = userToken {
            urlRequest.addValue(token, forHTTPHeaderField: "Music-User-Token")
        }
        return urlRequest
    }
    
}
