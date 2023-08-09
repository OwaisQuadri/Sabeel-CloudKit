//
//  MasjidDetail.swift
//  Sabeel
//
//  Created by Owais on 2023-08-06.
//

import SwiftUI

struct MasjidDetail: View {
    @Binding var selectedMasjid: Masjid?
    @State private var showContactInfo: Bool = false
    @State private var showChangeTimingsView: Bool = false
    var body: some View {
        if selectedMasjid != nil {
            ZStack {
                if !showChangeTimingsView {
                    VStack(alignment: .center) {
                        HStack (alignment: .center ) {
                            MasjidHeadline(selectedMasjid: selectedMasjid)
                            Button{
                                withAnimation(.easeInOut){
                                    showContactInfo = true
                                }
                            } label: {
                                    Image(systemName: "ellipsis")
                                        .foregroundColor(.brandSecondary)
                                }
                                .padding(.vertical)
                                .confirmationDialog("Actions", isPresented: $showContactInfo, titleVisibility: .visible) {
                                    Button("Send an Email") {
                                        print( "send to email")
                                    }
                                    .disabled(selectedMasjid?.email == nil)
                                    Button("Call") {
                                        print( "send to call")
                                    }
                                    .disabled(selectedMasjid?.phoneNumber == nil)
                                    Button("Visit Website") {
                                        print( "send to website" )
                                    }
                                    .disabled(selectedMasjid?.website == nil)
                                    Button(role: .destructive) {
                                        withAnimation (.easeInOut) {
                                            self.showChangeTimingsView = true
                                            self.showContactInfo = false
                                        }
                                    } label: {
                                            Text("Suggest a change to Prayer Times")
                                        }
                                }
                            Button{
                                withAnimation (.easeInOut) {
                                    self.selectedMasjid = nil
                                }
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
                            Section("Prayer Times") {
                                HStack{
                                    Text("Fajr")
                                    Spacer()
                                    Divider().padding(.horizontal)
                                    Text(selectedMasjid!.prayerTimes.fajr)
                                }
                                HStack{
                                    Text("Dhuhr")
                                    Spacer()
                                    Divider().padding(.horizontal)
                                    Text(selectedMasjid!.prayerTimes.dhuhr)
                                }
                                HStack{
                                    Text("Asr")
                                    Spacer()
                                    Divider().padding(.horizontal)
                                    Text(selectedMasjid!.prayerTimes.asr)
                                }
                                HStack{
                                    Text("Maghrib")
                                    Spacer()
                                    Divider().padding(.horizontal)
                                    Text(selectedMasjid!.prayerTimes.maghrib)
                                }
                                HStack{
                                    Text("Isha")
                                    Spacer()
                                    Divider().padding(.horizontal)
                                    Text(selectedMasjid!.prayerTimes.isha)
                                }
                            }
                            Section("Juma"){
                                ForEach( 0..<selectedMasjid!.prayerTimes.juma.count, id: \.self) { index in
                                    
                                    HStack{
                                        Text("Juma \(index+1)")
                                        Spacer()
                                        Divider().padding(.horizontal)
                                        Text(selectedMasjid!.prayerTimes.juma[index])
                                    }
                                }
                            }
                            .listSectionSeparator(.visible)
                            
                        }
                        
                    }
                    .frame(height: CGFloat.relativeToScreen(.height, ratio: 0.35))
                    .background(Color.brandBackground)
                    .cornerRadius(20).shadow(radius: 20)
                    .padding()
                    
                }
                else {
                    if let selectedMasjid = Binding<Masjid>($selectedMasjid) {
                        MasjidChangeRequestView(isShowingThisView: $showChangeTimingsView, selectedMasjid: selectedMasjid)
                    }
                }
            }
        }
    }
}

struct MasjidDetail_Previews: PreviewProvider {
    static var previews: some View {
        StatefulPreviewWrapper(Masjid()){
            MasjidDetail(selectedMasjid: $0)
        }
    }
}
