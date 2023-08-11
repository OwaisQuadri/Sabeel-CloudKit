//
//  MasjidDetailViewModel.swift
//  Sabeel
//
//  Created by Owais on 2023-08-10.
//

import SwiftUI
import MapKit

final class MasjidDetailViewModel: ObservableObject {
    
    @Published var prayerTimes: PrayerTimes?
    @Published var showContactInfo: Bool = false
    @Published var showChangeTimingsView: Bool = false
    @Published var isShowingThisView: Bool = true
    @Published var alertItem: AlertItem?
    
    func dismiss(with locationManager: LocationManager) {
        withAnimation(.easeInOut) {
            isShowingThisView = false
            locationManager.selectedMasjid = nil
        }
    }
    func getDirectionsToLocation(with locationManager: LocationManager) {
        guard let masjid = locationManager.selectedMasjid else { return }
        let placemark = MKPlacemark(coordinate: masjid.location.coordinate)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = masjid.name
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDefault])
    }
    
    func sendEmail(with locationManager: LocationManager) {
        guard
            let masjidEmail = locationManager.selectedMasjid?.email,
            let url = URL(string: "mailto://\(masjidEmail)")
        else {
            alertItem = AlertContext.genericErrorAlert
            return
        }
        UIApplication.shared.open(url)
    }
    
    func callMasjid(with locationManager: LocationManager) {
        guard
            let masjidPhoneNumber = locationManager.selectedMasjid?.phoneNumber,
            let url = URL(string: "tel://\(masjidPhoneNumber)")
        else {
            alertItem = AlertContext.genericErrorAlert
            return
        }
        UIApplication.shared.open(url)
    }
    
    func visitWebsite(with locationManager: LocationManager) {
        guard
            let masjidWebsite = locationManager.selectedMasjid?.website,
            let url = URL(string: masjidWebsite)
        else {
            alertItem = AlertContext.genericErrorAlert
            return
        }
        UIApplication.shared.open(url)
    }
    
    func fetchPrayerTimes(for locationManager: LocationManager) {
        
        if let selectedMasjid = locationManager.selectedMasjid {
            CloudKitManager.shared.read(recordType: .prayerTimes, predicate: NSPredicate(format: "recordID = %@", selectedMasjid.prayerTimes.recordID) , resultsLimit: 1) { (prayerTimes: [PrayerTimes]) in
                DispatchQueue.main.async {
                    if prayerTimes.count == 1 {
                        print(prayerTimes)
                        self.prayerTimes = prayerTimes[0]
                    }
                }
            }
        }
    }
    
}
