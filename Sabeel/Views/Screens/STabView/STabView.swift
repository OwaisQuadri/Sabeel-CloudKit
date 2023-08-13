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
        TabView(selection: $vm.tab) {
            
            SFeedView()
                .tabItem { Label("Community", systemImage: "person.3.fill") } .tag(Tab.feedView)
            
            SMapView()
                .tabItem { Label("Map", systemImage: "map") } .tag(Tab.mapView)
            
            
            NavigationView {
                SProfileView()
                    .toolbar(content: {
                        Button { vm.isShowingOnboarding = true } label: {
                            Image(systemName: "info.circle")
                                .imageScale(.large)
                        }
                        .padding()
                    })
            }
            .tabItem { Label("Profile", systemImage: "person") } .tag(Tab.profileView)
            
        }
        .onAppear{ vm.startUpChecks() }
        .accentColor(.brandPrimary)
        .sheet(isPresented: $vm.isShowingOnboarding ) {
            OnboardingView(isShowingOnboarding: $vm.isShowingOnboarding)
                .onDisappear { vm.tab = Tab.profileView }
        }
        
    }
}

struct STabView_Previews: PreviewProvider {
    static var previews: some View {
        STabView()
    }
}
