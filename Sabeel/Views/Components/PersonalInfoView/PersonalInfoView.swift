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
        VStack(alignment: .leading){
            Text("Personal Info:")
                .font(.caption)
                .foregroundColor(.brandSecondary)
            HStack {
                TextField("Name", text: $vm.name).minimumScaleFactor(0.75)
                TextField("Username", text: $vm.handle)
                    .minimumScaleFactor(0.75)
                    .bold()
                    .foregroundColor(.brandPrimary)
                    .frame(width: .relativeToScreen(.width, ratio: 0.3))
                Button { vm.isCreatingNewProfile ? vm.createProfile() : vm.saveProfile() } label: {
                    HStack{
                        Text(vm.isCreatingNewProfile ? "Create" : "Save" )
                    }
                }
            }
            .textFieldStyle(.roundedBorder)
        }
        .onAppear { vm.startUpChecks() }
        .toolbar {
            Button { dismissKeyboard() } label: {
                Image(systemName: "keyboard.chevron.compact.down")
                    .tint(.brandPrimary)
            }
        }
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

