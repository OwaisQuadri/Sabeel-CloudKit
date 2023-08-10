//
//  SProfileView.swift
//  Sabeel
//
//  Created by Owais on 2023-08-06.
//

import SwiftUI

struct SProfileView: View {
    
    @State var prayerStats: PrayerStats = PrayerStats(record: MockData.prayerStats)
    
    var body: some View {
        List {
            Section {
                PersonalInfoView()
                PrayerStatsView(prayerStats: $prayerStats)
            }
            SSettingsView()
        }
        .navigationTitle("Profile")
    }
}

struct SProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SProfileView()
        }
    }
}





