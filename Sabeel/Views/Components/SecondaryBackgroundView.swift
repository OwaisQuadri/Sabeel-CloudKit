//
//  SecondaryBackgroundView.swift
//  Sabeel
//
//  Created by Owais on 2023-08-13.
//
/// PROJECT REUSABLE

import SwiftUI

struct SecondaryBackgroundView: View {
    var body: some View {
        Color(uiColor: .secondarySystemBackground)
            .frame(height: .relativeToScreen(.height, ratio: 0.09))
            .cornerRadius(10)
    }
}

struct SecondaryBackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        SecondaryBackgroundView()
    }
}
