//
//  CreateNewMasjidViewModel.swift
//  Sabeel
//
//  Created by Owais on 2023-08-14.
//

import SwiftUI

final class CreateNewMasjidViewModel: ObservableObject {
    @Published var showNotEditedAlert                           = false
    @Published var selectedChangeRequest: MasjidChangeRequest?  = nil
    @Published var name                 : String                = ""
    @Published var address              : String                = ""
    @Published var email                : String                = ""
    @Published var phoneNumber          : String                = ""
    @Published var website              : String                = ""
    @Published var prayerTimes          : PrayerTimes           = PrayerTimes(fajr: "", dhuhr: "", asr: "", maghrib: "", isha: "", juma: [])
    
    
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
            do {
                sleep(3)
            }
        }
        print("...Done!")
    }
    

    func onAppear() { }
}

////  VM if subview (for alerts)
//final class CreateNewMasjidViewModel: ObservableObject {
//
//    @Published var isLoading: Bool = false
//    @Binding var alertItem: AlertItem?
//    private func showLoadingView() { isLoading = true }
//    private func hideLoadingView() { isLoading = false }
//    private func load(completion: () -> Void) {
//        showLoadingView()
//        completion()
//        hideLoadingView()
//    }
//
//    init(_ alertItem: Binding<AlertItem?>) {
//        self._alertItem = alertItem
//    }
//
//
//    func onAppear() { }
//}
