//
//  Constants.swift
//  Sabeel
//
//  Created by Owais on 2023-08-09.
//

import CloudKit
enum SabeelRecordType: String {
    case masjid = "Masjid"
    case profile = "SabeelProfile"
    case changeRequest = "MasjidUpdate"
    case prayerStats = "PrayerStats"
    case prayerTimes = "PrayerTimings"
    case users = "Users"
}

enum UserDefaultsKey {
    static let kHasSeenOnboardingView = "hasSeenOnboardingView"
}

enum Constants {
    static let numberOfVotesToPassMasjidChangeRequest = 1 // 5 in future
    static let jumaTimesTitle = "Juma Times"
}
