//
//  SMapViewModel.swift
//  Sabeel
//
//  Created by Owais on 2023-08-10.
//

import SwiftUI
import MapKit

final class SMapViewModel: NSObject, ObservableObject {
    @Published var region: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 43.95, longitude: -79), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    @Published var alertItem: AlertItem?
    
    private var userLocationManager: CLLocationManager?
    
    
    func onAppear(with masjidManager: MasjidManager) {
        initLocationManager()
        checkLocationAuth()
        getMasjids(with: masjidManager)
    }
    
    
    func reload(with masjidManager: MasjidManager){
        onAppear(with: masjidManager)
    }
    
    
    private func initializeRegion () { focusUser() }
    
    
    private func initLocationManager() {
        userLocationManager = CLLocationManager()
        userLocationManager!.delegate = self
    }
    
    func focusUser(){
        if
            let userLocationCoord = userLocationManager?.location?.coordinate
        {
            setFocus(userLocationCoord)
        }
    }
    private func checkLocationAuth() {
        guard let userLocationManager = userLocationManager else {
            alertItem = AlertItem("Err", "unable to use any location services. Please update your iPhone settings", "Dismiss")
            return }
        switch userLocationManager.authorizationStatus {
            case .notDetermined:
                userLocationManager.requestAlwaysAuthorization()
            case .restricted:
                alertItem = AlertContext.genericErrorAlert // TODO: add custom alert message
            case .denied:
                alertItem = AlertContext.genericErrorAlert // TODO: add alert
            case .authorizedAlways, .authorizedWhenInUse:
                // nice
                focusUser()
                break
            @unknown default:
                userLocationManager.requestAlwaysAuthorization()
        }
    }
    
    
    func getMasjids(with masjidManager: MasjidManager){
        withAnimation(.easeInOut) {
            CloudKitManager.shared.read(recordType: .masjid, predicate: NSPredicate(value: true)) {masjids in
                DispatchQueue.main.async {
                    masjidManager.masjids = masjids
                }
            }
        }
    }
    
    
    func select(masjid: Masjid, for masjidManager: MasjidManager) {
        withAnimation(.easeInOut) {
            setFocus(CLLocationCoordinate2D(latitude: masjid.location.coordinate.latitude - 0.005, longitude: masjid.location.coordinate.longitude))
            masjidManager.selectedMasjid = masjid
        }
    }
    
    
    private func setFocus(_ location : CLLocationCoordinate2D){
        let newLocation = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        withAnimation(.easeInOut){ [self] in
                region = MKCoordinateRegion(center: newLocation, latitudinalMeters: 2_000, longitudinalMeters: 2_000)
        }
    }
    
}

extension SMapViewModel: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuth()
    }
    
}
