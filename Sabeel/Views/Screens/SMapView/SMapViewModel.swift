//
//  SMapViewModel.swift
//  Sabeel
//
//  Created by Owais on 2023-08-10.
//

import SwiftUI
import MapKit

final class SMapViewModel: NSObject, ObservableObject {
    @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 43.8924901, longitude: -78.8649466), span: MKCoordinateSpan(latitudeDelta: 0.3, longitudeDelta: 0.3)) // TODO: Ideally we want the users location
    
    var userLocationManager: CLLocationManager?
    
    func checkIfLocationServicesEnabled() {
        if CLLocationManager.locationServicesEnabled() {
            userLocationManager = CLLocationManager()
//            userLocationManager?.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            userLocationManager!.delegate = self
        } else {
            
        }
    }
    
    private func checkLocationAuth() {
        guard let userLocationManager = userLocationManager else { return }
        switch userLocationManager.authorizationStatus {
            case .notDetermined:
                userLocationManager.requestWhenInUseAuthorization()
            case .restricted:
                print("restricted")
            case .denied:
                print("denied, goto settings to change")
            case .authorizedAlways, .authorizedWhenInUse:
                // nice
                break
            @unknown default:
                break
        }
    }
    func getMasjids(for locationManager: LocationManager){
        CloudKitManager.shared.fetch(recordType: .masjid, predicate: NSPredicate(value: true), resultsLimit: 1) {items in
            DispatchQueue.main.async {
                locationManager.masjids = items
            }
        }
    }
    
}

extension SMapViewModel: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuth()
    }
}
