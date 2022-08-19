//
//  SportifyAuthManager.swift
//  EarEffect
//
//  Created by Muhammad Zafar on 2022-07-17.
//

import Foundation
import MapKit

final class SpotifyAuthManager {
    static let shared = SpotifyAuthManager()
    private init () {}
    var refreshingToken = false
    var handler: ((Bool) -> Void)?
    public var signInURL : URL? {
        let encodedUri = SpotifyConstants.redirectURI.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        let base = "https://accounts.spotify.com/authorize"
        let string = "\(base)?nolinks=true&nosignup=true&response_type=code&scope=\(SpotifyConstants.scope)&utm_source=spotify-sdk&utm_medium=ios-sdk&utm_campaign=ios-sdk&redirect_uri=\(encodedUri)&show_dialog=true&client_id=\(SpotifyConstants.clientID)"
        return URL(string: string)
    }
    
    var isSignedIn: Bool {
        return accessToken != nil
    }
    
    private var accessToken: String? {
        return UserDefaults.standard.string(forKey: UserDefaults.accessToken)
    }
    
    private var refreshToken: String?{
        return UserDefaults.standard.string(forKey: UserDefaults.refreshToken)
    }
    
    private var tokenExpirationDate: Date? {
        if let date = UserDefaults.standard.object(forKey: UserDefaults.tokenExpiryDate) {
            return date as! Date
        }
        return nil
    }
    
    private var shouldRefreshToken: Bool {
        guard let tokenExpirationDate = tokenExpirationDate else {
            return false
        }

        let currentDate = Date()
        let fiveMin : TimeInterval = 300
        return currentDate.addingTimeInterval(fiveMin) >= tokenExpirationDate
    }
    // MARK: Login
    public func login(completion: @escaping (Bool) -> Void){
        guard let url = signInURL else {
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
        self.handler = completion
    }
    
    func handleAuthCallBack(url: URL) {
        print(url)
        guard let code = URLComponents(string: url.absoluteString)?.queryItems?.first(where: {$0.name == "code"})?.value else {
            self.handler?(false)
            return
        }
        exchangeCodeForToken(code: code) { [weak self] success in
            self?.handler?(success)
        }
    }
    
    public func exchangeCodeForToken(code: String, completion: @escaping ((Bool) -> Void)){
        guard let url = URL(string: SpotifyConstants.tokenApiURL) else {
            return
        }
        var component = URLComponents()
        component.queryItems = [
            URLQueryItem(name: "grant_type", value: "authorization_code"),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "redirect_uri", value: SpotifyConstants.redirectURI)
        ]
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content_Type")
        request.httpBody = component.query?.data(using: .utf8)
        let basicToken = SpotifyConstants.clientID+":"+SpotifyConstants.clientSecret
        let data =  basicToken.data(using: .utf8)
        guard let base64String =    data?.base64EncodedString() else {
            print("fail to get base64")
            completion(false)
            return
        }
        
        request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            guard let data = data,
            error == nil else {
                completion(false)
                return
            }

            do{
                let json = try JSONDecoder().decode(SpotifyAuthResponse.self, from: data)
                self?.cacheToke(result: json)
                completion(true)
            } catch {
                print(error.localizedDescription)
                completion(false)
            }
        }
        task.resume()
    }
    
    private var onRefreshBlock = [((String) -> Void)]()
    
    func withValidToken(completion: @escaping (String) -> Void){
        guard !refreshingToken else {
            //Append completeion
            onRefreshBlock.append(completion)
            return
        }
        if shouldRefreshToken {
            refreshIfNeeded { [weak self] success in
                if let token = self?.accessToken, success {
                    completion(token)
                }
                
            }
        } else if let token = accessToken {
            completion(token)
        }
    }
    
    func refreshIfNeeded(completion: ((Bool) -> Void)?) {
        guard !refreshingToken else{
            return
        }
        guard shouldRefreshToken else {
            completion?(true)
            return
        }
        guard let refreshToken = refreshToken else {
            return
        }

        guard let url = URL(string: SpotifyConstants.tokenApiURL) else {
            return
        }
        refreshingToken = true
        var component = URLComponents()
        component.queryItems = [
            URLQueryItem(name: "grant_type", value: "refresh_token"),
            URLQueryItem(name: "refresh_token", value: refreshToken),
        ]
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content_Type")
        request.httpBody = component.query?.data(using: .utf8)
        let basicToken = SpotifyConstants.clientID+":"+SpotifyConstants.clientSecret
        let data =  basicToken.data(using: .utf8)
        guard let base64String =    data?.base64EncodedString() else {
            print("fail to get base64")
            completion?(false)
            return
        }
        
        request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            self?.refreshingToken = false
            guard let data = data,
            error == nil else {
                completion?(false)
                return
            }

            do{
                let json = try JSONDecoder().decode(SpotifyAuthResponse.self, from: data)
                self?.onRefreshBlock.forEach { $0(json.access_token) }
                self?.onRefreshBlock.removeAll()
                self?.cacheToke(result: json)
                completion?(true)
            } catch {
                print(error.localizedDescription)
                completion?(false)
            }
        }
        task.resume()
    }
    
    func cacheToke(result: SpotifyAuthResponse){
        UserDefaults.standard.set(result.access_token, forKey: UserDefaults.accessToken)
        if let refreshToken = result.refresh_token {
            UserDefaults.standard.set(refreshToken, forKey: UserDefaults.refreshToken)
        }
        UserDefaults.standard.set(Date().addingTimeInterval(TimeInterval(result.expires_in)), forKey: UserDefaults.tokenExpiryDate)
        UserDefaults.standard.synchronize()
        
    }
    
    func clearCache(){
        UserDefaults.standard.removeObject(forKey: UserDefaults.accessToken)
        UserDefaults.standard.removeObject(forKey: UserDefaults.refreshToken)
        UserDefaults.standard.removeObject(forKey: UserDefaults.tokenExpiryDate)
        UserDefaults.standard.synchronize()
        
    }
    
    func saveSpotifyUser(user:SpotifyUser){
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(user) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: UserDefaults.spotifyUse)
            defaults.synchronize()
        } else {
            print("error in saving")
        }
    }
    
    func getSpotifyUser() -> SpotifyUser? {
        if let savedPerson = UserDefaults.standard.object(forKey: UserDefaults.spotifyUse) as? Data {
            let decoder = JSONDecoder()
            if let loadedPerson = try? decoder.decode(SpotifyUser.self, from: savedPerson) {
                return loadedPerson
            }
        }
        return nil
    }
}
