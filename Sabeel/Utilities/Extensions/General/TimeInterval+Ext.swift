//
//  TimeInterval+Ext.swift
//  Sabeel
//
//  Created by Owais on 2023-08-14.
//

import Foundation

enum TimeUnits {
    case seconds
    case minutes
    case hours
    case days
    case weeks
    case months
    case years
}

extension TimeInterval {
    func convertSecondsToString() -> String? {
        var output: String = ""
        var x = self
        let hours = x.convert(to: .hours)
        if hours >= 1 {
            output += "\(NumberFormatter.integer(hours) ?? "0")h "
            x = x - hours.rounded(.down).convert(from: .hours, to: .seconds)
        }
        let minutes = x.convert(to: .minutes)
        if minutes >= 1 {
            output += "\(NumberFormatter.integer(minutes) ?? "0")m"
        }
        return output == "" ? nil : output
    }
    func convert(from fromUnit: TimeUnits = .seconds, to toUnit: TimeUnits) -> TimeInterval {
        var x = self
        switch fromUnit {
            case .seconds:
                break
            case .minutes:
                x *= (60)
            case .hours:
                x *= (60*60)
            case .days:
                x *= (60*60*24)
            case .weeks:
                x *= (60*60*24*7)
            case .months:
                x *= (60*60*24*30)
            case .years:
                x *= (60*60*24*365)
        }
        switch toUnit {
            case .seconds:
                break
            case .minutes:
                x /= (60)
            case .hours:
                x /= (60*60)
            case .days:
                x /= (60*60*24)
            case .weeks:
                x /= (60*60*24*7)
            case .months:
                x /= (60*60*24*30)
            case .years:
                x /= (60*60*24*365)
        }
        return x
    }
}
