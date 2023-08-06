//
//  SMapView.swift
//  Sabeel
//
//  Created by Owais on 2023-08-06.
//

import SwiftUI
import MapKit

struct SMapView: View {
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 43.8924901, longitude: -78.8649466), span: MKCoordinateSpan(latitudeDelta: 0.15, longitudeDelta: 0.15)) // TODO: Ideally we want the users location
    var body: some View {
        ZStack{
            Map(coordinateRegion: $region)
                .ignoresSafeArea()
            VStack {
                // TODO: add logo .resizable.scaledtofit.frame with height 20% of screen
                Text("Sabeel - سبيل")
                    .font(.largeTitle)
                    .padding()
                    .shadow(color: .brandPrimary, radius: 5)
                Spacer()
            }
            .ignoresSafeArea(edges: .bottom)
        }
    }
}

struct SMapView_Previews: PreviewProvider {
    static var previews: some View {
        SMapView()
    }
}
