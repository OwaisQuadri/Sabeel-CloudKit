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
    @State private var selectedMasjid: Masjid?
    
    var body: some View {
        ZStack{
            Map(coordinateRegion: $region)
                .ignoresSafeArea(edges: .top)
            VStack {
                BrandLargeBanner().shadow(color: .brandPrimary, radius: 5)
                Button ("Open Masjid") { self.selectedMasjid = Masjid() } .buttonStyle(.bordered)
                Spacer()
                if selectedMasjid != nil { MasjidDetail(selectedMasjid: $selectedMasjid) }
            }
        }
    }
}

struct SMapView_Previews: PreviewProvider {
    static var previews: some View {
        SMapView()
    }
}
