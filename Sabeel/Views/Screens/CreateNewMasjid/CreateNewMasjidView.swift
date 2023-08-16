//
//  CreateNewMasjidView.swift
//  Sabeel
//
//  Created by Owais on 2023-08-14.
//

import SwiftUI

struct CreateNewMasjidView: View {
    @StateObject private var vm = CreateNewMasjidViewModel()
    @Binding var showThisView: Bool
    var body: some View {
        ZStack {
            VStack {
                HStack (alignment: .center ) {
                    // header for creatng a Masjid
                    VStack (alignment: .leading ) {
                        TextField(text: $vm.name, label: { Text("Masjid Name") })
                            .font(.title)
                            .bold()
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.brandPrimary)
                        Text("Note: Your current location will be saved as ")
                            .foregroundColor(.brandSecondary)
                            .font(.caption).bold()
                        + Text("\n\"\(vm.name == "" ? "Masjid Name" : vm.name)\"")
                            .foregroundColor(.brandRed)
                            .font(.caption).bold()
                        + Text(" on the map")
                            .foregroundColor(.brandSecondary)
                            .font(.caption).bold()
                    }
                    Button {
                        vm.createUnconfirmedMasjid()
                        playHaptic(.success)
                        showThisView = false // dismiss only if not cringe entry
                    } label: {
                        Image(systemName: "checkmark")
                            .foregroundColor(.brandPrimary)
                            .fontWeight(.bold)
                    }
                    .padding()
                    Button {
                        // dismiss
                        showThisView = false
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(.brandSecondary)
                    }
                    .padding()
                    
                }
                .padding(.horizontal)
                .padding(.top)
                // body for creating a changerequest
                ScrollView {
                    Group {
                        HStack {
                            Text("General Info:")
                                .font(.caption)
                            Spacer()
                        }
                        .padding(.top)
                        TextField("Address", text: $vm.address)
                        HStack {
                            TextField("Email", text: $vm.email)
                            TextField("Phone Number", text: $vm.phoneNumber)
                        }
                        TextField("Website", text: $vm.website)
                    }
                    .padding(.horizontal)
                    Divider()
                    Group {
                        HStack{
                            Text(Constants.prayerTimesTitle)
                                .font(.caption)
                                .foregroundColor(.brandSecondary)
                            Spacer()
                        }
                        LabeledContent {
                            HStack{
                                Spacer()
                                TextField("00:00AM", text: $vm.prayerTimes.fajr)
                                    .frame(width: CGFloat.relativeToScreen(.width, ratio: 0.2))
                            }
                        } label: {
                            Text("Fajr")
                        }
                        LabeledContent {
                            HStack{
                                Spacer()
                                TextField("00:00PM", text: $vm.prayerTimes.dhuhr)
                                    .frame(width: CGFloat.relativeToScreen(.width, ratio: 0.2))
                            }
                        } label: {
                            Text("Dhuhr")
                        }
                        LabeledContent {
                            HStack{
                                Spacer()
                                TextField("00:00PM", text: $vm.prayerTimes.asr)
                                    .frame(width: CGFloat.relativeToScreen(.width, ratio: 0.2))
                            }
                        } label: {
                            Text("Asr")
                        }
                        LabeledContent {
                            HStack{
                                Spacer()
                                TextField("00:00PM", text: $vm.prayerTimes.maghrib)
                                    .frame(width: CGFloat.relativeToScreen(.width, ratio: 0.2))
                            }
                        }label: {
                            Text("Maghrib")
                        }
                        LabeledContent {
                            HStack{
                                Spacer()
                                TextField("00:00PM", text: $vm.prayerTimes.isha)
                                    .frame(width: CGFloat.relativeToScreen(.width, ratio: 0.2))
                            }
                        } label: {
                            Text("Isha")
                        }
                        
                    }
                    .padding(.horizontal)
                    Group{
                        
                        if vm.prayerTimes.juma.count > 0 {
                            HStack {
                                Text(Constants.jumaTimesTitle)
                                    .font(.caption)
                                    .foregroundColor(.brandSecondary)
                                Spacer()
                            }
                            ForEach(vm.prayerTimes.juma.indices, id: \.self) { index in
                                HStack {
                                    LabeledContent {
                                        HStack{
                                            Spacer()
                                            TextField("00:00PM", text: $vm.prayerTimes.juma[index])
                                                .frame(width: CGFloat.relativeToScreen(.width, ratio: 0.2))
                                        }
                                    } label: {
                                        Text("Juma \(index + 1) :")
                                    }
                                    Button (role: .destructive){
                                        vm.prayerTimes.juma.remove(at: index)
                                    } label: {
                                        Label("", systemImage: "trash")
                                    }
                                    .padding(.horizontal)
                                    
                                }
                            }
                        }
                        if vm.prayerTimes.juma.count < Constants.maxNumberOfJumas {
                            Button {
                                withAnimation (.easeOut) {
                                    vm.prayerTimes.juma.append(vm.prayerTimes.dhuhr)
                                }
                            } label: {
                                HStack {
                                    Spacer()
                                    Label("Add a Juma", systemImage: "plus")
                                    Spacer()
                                }
                            }
                            .padding(.vertical)
                            .buttonStyle(.bordered)
                            .foregroundColor(.brandPrimary.opacity(0.7))
                        }
                    }
                    .padding(.horizontal)
                }
            }
            if vm.isLoading { LoadingView() }
        }
            .alert(item: $vm.alertItem ) { $0.alert }
            .onAppear { vm.onAppear() }
    }
}

struct CreateNewMasjidView_Previews: PreviewProvider {
    static var previews: some View {
        CreateNewMasjidView(showThisView: .constant(true))
    }
}
