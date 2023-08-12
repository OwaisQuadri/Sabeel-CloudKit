//
//  MasjidHeadline.swift
//  Sabeel
//
//  Created by Owais on 2023-08-08.
//

import SwiftUI


struct MasjidHeadline: View {
    @State var name     : String
    @State var address  : String
    var body: some View {
        VStack {
            Text(name)
                .masjidTitle()
            Text(address)
                .masjidSubtitle()
        }
    }
}

struct MasjidHeadline_Previews: PreviewProvider {
    static var previews: some View {
        MasjidHeadline(name: "Masjid", address: "someplace")
    }
}
