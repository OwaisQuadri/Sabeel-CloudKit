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
    @Published var alertItem: AlertItem?
    
    var userLocationManager: CLLocationManager?
    
    func onAppear(with locationManager: LocationManager){
        initLocationManager()
        getMasjids(with: locationManager)
        print(locationManager.masjids)
    }
    
    func initLocationManager() {
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
                alertItem = AlertContext.genericErrorAlert // TODO: add custom alert message
            case .denied:
                alertItem = AlertContext.genericErrorAlert // TODO: add alert
            case .authorizedAlways, .authorizedWhenInUse:
                // nice
                break
            @unknown default:
                break
        }
    }
    func getMasjids(with locationManager: LocationManager){
        CloudKitManager.shared.read(recordType: .masjid, predicate: NSPredicate(value: true)) {masjids in
            DispatchQueue.main.async {
                locationManager.masjids = masjids
            }
        }
    }
}

extension SMapViewModel: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuth()
    }
}
