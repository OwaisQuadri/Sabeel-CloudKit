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
    
    func onAppear(with locationManager: MasjidManager) {
        updateInfo(with: locationManager)
    }
    
    
    func dismiss(with locationManager: MasjidManager) { locationManager.selectedMasjid = nil }
    
    
    func getDirectionsToLocation(with locationManager: MasjidManager) {
        guard let masjid = locationManager.selectedMasjid else { return }
        let placemark = MKPlacemark(coordinate: masjid.location.coordinate)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = masjid.name
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDefault])
    }
    
    func sendEmail(with locationManager: MasjidManager) {
        guard
            let masjidEmail = locationManager.selectedMasjid?.email,
            let url = URL(string: "mailto:\(masjidEmail)")
        else {
            alertItem = AlertContext.genericErrorAlert
            return
        }
        UIApplication.shared.open(url)
    }
    
    func callMasjid(with locationManager: MasjidManager) {
        guard
            let masjidPhoneNumber = locationManager.selectedMasjid?.phoneNumber,
            let url = URL(string: "tel://\(masjidPhoneNumber)")
        else {
            alertItem = AlertContext.genericErrorAlert
            return
        }
        UIApplication.shared.open(url)
    }
    
    func visitWebsite(with locationManager: MasjidManager) {
        guard
            let masjidWebsite = locationManager.selectedMasjid?.website,
            let url = URL(string: "https://\(masjidWebsite)")
        else {
            alertItem = AlertContext.genericErrorAlert
            return
        }
        UIApplication.shared.open(url)
    }
    func updateInfo(with locationManager: MasjidManager) {
        fetchMasjidMetaData(for: locationManager)
        fetchPrayerTimes(for: locationManager)
    }
    
    func fetchMasjidMetaData(for locationManager: MasjidManager) {
        if let selectedMasjid = locationManager.selectedMasjid {
            CloudKitManager.shared.read(recordType: .masjid, predicate: NSPredicate(format: "recordID = %@", selectedMasjid.record.recordID)) {(masjids: [Masjid]) in
                DispatchQueue.main.async {
                    if masjids.count == 1 {
                        locationManager.selectedMasjid = masjids[0]
                    }
                }
            }
        }
    }
    
    func fetchPrayerTimes(for locationManager: MasjidManager) {
        
        if let selectedMasjid = locationManager.selectedMasjid {
            showLoadingView()
            CloudKitManager.shared.read(recordType: .prayerTimes, predicate: NSPredicate(format: "recordID = %@", selectedMasjid.prayerTimes.recordID) , resultsLimit: 1) { (prayerTimes: [PrayerTimes]) in
                DispatchQueue.main.async { [self] in
                    self.hideLoadingView()
                    if prayerTimes.count == 1 {
                        self.prayerTimes = prayerTimes[0]
                    }
                }
            }
        }
    }
    
    @Published var isLoading: Bool = true
    private func showLoadingView() { isLoading = true }
    private func hideLoadingView() { isLoading = false }
    
}
