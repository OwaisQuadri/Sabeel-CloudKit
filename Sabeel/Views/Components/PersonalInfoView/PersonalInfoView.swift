//
//  PersonalInfoView.swift
//  Sabeel
//
//  Created by Owais on 2023-08-08.
//

import SwiftUI
import CloudKit

struct PersonalInfoView: View {
    
    @ObservedObject private var vm = PersonalInfoViewModel()
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading){
                Text("Personal Info:")
                    .font(.caption)
                    .foregroundColor(.brandSecondary)
                HStack {
                    TextField("Name", text: $vm.name).minimumScaleFactor(0.75)
                        .submitLabel(.done)
                    TextField("Username", text: $vm.handle)
                        .minimumScaleFactor(0.75)
                        .bold()
                        .foregroundColor(.brandPrimary)
                        .frame(width: .relativeToScreen(.width, ratio: 0.3))
                        .submitLabel(.done)
                        .onSubmit {
                            dismissKeyboard()
                        }
                    Button { if vm.profileContext == .create {dismissKeyboard();vm.createProfile()} else { dismissKeyboard();vm.saveProfile()} } label: {Text(vm.profileContext == .create ? "Create" : "Save")}
                }
                .textFieldStyle(.roundedBorder)
            }
            if vm.isLoading { LoadingView() }
        }
        .onAppear { vm.startUpChecks() }
        .alert(item: $vm.alertItem) { alertItem in
            Alert(title: alertItem.title, message: alertItem.message, dismissButton: alertItem.dismissButton)
        }
    }
}


struct PersonalInfoView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            PersonalInfoView()
        }
    }
}

