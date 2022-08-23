//
//  ApisModels.swift
//  EarEffect
//
//  Created by Muhammad Zafar on 2022-08-21.
//

import Foundation
struct AccessToken: Codable {
    let auth_token: String
}

struct RegisterDevice: Codable {
    let id: Int
    let serialNumber, createdAt, updatedAt, name: String
    let deviceType, model: String
    let image: String
    var email: String?
    enum CodingKeys: String, CodingKey {
        case id
        case serialNumber = "serial_number"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case name
        case deviceType = "device_type"
        case model, image, email
    }
}
