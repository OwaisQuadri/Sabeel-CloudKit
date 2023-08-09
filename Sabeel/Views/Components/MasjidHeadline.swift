//
//  MasjidHeadline.swift
//  Sabeel
//
//  Created by Owais on 2023-08-08.
//

import SwiftUI


struct MasjidHeadline: View {
    @State var selectedMasjid: Masjid?
    var body: some View {
        VStack {
            Text(selectedMasjid?.name ?? "Unknown")
                .masjidTitle()
            Text(selectedMasjid?.address ?? "Unknown")
                .masjidSubtitle()
        }
    }
}

struct MasjidHeadline_Previews: PreviewProvider {
    static var previews: some View {
        MasjidHeadline()
    }
}
