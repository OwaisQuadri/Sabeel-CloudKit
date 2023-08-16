//
//  MasjidDetailViewModel.swift
//  Sabeel
//
//  Created by Owais on 2023-08-10.
//

import SwiftUI
import MapKit

@MainActor final class MasjidDetailViewModel: NSObject, ObservableObject {
    
    @Published var prayerTimes: PrayerTimes?
    @Published var showContactInfo: Bool = false
    @Published var showChangeTimingsView: Bool = false
    @Published var isShowingThisView: Bool = true
    let timeToMasjidString: String = "View on Map"
    
    
    func onAppear(with locationManager: MasjidManager) {
        load {
            updateInfo(with: locationManager)
        }
    }
    
    
    func dismiss(with locationManager: MasjidManager) { withAnimation(.easeInOut) { locationManager.selectedMasjid = nil } }
    
    
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
            alertItem = AlertContext.unableToSendEmail
            return
        }
        UIApplication.shared.open(url)
    }
    
    func callMasjid(with locationManager: MasjidManager) {
        guard
            let masjidPhoneNumber = locationManager.selectedMasjid?.phoneNumber,
            let url = URL(string: "tel://\(masjidPhoneNumber)")
        else {
            alertItem = AlertContext.unableToMakePhoneCall
            return
        }
        UIApplication.shared.open(url)
    }
    
    func visitWebsite(with locationManager: MasjidManager) {
        guard
            let masjidWebsite = locationManager.selectedMasjid?.website,
            let url = URL(string: "https://\(masjidWebsite)")
        else {
            alertItem = AlertContext.unableToOpenWebsiteURL
            return
        }
        UIApplication.shared.open(url)
    }
    func updateInfo(with masjidManager: MasjidManager) {
        fetchMasjidMetaData(for: masjidManager)
        fetchPrayerTimes(for: masjidManager)
    }
    
    
    func fetchMasjidMetaData(for locationManager: MasjidManager) { // redundant?
        if let selectedMasjid = locationManager.selectedMasjid {
            Task {
                do {
                    let masjids = try await CloudKitManager.shared.get(object: .masjid, from: selectedMasjid.record.recordID) as [Masjid]
                    if masjids.isEmpty {
                        locationManager.selectedMasjid = nil
                    }
                    else {
                        locationManager.selectedMasjid = masjids[0]
                    }
                    
                }
            }
        }
    }
    
    func fetchPrayerTimes(for locationManager: MasjidManager) {
        
        if let selectedMasjid = locationManager.selectedMasjid {
            Task {
                do {
                    self.prayerTimes = try await CloudKitManager.shared.get(object: .prayerTimes, from: selectedMasjid.prayerTimes.recordID)[0] as PrayerTimes
                }
            }
        }
    }
    
    @Published var isLoading: Bool = false
    @Binding var alertItem: AlertItem?
    private func showLoadingView() { isLoading = true }
    private func hideLoadingView() { isLoading = false }
    
    func time(for prayer: Prayer) -> Date? {
        guard let prayerTimes else { return nil }
        let today = Date.now
        let calendar = Calendar(identifier: .gregorian)
        let todayComponents = calendar.dateComponents([.day,.year,.month], from: today)
        let isJuma = today.formatted(Date.FormatStyle().weekday(.wide)) == "Friday"
        var whichPrayer: String
        switch prayer {
            case .fajr:
                whichPrayer = prayerTimes.fajr
            case .dhuhr:
                whichPrayer = prayerTimes.dhuhr
                if isJuma { return nil }
            case .asr:
                whichPrayer = prayerTimes.asr
            case .maghrib:
                whichPrayer = prayerTimes.maghrib
            case .isha:
                whichPrayer = prayerTimes.isha
            case .juma(let index):
                whichPrayer = prayerTimes.juma[index]
                if !isJuma { return nil }
        }
            
            if let parsedTime = Date.from(string: whichPrayer) {
                let currentPrayerDateComponents = calendar.dateComponents([.hour, .minute], from: parsedTime)
                let time = calendar.date(from: DateComponents(
                    year: todayComponents.year,
                    month: todayComponents.month,
                    day: todayComponents.day,
                    hour: currentPrayerDateComponents.hour,
                    minute: currentPrayerDateComponents.minute
                ))
                return time
            }
            return nil
    }
    
    func isLate(for prayer: Prayer) -> Bool? {
        guard
            let prayerTime = time(for: prayer)
        else { return nil }
        let today = Date.now
        return today > prayerTime
    }
    
    func departAtTime(for prayer: Prayer, with masjidManager: MasjidManager) -> Date? {
        guard let secondsToMasjid = masjidManager.secondsToMasjid, let prayerTime = time(for: prayer) else {
            return nil
        }
        return prayerTime.addingTimeInterval(secondsToMasjid * -1)
    }
    
    func load(completion: () -> Void) {
        showLoadingView()
        completion()
        hideLoadingView()
    }
    
    init(_ alertItem: Binding<AlertItem?>) {
        self._alertItem = alertItem
        super.init()
    }
    
}
enum Prayer{
    case fajr, dhuhr, asr, maghrib, isha, juma(Int)
}
