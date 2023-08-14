//
//  LocationManager.swift
//  Sabeel
//
//  Created by Owais on 2023-08-10.
//
// PROJECT REUSABLE: how to create an env object
import MapKit
import SwiftUI

final class MasjidManager: ObservableObject {
    @Published var masjids: [Masjid] = []
    @Published var selectedMasjid: Masjid? = nil
    @Published var secondsToMasjid: TimeInterval?
    
    init(_ masjids: [Masjid] = [], selected masjid: Masjid? = nil) {
        self.masjids = masjids
        self.selectedMasjid = masjid
    }
    
    func getMasjids(){
            CloudKitManager.shared.read(recordType: .masjid, predicate: NSPredicate(value: true)) {masjids in
                onMainThread { [self] in
                    self.masjids = masjids
                }
        }
    }
    
    func calculateSecondsTo(masjid: Masjid, from userLocationManager: CLLocationManager?) {
        guard
            let masjidLocation = selectedMasjid?.location,
            let userLocationManager = userLocationManager,
            let userLocation = userLocationManager.location
        else { return }
        let userPlacemark = MKPlacemark(coordinate: userLocation.coordinate )
        let req = MKDirections.Request()
        req.source = MKMapItem(placemark: userPlacemark)
        req.destination = MKMapItem(placemark: MKPlacemark(coordinate: masjidLocation.coordinate))
        let directions = MKDirections(request: req)
        directions.calculateETA { [self] res, err in
                guard let res = res, err == nil else { return }
                secondsToMasjid = res.expectedTravelTime != 0 ? res.expectedTravelTime : nil
        }
    }
    
}
