//
//  PersonalInfoView.swift
//  Sabeel
//
//  Created by Owais on 2023-08-08.
//

import SwiftUI

struct PersonalInfoView: View {
    
    @State var name : String = ""
    @State var handle : String = ""
    
    var body: some View {
        VStack(alignment: .leading){
            Text("Personal Info:")
                .font(.caption)
                .foregroundColor(.brandSecondary)
            HStack {
                TextField("Name", text: $name)
                TextField("Username", text: $handle)
                    .bold()
                    .foregroundColor(.brandPrimary)
                    .frame(width: .relativeToScreen(.width, ratio: 0.3))
            }
            .disabled(false)
            .textFieldStyle(.roundedBorder)
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
