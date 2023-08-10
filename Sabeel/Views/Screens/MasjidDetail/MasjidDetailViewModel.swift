//
//  MasjidDetailViewModel.swift
//  Sabeel
//
//  Created by Owais on 2023-08-10.
//

import SwiftUI

final class MasjidDetailViewModel: ObservableObject {
    
    @Published var prayerTimes: PrayerTimes?
    @Published var showContactInfo: Bool = false
    @Published var showChangeTimingsView: Bool = false
    @Published var isShowingThisView: Bool = true
    
    func dismiss(with locationManager: LocationManager) {
        withAnimation(.easeInOut) {
            isShowingThisView = false
            locationManager.selectedMasjid = nil
        }
    }
    
    func fetchPrayerTimes(for locationManager: LocationManager) {
        
        if let selectedMasjid = locationManager.selectedMasjid {
            CloudKitManager.shared.fetch(recordType: .prayerTimes, predicate: NSPredicate(format: "recordID = %@", selectedMasjid.prayerTimes.recordID) , resultsLimit: 1) { (prayerTimes: [PrayerTimes]) in
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
