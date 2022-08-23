//
//  Utilities.swift
//  EarEffect
//
//  Created by Muhammad Zafar on 2022-08-05.
//

import Foundation

struct TimeUtility {
    static func secondsToHoursMinutesSeconds(_ miliseconds: Int) -> String {
        let date = Date(timeIntervalSince1970: Double(miliseconds) / 1000)
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "UTC")
        let hour = miliseconds.msToSeconds.hour
        if hour > 0 {
            formatter.dateFormat = "HH:mm:ss"
        } else {
            formatter.dateFormat = "mm:ss"
        }

        return formatter.string(from: date)
    }

    static func stringFromTimeInterval(interval: TimeInterval) -> String {
        return interval.stringFromTimeInterval()
    }
}

extension TimeInterval {
    func stringFromTimeInterval() -> String {
        let time = NSInteger(self)
        let ms = Int(truncatingRemainder(dividingBy: 1) * 1000)
        let seconds = time % 60
        let minutes = (time / 60) % 60
        let hours = (time / 3600)

        if hour > 0 {
            return String(format: "%0.2d:%0.2d:%0.2d", hours, minutes, seconds)
        } else {
            return String(format: "%0.2d:%0.2d", minutes, seconds)
        }
    }
}


extension UserDefaults {
    static let privacyPolicy = "privacyPolicy"
}
