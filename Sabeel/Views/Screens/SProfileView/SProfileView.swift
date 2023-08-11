//
//  SProfileView.swift
//  Sabeel
//
//  Created by Owais on 2023-08-06.
//

import SwiftUI

struct SProfileView: View {
    
    @StateObject var vm = SProfileViewModel()
    
    var body: some View {
        List {
            Section {
                PersonalInfoView()
                PrayerStatsView()
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





