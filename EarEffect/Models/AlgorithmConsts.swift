//
//  AlgorithmConsts.swift
//  EarEffect
//
//  Created by Muhammad Zafar on 2022-08-05.
//

import Foundation

struct AlgorithmConstants {
    static func saveSelectedConfigurations(config: String){
        UserDefaults.standard.set(config, forKey: UserDefaults.selectedConfig)
        UserDefaults.standard.synchronize()
    }
    
    static func saveKnoValue(algo: String, value: Float){
        if algo == Algorithm.LOW.rawValue {
            UserDefaults.standard.set(value, forKey: UserDefaults.low)
        } else if (algo == Algorithm.MID.rawValue) {
            UserDefaults.standard.set(value, forKey: UserDefaults.mid)
        }
        else if (algo == Algorithm.HIGH.rawValue) {
            UserDefaults.standard.set(value, forKey: UserDefaults.high)
        }
        UserDefaults.standard.synchronize()
    }
    
    static func saveAttitudeValue(value: Float){
        UserDefaults.standard.set(value, forKey: UserDefaults.attitude)
        UserDefaults.standard.synchronize()
    }
    
    static func saveDryWetValue(value: Float){
        UserDefaults.standard.set(value, forKey: UserDefaults.dryWet)
        UserDefaults.standard.synchronize()
    }
}

extension UserDefaults{
    static let low = "low"
    static let high = "high"
    static let mid = "mid"
    static let dryWet = "dryWet"
    static let attitude = "attitude"
    static let selectedConfig = "selectedConfig"
    static let dryWetFirst = "dryWetFirst"
}
