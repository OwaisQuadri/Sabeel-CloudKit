//
//  SMapView.swift
//  Sabeel
//
//  Created by Owais on 2023-08-06.
//

import SwiftUI
import MapKit

struct SMapView: View {
    
    @EnvironmentObject private var masjidManager: MasjidManager
    
    @StateObject private var vm = SMapViewModel()
    
    var body: some View {
        ZStack{
            Map(coordinateRegion: $vm.region, showsUserLocation: true, annotationItems: masjidManager.masjids, annotationContent: { masjid in
                
                MapAnnotation(coordinate: masjid.location.coordinate) {
                    Image("masjidOnMap") // TODO: masjid.isConfirmed ? "masjidOnMap" : "questionmark")
                        .resizable() .scaledToFit()
                        .frame(width: .relativeToScreen(.width, ratio: 0.075))
                        .clipShape(RoundedRectangle(cornerSize: CGSize(width: 5, height: 5), style: .continuous))
                        .shadow(radius: 5)
                        .transition(.scale)
                        .onTapGesture { vm.select(masjid: masjid, for: masjidManager) }
                }
            })
            .ignoresSafeArea(edges: .top)
            .onAppear { vm.onAppear(with: masjidManager) }
            VStack {
                if masjidManager.selectedMasjid != nil {
                    Spacer()
                    MasjidDetail() .transition(.move(edge: .bottom))
                        .onDisappear { vm.getMasjids(with: masjidManager) }
                } else {
                    BrandLargeBanner().shadow(color: .brandPrimary, radius: 5) .transition(.scale)
                    Spacer()
                }
            }
        }
        .alert(item: $vm.alertItem) { $0.alert }
    }
}

struct SMapView_Previews: PreviewProvider {
    static var previews: some View {
        SMapView().environmentObject(MasjidManager([Masjid(record: MockData.masjid)]))
    }
}
