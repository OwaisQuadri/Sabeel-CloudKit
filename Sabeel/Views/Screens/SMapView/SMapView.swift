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
                    VStack {
                        Image("masjidOnMap") //masjid.isConfirmed ? "masjidOnMap" : "questionmark")
                            .resizable()
                            //.background(Color.brandPrimary)
                            //.foregroundColor(.brandBackground)
                            .scaledToFit()
                            .frame(width: .relativeToScreen(.width, ratio: 0.075))
                            .clipShape(Circle())
                            .opacity(0.7)
                    }
                    .onTapGesture {
                        withAnimation(.easeInOut){
                            vm.setFocus(masjid.location)
                        }
                        masjidManager.selectedMasjid = masjid
//                       TODO: vm.recenter(around: masjid.location.coordinate)
                    }
                }
            })
            .ignoresSafeArea(edges: .top)
            .onAppear { vm.onAppear(with: masjidManager) }
            VStack {
                BrandLargeBanner().shadow(color: .brandPrimary, radius: 5)
                Spacer()
                if masjidManager.selectedMasjid != nil {
                    MasjidDetail()
                        .transition(.slide)
                        .animation(.easeOut)
                        .onDisappear { vm.getMasjids(with: masjidManager) }
                }
            }
        }
        .alert(item: $vm.alertItem) { alertItem in
            Alert(title: alertItem.title, message: alertItem.message, dismissButton: alertItem.dismissButton)
        }
    }
}

struct SMapView_Previews: PreviewProvider {
    static var previews: some View {
        SMapView().environmentObject(MasjidManager([Masjid(record: MockData.masjid)]))
    }
}
