//
//  SMapViewModel.swift
//  Sabeel
//
//  Created by Owais on 2023-08-10.
//

import SwiftUI
import MapKit

final class SMapViewModel: NSObject, ObservableObject {
    @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 43, longitude: -79) , span: MKCoordinateSpan(latitudeDelta: 0.3, longitudeDelta: 0.3)) // TODO: Ideally we want the users location
    @Published var alertItem: AlertItem?
    
    var userLocationManager: CLLocationManager?
    
    func onAppear(with locationManager: MasjidManager){
        initLocationManager()
        checkLocationAuth()
        getMasjids(with: locationManager)
    }
    
    func select(masjid: Masjid, for masjidManager: MasjidManager) {
        withAnimation(.easeInOut) {
            setFocus(masjid.location)
            masjidManager.selectedMasjid = masjid
        }
    }
    
    func initLocationManager() {
        userLocationManager = CLLocationManager()
        userLocationManager!.delegate = self
    }
    
    func setFocus(_ location : CLLocation){
        let newLocation = CLLocationCoordinate2D(latitude: location.coordinate.latitude - 0.025, longitude: location.coordinate.longitude)
        withAnimation(.easeInOut){
            region.center = newLocation
            region.span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
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
                if let userLocationCoord = userLocationManager.location?.coordinate {
                    region.center = userLocationCoord
                }
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
}

extension SMapViewModel: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuth()
    }
}
