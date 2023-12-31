//
//  STabView.swift
//  Sabeel
//
//  Created by Owais on 2023-08-06.
//

import SwiftUI

struct STabView: View {
    @EnvironmentObject var masjidManager: MasjidManager
    @ObservedObject private var vm = STabViewModel()
    private let mapViewModel = SMapViewModel()
    @ObservedObject var personalInfoVM = PersonalInfoViewModel()
    
    var body: some View {
        TabView(selection: $vm.tab) {
            
            SFeedView()
                .tabItem { Label("Community", systemImage: "person.3.fill") } .tag(Tab.feedView)
            
            SMapView(vm: mapViewModel)
                .tabItem {
                    Label("Map", systemImage: "map")
                        .onTapGesture {
                            mapViewModel.focusUser()
                        }
                } .tag(Tab.mapView)
            
            
            NavigationView {
                SProfileView(personalInfoVM: personalInfoVM)
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
        .task { await vm.startUpChecks() }
        .accentColor(.brandPrimary)
        .sheet(isPresented: $vm.isShowingOnboarding ) {
            OnboardingView(isShowingOnboarding: $vm.isShowingOnboarding)
                .onDisappear {
                    vm.tab = Tab.profileView
                    personalInfoVM.startUpChecks()
                }
        }
        
    }
}

struct STabView_Previews: PreviewProvider {
    static var previews: some View {
        STabView()
            .environmentObject(MasjidManager([Masjid(record: MockData.masjid)], selected: Masjid(record: MockData.masjid)))
    }
}
