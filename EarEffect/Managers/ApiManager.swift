//
//  ApiManager.swift
//  EarEffect
//
//  Created by Muhammad Zafar on 2022-08-21.
//

import Foundation
protocol ObjectSavable {
    func setObject<Object>(_ object: Object, forKey: String) throws where Object: Encodable
    func getObject<Object>(forKey: String, castTo type: Object.Type) throws -> Object where Object: Decodable
}

class ApiManager {
    static let shared = ApiManager()
    private init() {}

    struct Constant {
        static let baseURL = "https://ear-effect-api.herokuapp.com/"
        static let authenticate = "authenticate"
        static let registerDevice = "device_register"
        static let login = "sign_in"
        static let unRegisterDevice = "registered_devices/"
    }

    private enum HTTPMethod: String {
        case GET
        case POST
        case PUT
    }

    private func getToken(completion: @escaping ((String) -> Void)) {
        if let token = UserDefaults.standard.string(forKey: UserDefaults.authToken) {
            completion(token)
        } else {
            fetchToken(url: "\(Constant.baseURL)\(Constant.authenticate)") { token in
                if let token = token {
                    UserDefaults.standard.set(token, forKey: UserDefaults.authToken)
                    UserDefaults.standard.synchronize()
                    completion(token)
                } else {
                    completion("")
                }
            }
        }
    }

    func fetchToken(url: String, completion: @escaping ((String?) -> Void)) {
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data else {
                print("fail to get base64")
                completion(nil)
                return
            }
            do {
                let json = try JSONDecoder().decode(AccessToken.self, from: data)
                completion(json.auth_token)
            } catch {
                print(error.localizedDescription)
                completion(nil)
            }
        }
        task.resume()
    }

    func registerDevice(params: [String: String], completion: @escaping ((RegisterDevice?, Error?) -> Void)) {
        let url = URL(string: "\(Constant.baseURL)\(Constant.registerDevice)")
        let jsonData = try? JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
        createRequest(with: url, type: .POST, param: jsonData) { request in

            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data else {
                    print("fail to get data")
                    completion(nil, nil)
                    return
                }

                do {
                    let json = try JSONSerialization.jsonObject(with: data)
                    print(json)
                    let device = try JSONDecoder().decode(RegisterDevice.self, from: data)
                    completion(device, nil)
                } catch {
                    print(error.localizedDescription)
                    completion(nil, error)
                }
            }
            task.resume()
        }
    }

    func login(params: [String: Any], completion: @escaping (() -> Void)) {
        let url = URL(string: "\(Constant.baseURL)\(Constant.login)")
        let jsonData = try? JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
        createRequest(with: url, type: .POST, param: jsonData) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data else {
                    print("fail to get base64")
                    completion()
                    return
                }

                do {
                    let json = try JSONSerialization.jsonObject(with: data)
                    print(json)
//                    let json = try JSONDecoder().decode(RegisterDevice.self, from: data)
                    completion()
                } catch {
                    print(error.localizedDescription)
                    completion()
                }
            }
            task.resume()
        }
    }

    private func createRequest(with url: URL?, type: HTTPMethod, param: Data?, completion: @escaping (URLRequest) -> Void) {
        guard let url = url else {
            return
        }

        getToken { token in
            var request = URLRequest(url: url)
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            request.httpMethod = type.rawValue
            request.timeoutInterval = 30
            if let param = param {
                request.httpBody = param
            }
            completion(request)
        }
    }
}

extension UserDefaults: ObjectSavable {
    static let authToken = "auth_token"
    static let registeredDevice = "registeredDevice"

    func setObject<Object>(_ object: Object, forKey: String) throws where Object: Encodable {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(object)
            set(data, forKey: forKey)
        } catch {
            throw ObjectSavableError.unableToEncode
        }
    }

    func getObject<Object>(forKey: String, castTo type: Object.Type) throws -> Object where Object: Decodable {
        guard let data = data(forKey: forKey) else { throw ObjectSavableError.noValue }
        let decoder = JSONDecoder()
        do {
            let object = try decoder.decode(type, from: data)
            return object
        } catch {
            throw ObjectSavableError.unableToDecode
        }
    }
}

enum ObjectSavableError: String, LocalizedError {
    case unableToEncode = "Unable to encode object into data"
    case noValue = "No data object found for the given key"
    case unableToDecode = "Unable to decode object into given type"

    var errorDescription: String? {
        rawValue
    }
}
