//
//  MasjidDetail.swift
//  Sabeel
//
//  Created by Owais on 2023-08-06.
//

import SwiftUI
import CloudKit
//import MapKit

struct MasjidDetailView: View {
    @EnvironmentObject var masjidManager: MasjidManager
    
    @StateObject var vm: MasjidDetailViewModel
//    @State var lookAroundScene: MKLookAroundScene?
    var body: some View {
        if let selectedMasjid = masjidManager.selectedMasjid, vm.isShowingThisView {
            if !vm.showChangeTimingsView && selectedMasjid.isConfirmed {
                ZStack{
                    VStack {
                        HStack {
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
                        HStack {
                            Button {
                                // send to google maps
                                vm.getDirectionsToLocation(with: masjidManager)
                            } label: {
                                HStack{
                                    Image(systemName: "arrowshape.turn.up.right.fill")
                                    Spacer()
                                    if let secondsToMasjid = masjidManager.secondsToMasjid?.convertSecondsToString() {
                                        Text(secondsToMasjid)
                                    } else {
                                        Text(vm.timeToMasjidString)
                                    }
                                    Spacer()
                                }
                                .font(.title3)
                            }
                            .buttonStyle(.borderedProminent)
                            .accentColor(.brandPrimary)
// add in Xcode 15
//                            Button {
//                                // send to scene
//                                lookAroundScene = nil
//                                guard let locationCoord = masjidManager.selectedMasjid?.location.coordinate else {
//                                    return
//                                }
//                                Task {
//                                    let request = MKLookAroundSceneRequest(coordinate: locationCoord)
//                                    lookAroundScene = try? await request.scene
//                                }
//                            } label: {
//                                Text("Look around")
//                                    .font(.title3)
//                            }
//                            .buttonStyle(.borderedProminent)
//                            .accentColor(.brandPrimary)
                        }
                        .padding(.horizontal)
                        List {
                            if let prayerTimes = vm.prayerTimes {
                                Section {
                                    PrayerCell(title: "Fajr"    , timeToLeave: vm.departAtTime(for: .fajr, with: masjidManager) , isLate: vm.isLate(for: .fajr), time: prayerTimes.fajr)
                                    PrayerCell(title: "Dhuhr"   , timeToLeave: vm.departAtTime(for: .dhuhr, with: masjidManager) , isLate: vm.isLate(for: .dhuhr), time: prayerTimes.dhuhr)
                                    PrayerCell(title: "Asr"     , timeToLeave: vm.departAtTime(for: .asr, with: masjidManager) , isLate: vm.isLate(for: .asr), time: prayerTimes.asr)
                                    PrayerCell(title: "Maghrib" , timeToLeave: vm.departAtTime(for: .maghrib, with: masjidManager) , isLate: vm.isLate(for: .maghrib), time: prayerTimes.maghrib)
                                    PrayerCell(title: "Isha"    , timeToLeave: vm.departAtTime(for: .isha, with: masjidManager) , isLate: vm.isLate(for: .isha), time: prayerTimes.isha)
                                } header: {
                                    Text(Constants.prayerTimesTitle).foregroundColor(.brandSecondary).bold().font(.headline)
                                }
                                if prayerTimes.juma.count > 0 {
                                    Section {
                                        ForEach( 0..<prayerTimes.juma.count, id: \.self) { index in
                                            PrayerCell(title: "Juma \(index+1)", timeToLeave: vm.departAtTime(for: .juma(index), with: masjidManager) , isLate: vm.isLate(for: .juma(index)), time: prayerTimes.juma[index])
                                        }
                                    } header: {
                                        Text(Constants.jumaTimesTitle).foregroundColor(.brandSecondary).bold().font(.headline)
                                    }
                                }
                            }
                        }
                    }
                    
                    if vm.isLoading { LoadingView() }
                }
                .task { vm.onAppear(with: masjidManager) }
                .frame(height: CGFloat.relativeToScreen(.height, ratio: 0.5))
                .background(Color.brandBackground)
                .cornerRadius(20).shadow(radius: 15)
                .padding()
                .alert(item: $vm.alertItem) { $0.alert }
            }
            else {
                MasjidChangeRequestView(vm: MasjidChangeRequestVM(showChangeTimingsView: $vm.showChangeTimingsView, $vm.alertItem))
                    .onDisappear {
                        vm.updateInfo(with: masjidManager)
                    }
            }
        }
    }
}

struct MasjidDetail_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Spacer()
            MasjidDetailView( vm: MasjidDetailViewModel(.constant(nil)))
                .environmentObject(MasjidManager([Masjid(record: MockData.masjid)], selected: Masjid(record: MockData.masjid)))
        }
    }
}
