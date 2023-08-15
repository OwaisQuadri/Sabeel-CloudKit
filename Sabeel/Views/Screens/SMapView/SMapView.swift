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
    @ObservedObject var vm: SMapViewModel
    
    var body: some View {
        ZStack{
            Map(coordinateRegion: $vm.region, showsUserLocation: true, annotationItems: masjidManager.masjids, annotationContent: { masjid in
                
                MapAnnotation(coordinate: masjid.location.coordinate) {
                    Image.masjidLogo
                        .resizable() .scaledToFit()
                        .frame(width: .relativeToScreen(.width, ratio: 0.075))
                        .clipShape(RoundedRectangle(cornerSize: CGSize(width: 5, height: 5), style: .continuous))
                        .shadow(radius: 5)
                        .transition(.scale)
                        .onTapGesture { vm.select(masjid: masjid, for: masjidManager) }
                }
            })
            .ignoresSafeArea(edges: .top)
            VStack {
                if masjidManager.selectedMasjid != nil {
                    Spacer(minLength: .relativeToScreen(.height, ratio: 0.1))
                    MasjidDetailView(vm: MasjidDetailViewModel($vm.alertItem)) .transition(.move(edge: .bottom))
                        .onDisappear { Task {vm.getMasjids(with: masjidManager)} }
                } else {
                    HStack (alignment: .center) {
                            Button {
                                print("pressed")
                                vm.isCreatingNewMasjid = true
                            } label: {
                                ZStack {
                                    Logo()
                                        .frame(
                                            width: .relativeToScreen(.height, ratio: 0.05),
                                            height: .relativeToScreen(.height, ratio: 0.05))
                                        .shadow(color: .brandPrimary, radius: 5)
                                    Image(systemName: "plus")
                                        .resizable()
                                        .imageScale(.small)
                                        .frame(
                                            width: .relativeToScreen(.width, ratio: 0.0175),
                                            height: .relativeToScreen(.width, ratio: 0.0175))
                                        .offset(y: 16)
                                }
                                .tint(.white)
                            }
                        Spacer()
                        Text("SABEEL")
                            .font(.title).bold()
                            .shadow(color: .brandPrimary, radius: 5)
                            .foregroundColor(.white)
                    }
                    .padding()
                    .transition(.move(edge: .top))
                    Spacer()
                }
            }
        }
        .sheet(isPresented: $vm.isCreatingNewMasjid, content: {
            CreateNewMasjidView(showThisView: $vm.isCreatingNewMasjid)
        })
        .task { vm.onAppear(with: masjidManager) }
        .alert(item: $vm.alertItem) { $0.alert }
    }
}

struct SMapView_Previews: PreviewProvider {
    static var previews: some View {
        SMapView(vm: SMapViewModel()).environmentObject(MasjidManager([Masjid(record: MockData.masjid)]))
    }
}
