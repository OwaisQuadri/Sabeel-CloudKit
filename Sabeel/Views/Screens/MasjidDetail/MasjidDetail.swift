//
//  MasjidDetail.swift
//  Sabeel
//
//  Created by Owais on 2023-08-06.
//

import SwiftUI
import CloudKit

struct MasjidDetail: View {
    @EnvironmentObject var masjidManager: MasjidManager
    
    @StateObject private var vm = MasjidDetailViewModel()
    // when you need an init for a vm, user observed object
    var body: some View {
        ZStack {
            if let selectedMasjid = masjidManager.selectedMasjid, vm.isShowingThisView {
                if !vm.showChangeTimingsView {
                    ZStack{
                        VStack(alignment: .center) {
                            HStack (alignment: .center ) {
                                Spacer()
                                MasjidHeadline(name: selectedMasjid.name, address: selectedMasjid.address)
                                Spacer()
                                Button{
                                    withAnimation(.easeInOut){
                                        vm.showContactInfo = true
                                    }
                                } label: {
                                    Image(systemName: "ellipsis")
                                        .foregroundColor(.brandSecondary)
                                }
                                .padding(.vertical)
                                .padding(.leading)
                                .confirmationDialog("Actions", isPresented: $vm.showContactInfo, titleVisibility: .visible) {
                                    Button("Send an Email") {
                                        vm.sendEmail(with: masjidManager)
                                    }
                                    .disabled(selectedMasjid.email == nil)
                                    Button("Call") {
                                        vm.callMasjid(with: masjidManager)
                                    }
                                    .disabled(selectedMasjid.phoneNumber == nil)
                                    Button("Visit Website") {
                                        vm.visitWebsite(with: masjidManager)
                                    }
                                    .disabled(selectedMasjid.website == nil)
                                    Button(role: .destructive) {
                                        withAnimation (.easeInOut) {
                                            vm.showChangeTimingsView = true
                                            vm.showContactInfo = false
                                        }
                                    } label: {
                                        Text("Suggest a change to Prayer Times")
                                    }
                                }
                                Button{
                                    vm.dismiss(with: masjidManager)
                                } label: {
                                    Image(systemName: "xmark")
                                        .foregroundColor(.brandSecondary)
                                }
                                .padding()
                            }
                            .padding(.horizontal)
                            .padding(.top)
                            HStack(alignment: .center) {
                                Spacer()
                                Text("Next Prayer is in ")
                                + Text("25 mins")
                                    .foregroundColor(.brandPrimary)
                                    .bold()
                                Spacer()
                                Button {
                                    // send to google maps
                                    vm.getDirectionsToLocation(with: masjidManager)
                                } label: {
                                    Label("5 mins", systemImage: "car")
                                }
                                .buttonStyle(.borderedProminent)
                                .accentColor(.brandPrimary)
                                
                            }
                            .padding(.horizontal)
                            
                            List {
                                if let prayerTimes = vm.prayerTimes {
                                    Section("Prayer Times") {
                                        Group {
                                            HStack{
                                                Text("Fajr")
                                                Spacer()
                                                Divider().padding(.horizontal)
                                                Text(prayerTimes.fajr)
                                            }
                                        }
                                        Group {
                                            HStack{
                                                Text("Dhuhr")
                                                Spacer()
                                                Divider().padding(.horizontal)
                                                Text(prayerTimes.dhuhr)
                                            }
                                        }
                                        HStack{
                                            Text("Asr")
                                            Spacer()
                                            Divider().padding(.horizontal)
                                            Text(prayerTimes.asr)
                                        }
                                        HStack{
                                            Text("Maghrib")
                                            Spacer()
                                            Divider().padding(.horizontal)
                                            Text(prayerTimes.maghrib)
                                        }
                                        HStack{
                                            Text("Isha")
                                            Spacer()
                                            Divider().padding(.horizontal)
                                            Text(prayerTimes.isha)
                                        }
                                    }
                                    
                                    Section("Juma"){
                                        ForEach( 0..<prayerTimes.juma.count, id: \.self) { index in
                                            
                                            HStack{
                                                Text("Juma \(index+1)")
                                                Spacer()
                                                Divider().padding(.horizontal)
                                                Text(prayerTimes.juma[index])
                                            }
                                        }
                                    }
                                    .listSectionSeparator(.visible)
                                }
                                
                            }
                            
                        }
                        if vm.isLoading { LoadingView() }
                    }
                    .frame(height: CGFloat.relativeToScreen(.height, ratio: 0.5))
                    .background(Color.brandBackground)
                    .cornerRadius(20).shadow(radius: 15)
                    .padding()
                    
                }
                else {
                    MasjidChangeRequestView(showChangeTimingsView: $vm.showChangeTimingsView)
                        .onDisappear { vm.updateInfo(with: masjidManager) }
                }
            }
        }
        .onAppear { vm.onAppear(with: masjidManager) }
        .alert(item: $vm.alertItem) { $0.alert }
    }
}

struct MasjidDetail_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Spacer()
            MasjidDetail()
                .environmentObject(MasjidManager([Masjid(record: MockData.masjid)], selected: Masjid(record: MockData.masjid)))
        }
    }
}
