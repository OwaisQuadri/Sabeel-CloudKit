//
//  STabView.swift
//  Sabeel
//
//  Created by Owais on 2023-08-06.
//

import SwiftUI
enum Tab: String, CaseIterable, Identifiable {
    case feedView, mapView, profileView
    
    var id: Self { self }
}
struct STabView: View {
    @ObservedObject private var vm = STabViewModel()
    @State private var tab = Tab.mapView
    var body: some View {
        TabView(selection: $tab) {
            SFeedView()
                .tabItem {
                    Label("Feed", systemImage: "tray.fill") // TODO: change to "friends" or "community"
                }
                .tag(Tab.feedView)
            SMapView()
                .tabItem {
                    Label("Map", systemImage: "map")// TODO: Make default
                }
                .tag(Tab.mapView)
            NavigationView {
                SProfileView()
                    .toolbar(content: {
                        Button {
                            vm.isShowingOnboarding = true
                        } label: {
                            Image(systemName: "info.circle")
                                .imageScale(.large)
                        }
                        .padding()
                    })
            }
            .tabItem {
                Label("mySabeel", systemImage: "person.crop.circle")
            }
            .tag(Tab.profileView)
        }
        .onAppear{
            vm.startUpChecks()
        }
        .accentColor(.brandPrimary)
        .sheet(isPresented: $vm.isShowingOnboarding ) {
            OnboardingView(isShowingOnboarding: $vm.isShowingOnboarding)
                .onDisappear {
                    tab = Tab.profileView
                }
        }
    }
}

struct STabView_Previews: PreviewProvider {
    static var previews: some View {
        STabView()
    }
}
