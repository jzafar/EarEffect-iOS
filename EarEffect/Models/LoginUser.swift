//
//  User.swift
//  EarEffect
//
//  Created by Muhammad Zafar on 2022-08-08.
//

import Foundation

struct LoginUser: Codable {
    let name: String
    let email: String
    let id: String
    let type: LoginType
    
    
    func saveUserInfo(){
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(self) {
            UserDefaults.standard.set(encoded, forKey: UserDefaults.loginUser)
        }
       
    }
    
    static func getLoginUserInfo() -> LoginUser?{
        if let savedPerson =  UserDefaults.standard.object(forKey:  UserDefaults.loginUser) as? Data {
            let decoder = JSONDecoder()
            if let loadedPerson = try? decoder.decode(LoginUser.self, from: savedPerson) {
                print(loadedPerson.name)
                return loadedPerson
            }
        }
        return nil
    }
    
    static func deleteUserInfo(){
        UserDefaults.standard.set(nil, forKey: UserDefaults.loginUser)
    }
    
}
enum LoginType:String, Codable {
    
    case apple = "apple"
    case google = "google"
    case facebook  = "facebook"
    case unknown = "Unknown"
    
    func toString() -> String {
        switch self {
        case .apple:
            return "apple"
        case .google:
            return "google"
        case .facebook:
            return "facebook"
        case .unknown:
            return "Unknown"
        }
    
    }
}
extension LoginType {
    public init(from decoder: Decoder) throws {
        self = try LoginType(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .unknown
    }
}
extension UserDefaults {
    static let loginUser = "loginUser"
}
