//
//  STabView.swift
//  Sabeel
//
//  Created by Owais on 2023-08-06.
//

import SwiftUI

struct STabView: View {
    var body: some View {
        TabView {
            SFeedView()
                .tabItem {
                    Label("Feed", systemImage: "tray.fill")
                }
            SMapView()
                .tabItem {
                    Label("Map", systemImage: "map")
                }
            NavigationView {
                SProfileView()
            }
            .tabItem {
                Label("mySabeel", systemImage: "person.crop.circle")
            }
        }
        .accentColor(.brandPrimary)
        
    }
}

struct STabView_Previews: PreviewProvider {
    static var previews: some View {
        STabView()
    }
}
