//
//  PersonalInfoView.swift
//  Sabeel
//
//  Created by Owais on 2023-08-08.
//

import SwiftUI
import CloudKit

struct PersonalInfoView: View {
    
    @ObservedObject var vm: PersonalInfoViewModel
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading){
                Text("Personal Info:")
                    .font(.caption)
                    .foregroundColor(.brandSecondary)
                HStack {
                    TextField("Name", text: $vm.name).minimumScaleFactor(0.75)
                        .autocorrectionDisabled()
                        .submitLabel(.done)
                    TextField("Username", text: $vm.handle)
                        .autocorrectionDisabled()
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
        .task { vm.startUpChecks() }
        .alert(item: $vm.alertItem) { $0.alert }
    }
}


struct PersonalInfoView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            PersonalInfoView(vm: PersonalInfoViewModel())
        }
    }
}

