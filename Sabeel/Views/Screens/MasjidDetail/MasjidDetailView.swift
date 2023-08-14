//
//  MasjidDetail.swift
//  Sabeel
//
//  Created by Owais on 2023-08-06.
//

import SwiftUI
import CloudKit

struct MasjidDetailView: View {
    @EnvironmentObject var masjidManager: MasjidManager
    
    @StateObject var vm: MasjidDetailViewModel
    
    @Binding var secondsToMasjid: TimeInterval?
    
    var departAt: Date? {
        guard let secondsToMasjid = secondsToMasjid, let nextPrayer = vm.nextPrayer else {
            return nil
        }
        return nextPrayer.addingTimeInterval(secondsToMasjid * -1)
    }
    
    var departAtString: String? {
        guard let departAt = departAt  else {
            return nil
        }
        return departAt.formatted(date: .omitted, time: .shortened)
    }
    
    var body: some View {
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
                            if let departAtString = departAtString {
                                Text("Depart at ") +
                                Text(departAtString)
                                    .bold().foregroundColor((Date.now.distance(to: departAt! ) > 0) ?  .brandPrimary : .brandRed )
                            }
                            else {
                                Text("Find it on the map")
                                Image(systemName: "arrow.right")
                                    .foregroundColor(.brandPrimary)
                            }
                            Spacer()
                            Button {
                                // send to google maps
                                vm.getDirectionsToLocation(with: masjidManager)
                            } label: {
                                HStack{
                                    Image(systemName: "figure.run")
                                    if let secondsToMasjid = secondsToMasjid?.convertSecondsToString() {
                                        Text(secondsToMasjid)
                                    } else {
                                        Text(vm.timeToMasjidString)
                                    }
                                }
                            }
                            .buttonStyle(.borderedProminent)
                            .accentColor(.brandPrimary)
                            
                        }
                        .padding(.horizontal)
                        
                        List {
                            if let prayerTimes = vm.prayerTimes {
                                Section {
                                    PrayerCell(title: "Fajr"    , time: prayerTimes.fajr)
                                    PrayerCell(title: "Dhuhr"   , time: prayerTimes.dhuhr)
                                    PrayerCell(title: "Asr"     , time: prayerTimes.asr)
                                    PrayerCell(title: "Maghrib" , time: prayerTimes.maghrib)
                                    PrayerCell(title: "Isha"    , time: prayerTimes.isha)
                                } header: {
                                    Text(Constants.prayerTimesTitle).foregroundColor(.brandSecondary).bold().font(.headline)
                                }
                                Section {
                                    ForEach( 0..<prayerTimes.juma.count, id: \.self) { index in
                                        PrayerCell(title: "Juma \(index+1)", time: prayerTimes.juma[index])
                                    }
                                } header: {
                                    Text(Constants.jumaTimesTitle).foregroundColor(.brandSecondary).bold().font(.headline)
                                }
                            }
                        }
                    }
                    
                    if vm.isLoading { LoadingView() }
                }
                .onAppear { vm.onAppear(with: masjidManager) }
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
            MasjidDetailView( vm: MasjidDetailViewModel(.constant(nil)),secondsToMasjid: .constant(60.0))
                .environmentObject(MasjidManager([Masjid(record: MockData.masjid)], selected: Masjid(record: MockData.masjid)))
        }
    }
}