//
//  View+CustomModifiers.swift
//  Sabeel
//
//  Created by Owais on 2023-08-08.
//

import SwiftUI

extension View {
    func masjidTitle() -> some View {
        self.modifier(MasjidTitle())
    }
    func masjidSubtitle() -> some View {
        self.modifier(MasjidSubtitle())
    }
}
struct MasjidTitle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.title)
            .bold()
            .foregroundColor(.brandPrimary)
            .minimumScaleFactor(0.75)
            .lineLimit(1)
    }
}
struct MasjidSubtitle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.caption)
            .foregroundColor(.brandSecondary)
            .lineLimit(1)
            .minimumScaleFactor(0.75)
    }
}
