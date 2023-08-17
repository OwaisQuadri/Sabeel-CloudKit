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
            // update rotation for ios 15
            Map(coordinateRegion: $vm.region, showsUserLocation: true, annotationItems: masjidManager.masjids, annotationContent: { masjid in
                MapAnnotation(coordinate: masjid.location.coordinate) {
                    Image.masjidLogo
                        .resizable() .scaledToFit()
                        .frame(width: .relativeToScreen(.width, ratio: 0.075))
                        .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
                        .shadow(radius: 5)
                        .transition(.scale)
                        .onTapGesture { vm.select(masjid: masjid, for: masjidManager) }
                }
            })
            .ignoresSafeArea(edges: .top)
            VStack {
                if masjidManager.selectedMasjid == nil {
                        HStack {
                                Button {
                                    print("pressed")
                                    vm.isCreatingNewMasjid = true
                                } label: {
                                    ZStack {
                                        Logo()
                                            .frame(
                                                width: .relativeToScreen(.height, ratio: 0.05),
                                                height: .relativeToScreen(.height, ratio: 0.05))
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
                                .foregroundColor(.white)
                        }
                        .shadow(radius: 10)
                        .padding()
                        .transition(.move(edge: .top))
                        Spacer()
                        HStack {
                            Button { vm.focusUser(); vm.getMasjids(with: masjidManager) } label: {
                                Image(systemName: "location")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: .relativeToScreen(.width, ratio: 0.1))
                            }
                            .padding(.bottom)
                            Spacer()
                            Button { vm.getMasjids(with: masjidManager); vm.focusFavouriteMasjid() } label: {
                                Image(systemName: "arrow.clockwise")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: .relativeToScreen(.width, ratio: 0.1))
                            }
                            .padding(.bottom)
                        }
                        .symbolVariant(.fill.circle)
                        .foregroundStyle(.white.shadow(.drop(radius: 2)), .tint)
                        .shadow(radius: 10)
                        .transition(.move(edge: .bottom))
                        .padding()
                    
                }
                else {
                    Spacer(minLength: .relativeToScreen(.height, ratio: 0.1))
                    MasjidDetailView(vm: MasjidDetailViewModel($vm.alertItem)) .transition(.move(edge: .bottom))
                        .onDisappear { Task {vm.getMasjids(with: masjidManager)} }
                }
            }
        }
        .sheet(isPresented: $vm.isCreatingNewMasjid, content: {
            CreateNewMasjidView(showThisView: $vm.isCreatingNewMasjid)
                .onDisappear{ Task{ vm.getMasjids(with: masjidManager) } }
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
