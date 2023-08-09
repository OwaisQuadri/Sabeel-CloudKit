//
//  MasjidChangeRequestView.swift
//  Sabeel
//
//  Created by Owais on 2023-08-06.
//

import SwiftUI

struct MasjidChangeRequestView: View {
    @Binding var isShowingThisView: Bool
    @Binding var selectedMasjid: Masjid
    
    @State var showNotEditedAlert = false
    
    @State var name: String = ""
    @State var address: String = ""
    @State var email: String = ""
    @State var phoneNumber: String = ""
    @State var website: String = ""
    @State var prayerTimes: PrayerTimes = PrayerTimes()
    
    init(isShowingThisView: Binding<Bool>, selectedMasjid: Binding<Masjid>) {
        self._selectedMasjid = selectedMasjid
        self.name = selectedMasjid.wrappedValue.name
        self.address = selectedMasjid.wrappedValue.address
        self.email = selectedMasjid.wrappedValue.email ?? ""
        self.phoneNumber = selectedMasjid.wrappedValue.phoneNumber ?? ""
        self.website = selectedMasjid.wrappedValue.website ?? ""
        self.prayerTimes = selectedMasjid.wrappedValue.prayerTimes
        if let selectedChangeRequest = selectedMasjid.wrappedValue.changeRequest {
            self.name = selectedChangeRequest.name
            self.address = selectedChangeRequest.address
            self.email = selectedChangeRequest.email ?? ""
            self.phoneNumber = selectedChangeRequest.phoneNumber ?? ""
            self.website = selectedChangeRequest.website ?? ""
            self.prayerTimes = selectedChangeRequest.prayerTimes
        }
        
        self._isShowingThisView = isShowingThisView
    }
    
    func dismiss() {
        withAnimation(.easeInOut) {
            isShowingThisView = false
        }
    }
    
    var isEdited: Bool { // TODO: have state variable for this later
        let email = email == Optional("") ? nil : email
        let phoneNumber = phoneNumber == Optional("") ? nil : phoneNumber
        let website = website == Optional("") ? nil : website
        let proposal = Masjid(name: name, email: email , address: address, phoneNumber: phoneNumber, website: website, prayerTimes: prayerTimes, changeRequest: selectedMasjid.changeRequest)
        return selectedMasjid != proposal
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Group {
                if let changeRequest = selectedMasjid.changeRequest {
                    HStack (alignment: .center ) {
                        // header for voting on a changerequest
                        VStack {
                            Text(changeRequest.name)
                                .masjidTitle()
                            Text(changeRequest.address)
                                .masjidSubtitle()
                        }
                        Button {
                            withAnimation (.easeInOut) {
                                self.isShowingThisView = false
                            }
                        } label: {
                            Image(systemName: "chevron.down")
                                .foregroundColor(.brandSecondary)
                        }
                        .padding()
                        
                    }
                    .padding(.horizontal)
                    .padding(.top)
                } else {
                    HStack (alignment: .center ) {
                        // header for creatng a changerequest
                        VStack {
                            Text(name)
                                .font(.title)
                                .bold()
                                .frame(maxWidth: .infinity)
                                .foregroundColor(.brandPrimary)
                            Text(address)
                                .font(.caption)
                                .foregroundColor(.brandSecondary)
                                .lineLimit(1)
                                .minimumScaleFactor(0.7)
                        }
                        Button {
                            withAnimation (.easeInOut) {
                                if isEdited {
                                #warning("unable to set value for custom object inside binding")
                                    // TODO: implement viewModel
                                    self.selectedMasjid.changeRequest = MasjidChangeRequest(name: name, email: email, address: address, phoneNumber: phoneNumber, website: website, prayerTimes: prayerTimes, yesVotes: 1, noVotes: 0, votesToPass: 2)
                                    if let _ = selectedMasjid.changeRequest {
                                        dismiss()
                                    }
                                } else {
                                    showNotEditedAlert = true
                                }
                            }
                        } label: {
                            Image(systemName: "checkmark")
                                .foregroundColor(.brandPrimary)
                                .fontWeight(.bold)
                            
                        }
                        .alert("No Edits Made", isPresented: $showNotEditedAlert, actions: {
                            Button("OK", role: .cancel) {}
                        })
                        .padding()
                        Button {
                            withAnimation (.easeInOut) {
                                self.isShowingThisView = false
                            }
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
                        TextField("Address", text: $address)
                        HStack {
                            TextField("Email", text: $email)
                            TextField("Phone Number", text: $phoneNumber)
                        }
                        TextField("Website", text: $website)
                    }
                    .padding(.horizontal)
                    Group {
                        Text("Prayer Timings:")
                            .font(.caption)
                            .foregroundColor(.brandSecondary)
                        LabeledContent {
                            HStack{
                                Spacer()
                                TextField("Fajr", text: $prayerTimes.fajr)
                                    .frame(width: CGFloat.relativeToScreen(.width, ratio: 0.2))
                            }
                        } label: {
                            Text("Fajr")
                        }
                        LabeledContent {
                            HStack{
                                Spacer()
                                TextField("Dhuhr", text: $prayerTimes.dhuhr)
                                    .frame(width: CGFloat.relativeToScreen(.width, ratio: 0.2))
                            }
                        } label: {
                            Text("Dhuhr")
                        }
                        LabeledContent {
                            HStack{
                                Spacer()
                                TextField("Asr", text: $prayerTimes.asr)
                                    .frame(width: CGFloat.relativeToScreen(.width, ratio: 0.2))
                            }
                        } label: {
                            Text("Asr")
                        }
                        LabeledContent {
                            HStack{
                                Spacer()
                                TextField("Maghrib", text: $prayerTimes.maghrib)
                                    .frame(width: CGFloat.relativeToScreen(.width, ratio: 0.2))
                            }
                        }label: {
                            Text("Maghrib")
                        }
                        LabeledContent {
                            HStack{
                                Spacer()
                                TextField("Isha", text: $prayerTimes.isha)
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
                        ForEach(prayerTimes.juma.indices, id: \.self) { index in
                            HStack {
                                LabeledContent {
                                    HStack{
                                        Spacer()
                                        TextField("Juma \(index + 1)", text: $prayerTimes.juma[index])
                                            .frame(width: CGFloat.relativeToScreen(.width, ratio: 0.2))
                                    }
                                } label: {
                                    Text("Juma \(index + 1) :")
                                }
                                Button (role: .destructive){
                                    prayerTimes.juma.remove(at: index)
                                } label: {
                                    Label("", systemImage: "trash")
                                }
                                .padding(.horizontal)
                                
                            }
                        }
                        if prayerTimes.juma.count < 3 {
                            Button {
                                withAnimation (.easeOut) {
                                    self.prayerTimes.juma.append(prayerTimes.dhuhr)
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
        .frame(height: CGFloat.relativeToScreen(.height, ratio: 0.65))
        .background(Color.brandBackground)
        .cornerRadius(20).shadow(radius: 20)
        .padding()
        .textFieldStyle(.roundedBorder)
    }
}

struct MasjidChangeRequestView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MasjidChangeRequestView(isShowingThisView: .constant(true), selectedMasjid: .constant(Masjid()))
        }
        
    }
}
extension String : Identifiable {
    public var id: ObjectIdentifier {
        return ObjectIdentifier(String.self)
    }
}
