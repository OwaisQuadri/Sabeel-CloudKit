//
//  PrayerCell.swift
//  Sabeel
//
//  Created by Owais on 2023-08-12.
//

import SwiftUI

struct PrayerCell: View {
    var title: String
    var time: String
    var body: some View {
        HStack {
            Text(title).foregroundStyle(Color.brandSecondary).font(.subheadline)
            Spacer()
            Text(time).bold().foregroundStyle(Color.brandPrimary)
        }
    }
}

struct PrayerCell_Previews: PreviewProvider {
    static var previews: some View {
        PrayerCell(title: "Fajr", time: "5:30am")
    }
}
