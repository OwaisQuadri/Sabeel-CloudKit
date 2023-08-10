//
//  MasjidChangeRequestView.swift
//  Sabeel
//
//  Created by Owais on 2023-08-06.
//

import SwiftUI

struct MasjidChangeRequestView: View {
    @EnvironmentObject private var locationManager: LocationManager
    
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
        VStack(alignment: .leading) {
                if vm.isFromChangeRequest {
                    Group {
                        HStack (alignment: .center ) {
                            // header for voting on a changerequest
                            VStack {
                                Text(vm.selectedChangeRequest!.name)
                                    .masjidTitle()
                                Text(vm.selectedChangeRequest!.address)
                                    .masjidSubtitle()
                            }
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
                    }
                } else {
                    HStack (alignment: .center ) {
                        // header for creatng a changerequest
                        VStack {
                            Text(vm.name)
                                .font(.title)
                                .bold()
                                .frame(maxWidth: .infinity)
                                .foregroundColor(.brandPrimary)
                            Text(vm.address)
                                .font(.caption)
                                .foregroundColor(.brandSecondary)
                                .lineLimit(1)
                                .minimumScaleFactor(0.7)
                        }
                        Button {
                            vm.checkMarkButtonAction()
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
            
            
        }
        .frame(height: CGFloat.relativeToScreen(.height, ratio: 0.65))
        .background(Color.brandBackground)
        .cornerRadius(20).shadow(radius: 20)
        .padding()
        .textFieldStyle(.roundedBorder)
        .onAppear {
            vm.getChangeRequest(for: locationManager)
        }
    }
}

struct MasjidChangeRequestView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MasjidChangeRequestView(showChangeTimingsView: .constant(true))
        }
        
    }
}
extension String : Identifiable {
    public var id: ObjectIdentifier {
        return ObjectIdentifier(String.self)
    }
}
