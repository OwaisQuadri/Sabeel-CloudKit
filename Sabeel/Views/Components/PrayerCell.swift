//
//  PrayerCell.swift
//  Sabeel
//
//  Created by Owais on 2023-08-12.
//

import SwiftUI

struct PrayerCell: View {
    var title       : String
    var timeToLeave : Date?
    var isLate      : Bool?
    var systemName  : String {
        if let isLate {
            if isLate { return "hourglass.bottomhalf.filled" } else { return "hourglass" }
        } else {
            return "hourglass.tophalf.filled"
        }
    }
    var time        : String
    var color: Color {
        if let isLate {
            if isLate { return .brandRed } else { return .brandGreen }
        } else {
            return .brandSecondary
        }
    }
    var body: some View {
        ZStack {
            HStack {
                Text(title)
                    .foregroundStyle(Color.brandSecondary)
                    .font(.subheadline)
                Spacer()
                Text(time)
                    .bold()
                    .foregroundStyle(Color.brandPrimary)
                    .frame(width: 100)
            }
            if let timeToLeave {
                HStack {
                    Text(Image(systemName: systemName))
                        .frame(width: 20)
                    Text(timeToLeave.timeString)
                        .frame(width: 75)
                }
                .foregroundColor(color)
                
            }
        }
    }
}

struct PrayerCell_Previews: PreviewProvider {
    static var previews: some View {
        List {
            PrayerCell(title: "Maghrib", timeToLeave: .now ,  time: "5:30am")
            PrayerCell(title: "Fajr", timeToLeave: .from(string: "12:58pm") , isLate: true,  time: "12:30am")
            PrayerCell(title: "Maghrib", timeToLeave: .from(string: "1:11am") , isLate: false,  time: "5:30am")
            PrayerCell(title: "Maghrib", time: "5:30am")
        }
    }
}
