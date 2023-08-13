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
    let scale: Double
    var onClick: () -> Void
    var body: some View {
        Button {
            onClick()
        } label: {
            ZStack {
                backgroundColor
                Image(systemName: systemImage)
                    .scaledToFill()
                    .scaleEffect(scale)
                    .foregroundColor(.white.opacity(0.8))
            }
            .cornerRadius(10)
        }

            
    }
}

struct FillButton_Previews: PreviewProvider {
    static var previews: some View {
        FillButton(backgroundColor: .brandGreen, systemImage: "checkmark", scale: 2.0 ) {
            print("click")
        }
    }
}
