//
//  SProfileView.swift
//  Sabeel
//
//  Created by Owais on 2023-08-06.
//

import SwiftUI


struct PrayerStats {
    var fajrAttended: Double = 3000
    var fajrMissed: Double = 500
    var dhuhrAttended: Double = 7000
    var dhuhrMissed: Double = 100
    var asrAttended: Double = 4000
    var asrMissed: Double = 300
    var maghribAttended: Double = 5000
    var maghribMissed: Double = 200
    var ishaAttended: Double = 6000
    var ishaMissed: Double = 100
}

struct SProfileView: View {
    
    @State var prayerStats: PrayerStats = PrayerStats()
    
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





