//
//  MasjidDetail.swift
//  Sabeel
//
//  Created by Owais on 2023-08-06.
//

import SwiftUI
import CloudKit

struct MasjidDetail: View {
    @EnvironmentObject var locationManager: LocationManager
    
    @StateObject private var vm = MasjidDetailViewModel()
    
    var body: some View {
            ZStack {
                if let selectedMasjid = locationManager.selectedMasjid, vm.isShowingThisView {
                    if !vm.showChangeTimingsView {
                        VStack(alignment: .center) {
                            HStack (alignment: .center ) {
                                Spacer()
                                MasjidHeadline(selectedMasjid: locationManager.selectedMasjid)
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
                                        print( "send to email")
                                    }
                                    .disabled(selectedMasjid.email == nil)
                                    Button("Call") {
                                        print( "send to call")
                                    }
                                    .disabled(selectedMasjid.phoneNumber == nil)
                                    Button("Visit Website") {
                                        print( "send to website" )
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
                                    vm.dismiss(with: locationManager)
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
                                } label: {
                                    Label("5 mins", systemImage: "car")
                                }
                                .buttonStyle(.borderedProminent)
                                .accentColor(.brandPrimary)
                                
                            }
                            .padding(.horizontal)
                            // TODO: View timings button, contact (alert sheet with website, email and/or phone)
                            
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
                        .frame(height: CGFloat.relativeToScreen(.height, ratio: 0.35))
                        .background(Color.brandBackground)
                        .cornerRadius(20).shadow(radius: 20)
                        .padding()
                        
                    }
                    else {
                        MasjidChangeRequestView(showChangeTimingsView: $vm.showChangeTimingsView)
                    }
                }
            }.onAppear {
                vm.fetchPrayerTimes(for: locationManager)
            }
        
    }
}

struct MasjidDetail_Previews: PreviewProvider {
    static var previews: some View {
        MasjidDetail()
            .environmentObject(LocationManager([Masjid(record: MockData.masjid)], selected: Masjid(record: MockData.masjid)))
    }
}
