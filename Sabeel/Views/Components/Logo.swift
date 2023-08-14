//
//  BrandLargeBanner.swift
//  Sabeel
//
//  Created by Owais on 2023-08-08.
//

import SwiftUI

struct Logo: View {
    var body: some View {
        
        Image.masjidLogo
            .resizable()
            .scaledToFit()
            .cornerRadius(10)
        
    }
}

struct BrandLargeBanner_Previews: PreviewProvider {
    static var previews: some View {
        Logo()
    }
}
