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
        if $selectedMasjid.wrappedValue != nil {
            ZStack {
                if !$showChangeTimingsView.wrappedValue {
                    VStack(alignment: .center) {
                        HStack (alignment: .center ) {
                            VStack {
                                Text(selectedMasjid?.name ?? "Unknown")
                                    .font(.title)
                                    .bold()
                                    .frame(maxWidth: .infinity)
                                    .foregroundColor(.brandPrimary)
                                Text(selectedMasjid?.address ?? "Unknown")
                                    .font(.caption)
                                    .foregroundColor(.brandSecondary)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.5)
                            }
                            Button(action: {
                                withAnimation(.easeInOut){
                                    showContactInfo = true
                                    
                                }}) {
                                    Image(systemName: "ellipsis")
                                        .foregroundColor(.brandSecondary)
                                }
                                .padding(.vertical)
                                .confirmationDialog("Actions", isPresented: $showContactInfo, titleVisibility: .visible) {
                                    Button("Send an Email") {
                                        print( "send to email")
                                    }
                                    .disabled($selectedMasjid.wrappedValue?.email == nil)
                                    Button("Call") {
                                        print( "send to call")
                                    }
                                    .disabled($selectedMasjid.wrappedValue?.phoneNumber == nil)
                                    Button("Visit Website") {
                                        print( "send to website" )
                                    }
                                    .disabled($selectedMasjid.wrappedValue?.website == nil)
                                    Button(role: .destructive, action: {
                                        withAnimation (.easeInOut) {
                                            self.showChangeTimingsView = true
                                            self.showContactInfo = false
                                        }}) {
                                            Text("Suggest a change to Prayer Times")
                                        }
                                }
                            Button(action: {
                                withAnimation (.easeInOut) {
                                    self.selectedMasjid = nil
                                }
                            }) {
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
                                    Text($selectedMasjid.wrappedValue!.prayerTimes.fajr)
                                }
                                HStack{
                                    Text("Dhuhr")
                                    Spacer()
                                    Divider().padding(.horizontal)
                                    Text($selectedMasjid.wrappedValue!.prayerTimes.dhuhr)
                                }
                                HStack{
                                    Text("Asr")
                                    Spacer()
                                    Divider().padding(.horizontal)
                                    Text($selectedMasjid.wrappedValue!.prayerTimes.asr)
                                }
                                HStack{
                                    Text("Maghrib")
                                    Spacer()
                                    Divider().padding(.horizontal)
                                    Text($selectedMasjid.wrappedValue!.prayerTimes.maghrib)
                                }
                                HStack{
                                    Text("Isha")
                                    Spacer()
                                    Divider().padding(.horizontal)
                                    Text($selectedMasjid.wrappedValue!.prayerTimes.isha)
                                }
                            }
                            Section("Juma"){
                                ForEach( 0..<$selectedMasjid.wrappedValue!.prayerTimes.juma.count, id: \.self) { index in
                                    
                                    HStack{
                                        Text("Juma \(index+1)")
                                        Spacer()
                                        Divider().padding(.horizontal)
                                        Text($selectedMasjid.wrappedValue!.prayerTimes.juma[index])
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
                    MasjidChangeRequestView(isShowingThisView: $showChangeTimingsView, selectedMasjid: $selectedMasjid)
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
