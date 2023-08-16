//
//  Date+Ext.swift
//  Sabeel
//
//  Created by Owais on 2023-08-14.
//

import Foundation

extension Date {
    static func from(string: String) -> Date? {
        let string = string.capitalized
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mma"
        
        guard let date = dateFormatter.date(from: string) else {
            return nil
        }
        return date
    }
    var timeString: String {
        self.formatted(date: .omitted, time: .shortened)
    }
}
