//
//  MasjidChangeRequestView.swift
//  Sabeel
//
//  Created by Owais on 2023-08-06.
//

import SwiftUI

struct MasjidChangeRequestView: View {
    @EnvironmentObject private var masjidManager: MasjidManager
    
    @StateObject private var vm = MasjidChangeRequestVM()
    
    @Binding var isShowingThisView: Bool
    
    init(showChangeTimingsView: Binding<Bool>) {
        self._isShowingThisView = showChangeTimingsView
    }
    
    func dismiss() {
        withAnimation(.easeInOut) {
            isShowingThisView = false
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                if masjidManager.selectedMasjid?.changeRequest != nil {
                    
                    // TODO: when the value is a changed value, render as brandPrimary else brandSecondary
                    
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
                                    dismiss()
                                } label: {
                                    Image(systemName: "chevron.down")
                                        .foregroundColor(.brandSecondary)
                                }
                                .padding()
                                
                            }
                            .padding(.top)
                            Divider()
                            HStack (alignment: .center) {
                                Text(vm.phoneNumber)
                                    .masjidSubtitle()
                                Divider()
                                Text(vm.email)
                                    .masjidSubtitle()
                                Divider()
                                Text(vm.website)
                                    .masjidSubtitle()
                            }
                            .padding(.horizontal)
                            Group {
                                Group {
                                    Divider()
                                    Text("Prayer Times").foregroundColor(.brandSecondary).bold().font(.headline)
                                    Group {
                                        Divider()
                                        PrayerCell(title: "Fajr", time: $vm.prayerTimes.fajr)
                                    }
                                    Group {
                                    Divider()
                                    PrayerCell(title: "Dhuhr", time: $vm.prayerTimes.dhuhr)}
                                    Divider()
                                    PrayerCell(title: "Asr", time: $vm.prayerTimes.asr)
                                    Divider()
                                    PrayerCell(title: "Maghrib", time: $vm.prayerTimes.maghrib)
                                    Divider()
                                    PrayerCell(title: "Isha", time: $vm.prayerTimes.isha)
                                }
                                Group {
                                    ForEach( 0..<vm.prayerTimes.juma.count, id: \.self) { index in
                                        if index == 0 { Text(Constants.jumaTimesTitle).foregroundColor(.brandSecondary).bold().font(.headline).padding(.top) }
                                        Divider()
                                        PrayerCell(title: "Juma \(index+1)", time: $vm.prayerTimes.juma[index])
                                    }
                                }
                                Divider()
                                Group {
                                    HStack(spacing: 25) {
                                        FillButton(backgroundColor: .brandRed.opacity(0.9), systemImage: "xmark", scale: 2) {
                                            vm.denyChangeRequest(with: masjidManager)
                                            playHaptic(.warning)
                                        }
                                        FillButton(backgroundColor: .brandGreen.opacity(0.9), systemImage: "checkmark", scale: 2) {
                                            vm.acceptChangeRequest(with: masjidManager)
                                            playHaptic(.success)
                                        }
                                    }
                                    .frame(height: .relativeToScreen(.height, ratio: 0.1))
                                    .padding()
                                }
                            }
                            .padding(.horizontal)
                            .font(.title3)
                        }
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
                                vm.checkMarkButtonAction(using: masjidManager)
                                playHaptic(.success)
                            } label: {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.brandPrimary)
                                    .fontWeight(.bold)
                            }
                            .alert("No Edits Made", isPresented: $vm.showNotEditedAlert, actions: {
                                Button("OK", role: .cancel) {}
                            })
                            .padding()
                            Button {
                                dismiss()
                            } label: {
                                Image(systemName: "chevron.down")
                                    .foregroundColor(.brandSecondary)
                            }
                            .padding()
                            
                        }
                        .padding(.horizontal)
                        .padding(.top)
                        // body for creating a changerequest
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
                            if vm.prayerTimes.juma.count < 3 {
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
                    
                
                Spacer()
                
                
            }.onAppear {
                vm.onAppear(with: masjidManager)
            }
        }
        .frame(height: CGFloat.relativeToScreen(.height, ratio: 0.65))
        .background(Color.brandBackground)
        .cornerRadius(20).shadow(radius: 20)
        .padding()
        .textFieldStyle(.roundedBorder)
        
        //add alert stuff
    }
}

struct MasjidChangeRequestView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MasjidChangeRequestView(showChangeTimingsView: .constant(true))
                .environmentObject(MasjidManager([Masjid(record: MockData.masjid)], selected: Masjid(record: MockData.masjidWithChangeRequest)))
        }
        
    }
}
extension String : Identifiable {
    public var id: ObjectIdentifier {
        return ObjectIdentifier(String.self)
    }
}

struct PrayerCell: View {
    var title: String
    @Binding var time: String
    var body: some View {
        HStack{
            Text(title).foregroundStyle(Color.brandSecondary).font(.subheadline)
            Spacer()
            Text(time).bold().foregroundStyle(Color.brandPrimary)
        }
    }
}
