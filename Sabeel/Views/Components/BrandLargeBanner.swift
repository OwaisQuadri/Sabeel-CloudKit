//
//  BrandLargeBanner.swift
//  Sabeel
//
//  Created by Owais on 2023-08-08.
//

import SwiftUI

struct BrandLargeBanner: View {
    var body: some View {
        
        // TODO: add logo .resizable.scaledtofit.frame with height 20% of screen
        Text("Sabeel - سبيل")
            .font(.largeTitle)
            .padding()
        
    }
}

struct BrandLargeBanner_Previews: PreviewProvider {
    static var previews: some View {
        BrandLargeBanner()
    }
}
