//
//  FillButton.swift
//  Sabeel
//
//  Created by Owais on 2023-08-12.
//

import SwiftUI

struct FillButton: View {
    let backgroundColor : Color
    let systemImage: String
    var onClick: () -> Void
    var body: some View {
        Button {
            onClick()
        } label: {
            ZStack {
                backgroundColor
                Image(systemName: systemImage)
                    .scaledToFill()
                    .foregroundColor(.brandBackground)
            }
            .cornerRadius(10)
        }

            
    }
}

struct FillButton_Previews: PreviewProvider {
    static var previews: some View {
        FillButton(backgroundColor: .brandGreen, systemImage: "checkmark" ) {
            print("click")
        }
    }
}
