//
//  Device.swift
//  EarEffect
//
//  Created by Muhammad Zafar on 2022-07-23.
//

import Foundation
import SwiftUI

struct Device: Codable {
    let name: String
    let model: String
    let image: String
    let type: DeviceType
}

enum DeviceType:String, Codable {
    
    case headPhone = "Headphones"
    case earBuds = "EarBuds"
    case wirelessSpeakers  = "Wireless Speakers"
    case unknown = "Unknown"
    
    
    func toString() -> String {
        switch self {
        case .headPhone:
            return "Headphones"
        case .earBuds:
            return "EarBuds"
        case .wirelessSpeakers:
            return "Wireless Speakers"
        case .unknown:
            return "Unknown"
        }
    
    }
}
extension DeviceType {
    public init(from decoder: Decoder) throws {
        self = try DeviceType(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .unknown
    }
}
