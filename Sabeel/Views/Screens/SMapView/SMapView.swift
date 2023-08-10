//
//  SMapView.swift
//  Sabeel
//
//  Created by Owais on 2023-08-06.
//

import SwiftUI
import MapKit

struct SMapView: View {
    @EnvironmentObject private var locationManager: LocationManager
    
    @StateObject private var vm = SMapViewModel()
    
    var body: some View {
        ZStack{
            Map(coordinateRegion: $vm.region, showsUserLocation: true, annotationItems: locationManager.masjids, annotationContent: { masjid in
                MapAnnotation(coordinate: masjid.location.coordinate) {
                    VStack {
                        Image("masjidOnMap")
                            .resizable()
//                            .background(Color.brandPrimary)
                            .scaledToFit()
                            .frame(width: .relativeToScreen(.width, ratio: 0.075))
                            .clipShape(Circle())
                            .opacity(0.7)
                    }
                    .onTapGesture {
                        locationManager.selectedMasjid = masjid
//                        vm.recenter(around: masjid.location.coordinate)
                    }
                }
            })
            .ignoresSafeArea(edges: .top)
            .onAppear {
                vm.checkIfLocationServicesEnabled()
            }
            VStack {
                BrandLargeBanner().shadow(color: .brandPrimary, radius: 5)
                Spacer()
                if locationManager.selectedMasjid != nil { MasjidDetail() }
            }
            .onAppear {
                vm.getMasjids(for: locationManager)
            }
        
        }
    }
}

struct SMapView_Previews: PreviewProvider {
    static var previews: some View {
        SMapView()
    }
}
