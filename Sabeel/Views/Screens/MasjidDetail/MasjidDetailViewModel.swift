//
//  MasjidDetailViewModel.swift
//  Sabeel
//
//  Created by Owais on 2023-08-10.
//

import SwiftUI
import MapKit

final class MasjidDetailViewModel: NSObject, ObservableObject {
    
    @Published var prayerTimes: PrayerTimes?
    @Published var showContactInfo: Bool = false
    @Published var showChangeTimingsView: Bool = false
    @Published var isShowingThisView: Bool = true
    let timeToMasjidString: String = "Go"
    
    
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
    
    
    func fetchMasjidMetaData(for locationManager: MasjidManager) {
        if let selectedMasjid = locationManager.selectedMasjid {
            CloudKitManager.shared.read(recordType: .masjid, predicate: NSPredicate(format: "recordID = %@", selectedMasjid.record.recordID)) {(masjids: [Masjid]) in
                onMainThread {
                    if masjids.count == 1 {
                        locationManager.selectedMasjid = masjids[0]
                    }
                }
            }
        }
    }
    
    func fetchPrayerTimes(for locationManager: MasjidManager) {
        
        if let selectedMasjid = locationManager.selectedMasjid {
            CloudKitManager.shared.read(recordType: .prayerTimes, predicate: NSPredicate(format: "recordID = %@", selectedMasjid.prayerTimes.recordID) , resultsLimit: 1) { (prayerTimes: [PrayerTimes]) in
                onMainThread { [self] in
                    if prayerTimes.count == 1 {
                        self.prayerTimes = prayerTimes[0]
                    }
                }
            }
        }
    }
    
    @Published var isLoading: Bool = false
    @Binding var alertItem: AlertItem?
    private func showLoadingView() { isLoading = true }
    private func hideLoadingView() { isLoading = false }
    var nextPrayer: Date? {
        guard let prayerTimes = prayerTimes else { return nil }
        let today = Date.now
        var prayers = [prayerTimes.fajr, prayerTimes.asr, prayerTimes.maghrib, prayerTimes.isha ]
        if today.formatted(Date.FormatStyle().weekday(.wide)) == "Friday" { prayers.append(contentsOf: prayerTimes.juma) } else { prayers.append(prayerTimes.dhuhr) }
        let times: [Date] = prayers.compactMap( { timeString in
            let calendar = Calendar(identifier: .gregorian)
            let todayComponents = calendar.dateComponents([.day,.year,.month], from: today)
            if let parsedTime = Date.from(string: timeString) {
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
        })
        return times.min(by: {
            return $0.distance(to: today ).magnitude < $1.distance(to: today ).magnitude
        })
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
