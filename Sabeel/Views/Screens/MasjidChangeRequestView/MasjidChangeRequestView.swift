//
//  MasjidChangeRequestView.swift
//  Sabeel
//
//  Created by Owais on 2023-08-06.
//

import SwiftUI

struct MasjidChangeRequestView: View {
    
    @EnvironmentObject private var masjidManager: MasjidManager
    @Environment(\.keyboardShowing) var isKeyboardShowing
    
    @StateObject var vm: MasjidChangeRequestVM
    
    
    
    
    var body: some View {
        VStack(alignment: .leading) {
            if masjidManager.selectedMasjid?.changeRequest != nil {
                
                Group {
                    HStack (alignment: .center ) {
                        // header for voting on a changerequest
                        Spacer()
                        VStack {
                            Text(vm.name)
                                .masjidTitle()
                            Text(vm.address)
                                .masjidSubtitle()
                        }
                        Spacer()
                        Button {
                            vm.dismiss()
                        } label: {
                            Image(systemName: "chevron.down")
                                .foregroundColor(.brandSecondary)
                        }
                        .padding()
                    }
                    .padding()
                    Divider()
                    HStack (alignment: .center, spacing: 10) {
                        Text(vm.phoneNumber)
                            .masjidSubtitle()
                        Text(vm.email)
                            .masjidSubtitle()
                        Text(vm.website)
                            .masjidSubtitle()
                    }
                    .padding(.horizontal)
                    
                    ScrollView {
                        Group {
                            Divider()
                            Text("Prayer Times").foregroundColor(.brandSecondary).bold().font(.headline)
                            Group {
                                Divider()
                                PrayerCell(title: "Fajr", time: vm.prayerTimes.fajr)
                            }
                            Group {
                                Divider()
                                PrayerCell(title: "Dhuhr", time: vm.prayerTimes.dhuhr)}
                            Divider()
                            PrayerCell(title: "Asr", time: vm.prayerTimes.asr)
                            Divider()
                            PrayerCell(title: "Maghrib", time: vm.prayerTimes.maghrib)
                            Divider()
                            PrayerCell(title: "Isha", time: vm.prayerTimes.isha)
                        }
                        Group {
                            ForEach( 0..<vm.prayerTimes.juma.count, id: \.self) { index in
                                if index == 0 { Text(Constants.jumaTimesTitle).foregroundColor(.brandSecondary).bold().font(.headline).padding(.top) }
                                Divider()
                                PrayerCell(title: "Juma \(index+1)", time: vm.prayerTimes.juma[index])
                            }
                        }
                    }
                    Divider()
                    Group {
                        HStack(spacing: 25) {
                            FillButton(backgroundColor: .brandRed.opacity(0.9), systemImage: "xmark", scale: 2) {
                                vm.denyChangeRequest(with: masjidManager)
                                playHaptic(.warning)
                                vm.dismiss()
                            }
                            FillButton(backgroundColor: .brandGreen.opacity(0.9), systemImage: "checkmark", scale: 2) {
                                vm.acceptChangeRequest(with: masjidManager)
                                playHaptic(.success)
                                vm.dismiss()
                            }
                        }
                        .frame(height: .relativeToScreen(.height, ratio: 0.1))
                        .padding()
                    }
                }
                .padding(.horizontal)
                .font(.title3)
            } else {
                HStack (alignment: .center ) {
                    // header for creatng a changerequest
                    VStack {
                        TextField(text: $vm.name, label: { Text("Masjid Name") })
                            .font(.title)
                            .bold()
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.brandPrimary)
                    }
                    Button {
                        vm.createNewChangeRequest(using: masjidManager)
                        playHaptic(.success)
                        vm.dismiss()
                    } label: {
                        Image(systemName: "checkmark")
                            .foregroundColor(.brandPrimary)
                            .fontWeight(.bold)
                    }
                    .padding()
                    Button {
                        vm.dismiss()
                    } label: {
                        Image(systemName: "chevron.down")
                            .foregroundColor(.brandSecondary)
                    }
                    .padding()
                    
                }
                .padding(.horizontal)
                .padding(.top)
                // body for creating a changerequest
                ScrollView {
                    Group {
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
                        Text("Prayer Timings:")
                            .font(.caption)
                            .foregroundColor(.brandSecondary)
                        LabeledContent {
                            HStack{
                                Spacer()
                                TextField("Fajr", text: $vm.prayerTimes.fajr)
                                    .frame(width: CGFloat.relativeToScreen(.width, ratio: 0.2))
                            }
                        } label: {
                            Text("Fajr")
                        }
                        LabeledContent {
                            HStack{
                                Spacer()
                                TextField("Dhuhr", text: $vm.prayerTimes.dhuhr)
                                    .frame(width: CGFloat.relativeToScreen(.width, ratio: 0.2))
                            }
                        } label: {
                            Text("Dhuhr")
                        }
                        LabeledContent {
                            HStack{
                                Spacer()
                                TextField("Asr", text: $vm.prayerTimes.asr)
                                    .frame(width: CGFloat.relativeToScreen(.width, ratio: 0.2))
                            }
                        } label: {
                            Text("Asr")
                        }
                        LabeledContent {
                            HStack{
                                Spacer()
                                TextField("Maghrib", text: $vm.prayerTimes.maghrib)
                                    .frame(width: CGFloat.relativeToScreen(.width, ratio: 0.2))
                            }
                        }label: {
                            Text("Maghrib")
                        }
                        LabeledContent {
                            HStack{
                                Spacer()
                                TextField("Isha", text: $vm.prayerTimes.isha)
                                    .frame(width: CGFloat.relativeToScreen(.width, ratio: 0.2))
                            }
                        } label: {
                            Text("Isha")
                        }
                        
                    }
                    .padding(.horizontal)
                    Group{
                        Text("Juma Timings:")
                            .font(.caption)
                            .foregroundColor(.brandSecondary)
                        ForEach(vm.prayerTimes.juma.indices, id: \.self) { index in
                            HStack {
                                LabeledContent {
                                    HStack{
                                        Spacer()
                                        TextField("Juma \(index + 1)", text: $vm.prayerTimes.juma[index])
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
                            .buttonStyle(.bordered)
                            .foregroundColor(.brandPrimary.opacity(0.7))
                        }
                    }
                    .padding(.horizontal)
                }
            }
            Spacer()
        }
        .frame(height: CGFloat.relativeToScreen(.height, ratio: isKeyboardShowing ? 0.4 : 0.65))
        .background(Color.brandBackground)
        .cornerRadius(20).shadow(radius: 20)
        .padding()
        .textFieldStyle(.roundedBorder)
        .onAppear {
            vm.onAppear(with: masjidManager)
        }
        .alert(item: $vm.alertItem) { $0.alert }
    }
}


struct MasjidChangeRequestView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MasjidChangeRequestView(vm: MasjidChangeRequestVM(showChangeTimingsView: .constant(true), .constant(nil)))
                .environmentObject(MasjidManager([Masjid(record: MockData.masjid)], selected: Masjid(record: MockData.masjidWithChangeRequest)))
        }
        
    }
}
extension String : Identifiable {
    public var id: ObjectIdentifier {
        return ObjectIdentifier(String.self)
    }
}
