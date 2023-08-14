//
//  SProfileView.swift
//  Sabeel
//
//  Created by Owais on 2023-08-06.
//

import SwiftUI

struct SProfileView: View {
    
    @ObservedObject private var vm = SProfileViewModel()
    @ObservedObject var personalInfoVM: PersonalInfoViewModel
    
    var body: some View {
        List {
            Section {
                PersonalInfoView(vm: personalInfoVM)
            }
            SSettingsView()
        }
        .navigationTitle("Profile")
    }
}

struct SProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SProfileView(personalInfoVM: PersonalInfoViewModel())
        }
    }
}





