//
//  CreateNewMasjidViewModel.swift
//  Sabeel
//
//  Created by Owais on 2023-08-14.
//

import SwiftUI
import CoreLocation

final class CreateNewMasjidViewModel: NSObject, ObservableObject {
    @Published var showNotEditedAlert                           = false
    @Published var selectedChangeRequest: MasjidChangeRequest?  = nil
    @Published var name                 : String                = ""
    @Published var address              : String                = ""
    @Published var email                : String                = ""
    @Published var phoneNumber          : String                = ""
    @Published var website              : String                = ""
    @Published var prayerTimes          : PrayerTimes           = PrayerTimes(fajr: "", dhuhr: "", asr: "", maghrib: "", isha: "", juma: [])
    
    var userLocationManager = UserLocationManager.shared
    @Published var isLoading: Bool = false
    @Published var alertItem: AlertItem?
    private func showLoadingView() { isLoading = true }
    private func hideLoadingView() { isLoading = false }
    private func load(completion: () -> Void) {
        showLoadingView()
        completion()
        hideLoadingView()
    }
    
    
    func createMasjid(){
        load {
            print("Loading")
            
        }
        print("...Done!")
    }
    

    func onAppear() { alertItem = AlertItem("Warning", "This Masjid will be created at your current location", "Dismiss") }
    
    @MainActor
    func createUnconfirmedMasjid() {
        // create instance for new masjid
        guard let usersLocation = userLocationManager.location else {
            alertItem = AlertContext.genericErrorAlert // TODO: we need your location to CREATE masajid (maybe ask one time)
            return
        }
        showLoadingView()
        Task {
            do {
                let newMasjidPrayerTimes = PrayerTimes(fajr: prayerTimes.fajr, dhuhr: prayerTimes.dhuhr, asr: prayerTimes.asr, maghrib: prayerTimes.maghrib, isha: prayerTimes.isha, juma: prayerTimes.juma)
                let changeReq = MasjidChangeRequest(name: name, email: email, address: address, phoneNumber: phoneNumber, website: website, prayerTimes: newMasjidPrayerTimes, location: usersLocation )// userLocation
                let newMasjid = Masjid(name: "", email: "", address: "", phoneNumber: "", website: "", prayerTimes: newMasjidPrayerTimes, location: usersLocation, changeRequest: changeReq, isConfirmed: false)
                // if valid form submission
                
                // save all 3
                try await CloudKitManager.shared.batchSave(records: [newMasjid.record, newMasjidPrayerTimes.record,changeReq.record])
                // success
                alertItem = AlertContext.genericSuccess // we were unable to save your masjid Request
            hideLoadingView()
            }
            catch {
                hideLoadingView()
                alertItem = AlertContext.genericErrorAlert // we were unable to save your masjid Request
            }
        }
    }
    
}

extension CreateNewMasjidViewModel: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuth()
    }
    
    private func checkLocationAuth() {
        switch userLocationManager.authorizationStatus {
            case .notDetermined:
                userLocationManager.requestAlwaysAuthorization()
            case .restricted:
                alertItem = AlertContext.genericErrorAlert // TODO: add custom alert message
            case .denied:
                alertItem = AlertContext.genericErrorAlert // TODO: add alert
            case .authorizedAlways, .authorizedWhenInUse:
                // nice
                // focusUser() ?
                break
            @unknown default:
                userLocationManager.requestAlwaysAuthorization()
        }
    }
    
}
