//
//  SSettingsView.swift
//  Sabeel
//
//  Created by Owais on 2023-08-06.
//

import SwiftUI

struct SSettingsView: View {
    
    let settingsSubviews: [SettingsSubview] = [SettingsSubview(name: "Notification Settings", view: AnyView(NotificationSettingsView()))]
    
    var body: some View {
        Section("Settings"){
            ForEach(settingsSubviews) {subview in
                HStack {
                    NavigationLink(destination: subview.view) {
                        Text(subview.name)
                            .lineLimit(1)
                    }
                }
            }
        }
        Section{
            Text("Log Out")
                .foregroundColor(.red)
        }
    }
}

struct SSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            SSettingsView()
        }
    }
}

struct SettingsSubview: Identifiable {
    let id = UUID()
    let name: String
    let view: AnyView
}
