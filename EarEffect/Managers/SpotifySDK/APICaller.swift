//
//  APICaller.swift
//  EarEffect
//
//  Created by Muhammad Zafar on 2022-07-18.
//

import Foundation

final class APICaller {
    static let shared = APICaller()
    private init() {}

    struct Constant {
        static let baseURL = "https://api.spotify.com/v1"
    }

    enum HTTPMethod: String {
        case GET
        case POST
    }

    enum APIError: Error {
        case failTogetData
    }

    public func getAlbums(completion: @escaping (Result<[SpotifyAlbum]?, Error>) -> Void) {
        createRequest(with: URL(string: Constant.baseURL + "/me/albums"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failTogetData))
                    return
                }
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    print(json)
                    let result = try JSONDecoder().decode(Album.self, from: data)
                    completion(.success(result.items))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }

    // MARK: - Get Albums Songs
    public func getAlbumsTracks(albumID:String, completion: @escaping (Result<[SpotifyAudioTrack]?, Error>) -> Void) {
        createRequest(with: URL(string: Constant.baseURL + "/albums/\(albumID)/tracks?limit=50"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failTogetData))
                    return
                }
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    print(json)
                    let result = try JSONDecoder().decode(TrackResponse.self, from: data)
                    completion(.success(result.items))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    // MARK: - Get Artists

    func getArtists(completion: @escaping (Result<[SpotifyArtist]?, Error>) -> Void) {
        createRequest(with: URL(string: Constant.baseURL + "/me/following?type=artist"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failTogetData))
                    return
                }
                do {
                    let json = try JSONSerialization.jsonObject(with: data)
                    print(json)
                    let result = try JSONDecoder().decode(Artists.self, from: data)
                    completion(.success(result.artists.items))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }

    // MARK: - Get Artists Top Songs

    func getArtistTopSongs(artistID: String, completion: @escaping (Result<[Track]?, Error>) -> Void) {
        if let user = SpotifyAuthManager.shared.getSpotifyUser() {
            createRequest(with: URL(string: Constant.baseURL + "/artists/\(artistID)/top-tracks?country=\(user.country ?? "US")"), type: .GET) { request in
                let task = URLSession.shared.dataTask(with: request) { data, _, error in
                    guard let data = data, error == nil else {
                        completion(.failure(APIError.failTogetData))
                        return
                    }
                    do {
                        let result = try JSONDecoder().decode(SpotifyArtistTopTracks.self, from: data)
                        completion(.success(result.tracks))
                    } catch {
                        completion(.failure(error))
                    }
                }
                task.resume()
            }
        }
    }

    // MARK: - Get AlbumDetail

    func getAlbumDetails(for album: SpotifyAlbum, completion: @escaping (Result<SpotifyAlbumDetailsResponse, Error>) -> Void) {
        createRequest(with: URL(string: Constant.baseURL + "/albums/" + album.id), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failTogetData))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(SpotifyAlbumDetailsResponse.self, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }

    // MARK: - Get PlayListDetail

    func getPlayListDetails(for playListID: String, completion: @escaping (Result<SpotifyPlayListDetailsResponse?, Error>) -> Void) {
        createRequest(with: URL(string: Constant.baseURL + "/playlists/" + playListID), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failTogetData))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(SpotifyPlayListDetailsResponse.self, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }

    // MARK: - Get CurrentUserPlayLists

    func getUserPlayList(completion: @escaping (Result<[SpotifyPlayList]?, Error>) -> Void) {
        createRequest(with: URL(string: Constant.baseURL + "/me/playlists/?limit=50"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failTogetData))
                    return
                }
                do {
//                    let json = try JSONSerialization.jsonObject(with: data)
                    let result = try JSONDecoder().decode(SpotifyUserPlayListResponse.self, from: data)
//                    print(json)
                    completion(.success(result.items))

//                    do {
//                        let decoder = JSONDecoder()
//                        let messages = try decoder.decode(SpotifyUserPlayListResponse.self, from: data)
//                        print(messages as Any)
//                    } catch DecodingError.dataCorrupted(let context) {
//                        print(context)
//                    } catch DecodingError.keyNotFound(let key, let context) {
//                        print("Key '\(key)' not found:", context.debugDescription)
//                        print("codingPath:", context.codingPath)
//                    } catch DecodingError.valueNotFound(let value, let context) {
//                        print("Value '\(value)' not found:", context.debugDescription)
//                        print("codingPath:", context.codingPath)
//                    } catch DecodingError.typeMismatch(let type, let context) {
//                        print("Type '\(type)' mismatch:", context.debugDescription)
//                        print("codingPath:", context.codingPath)
//                    } catch {
//                        print("error: ", error)
//                    }
                } catch {
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }

    // MARK: UserInfo

    func getCurrentUser(completion: @escaping (Result<SpotifyUser?, Error>) -> Void) {
        createRequest(with: URL(string: Constant.baseURL + "/me"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failTogetData))
                    return
                }
                do {
//                    let json = try JSONSerialization.jsonObject(with: data)
                    let result = try JSONDecoder().decode(SpotifyUser.self, from: data)
//                    print(json)
                    completion(.success(result))
                } catch {
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }

    private func createRequest(with url: URL?, type: HTTPMethod, completion: @escaping (URLRequest) -> Void) {
        guard let url = url else {
            return
        }

        SpotifyAuthManager.shared.withValidToken { token in
            var request = URLRequest(url: url)
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.httpMethod = type.rawValue
            request.timeoutInterval = 30
            completion(request)
        }
    }
}
