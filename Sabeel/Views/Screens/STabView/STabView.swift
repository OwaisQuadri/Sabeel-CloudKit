//
//  STabView.swift
//  Sabeel
//
//  Created by Owais on 2023-08-06.
//

import SwiftUI

struct STabView: View {
    @ObservedObject private var vm = STabViewModel()
    
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
        .onAppear{
            vm.startUpChecks()
        }
        .accentColor(.brandPrimary)
        .sheet(isPresented: $vm.isShowingOnboarding ) {
            OnboardingView(isShowingOnboarding: $vm.isShowingOnboarding)
        }
    }
}

struct STabView_Previews: PreviewProvider {
    static var previews: some View {
        STabView()
    }
}
