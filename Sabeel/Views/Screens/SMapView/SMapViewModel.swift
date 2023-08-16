//
//  SMapViewModel.swift
//  Sabeel
//
//  Created by Owais on 2023-08-10.
//

import SwiftUI
import MapKit

 final class SMapViewModel: NSObject, ObservableObject {
    @Published var region: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 43.95, longitude: -79), span: MKCoordinateSpan(latitudeDelta: 2, longitudeDelta: 2))
    @Published var alertItem: AlertItem?
    @Published var timeToMasjid: Double?
    @Published var isCreatingNewMasjid = false
    
     var userLocationManager = UserLocationManager.shared
    @MainActor
     func getMasjids(with masjidManager: MasjidManager) {
        Task {
            do {
                masjidManager.masjids = try await CloudKitManager.shared.getAll(objects: .masjid)
            }
            catch {
                alertItem = AlertItem("tuff", "the warning is actually an issue", "yikes")
            }
        }
    }
    @MainActor
    func onAppear(with masjidManager: MasjidManager) {
        initLocationManager()
        checkLocationAuth()
        getMasjids(with: masjidManager)
    }
    
    private func initLocationManager() {
        userLocationManager.delegate = self
    }
    
    func focusUser(){
        if
            let userLocationCoord = userLocationManager.location?.coordinate
        {
            setFocus(userLocationCoord)
        }
    }
    
    
    func select(masjid: Masjid, for masjidManager: MasjidManager) {
        withAnimation(.easeInOut) {
            setFocus(CLLocationCoordinate2D(latitude: masjid.location.coordinate.latitude - 0.02, longitude: masjid.location.coordinate.longitude))
            masjidManager.selectedMasjid = masjid
        }
        masjidManager.calculateSecondsTo(masjid: masjid, from: userLocationManager)
    }
    
    
    private func setFocus(_ location : CLLocationCoordinate2D){
        let newLocation = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        withAnimation(.easeInOut){ [self] in
            let longMeters = 5_000.0
            let aspectRatio = CGFloat.relativeToScreen(.height, ratio: 1) / CGFloat.relativeToScreen(.width, ratio: 1)
            let latMeters = longMeters * aspectRatio
            region = MKCoordinateRegion(center: newLocation, latitudinalMeters: latMeters, longitudinalMeters: longMeters)
        }
    }
    
}

extension SMapViewModel: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuth()
    }
    
    private func checkLocationAuth() {
        switch userLocationManager.authorizationStatus {
            case .notDetermined:
                userLocationManager.requestAlwaysAuthorization()
            case .restricted:
                alertItem = AlertContext.genericErrorAlert // TODO: add custom alert message
            case .denied:
                alertItem = AlertContext.genericErrorAlert // TODO: add alert
            case .authorizedAlways, .authorizedWhenInUse:
                // nice
                // focusUser() ?
                break
            @unknown default:
                userLocationManager.requestAlwaysAuthorization()
        }
    }
    
}
