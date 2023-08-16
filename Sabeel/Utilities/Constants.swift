//
//  Constants.swift
//  Sabeel
//
//  Created by Owais on 2023-08-09.
//
// PROJECT REUSABLE

import CloudKit

// CloudKit
enum SabeelRecordType: String {
    case masjid = "Masjid"
    case profile = "SabeelProfile"
    case changeRequest = "MasjidUpdate"
    case prayerStats = "PrayerStats"
    case prayerTimes = "PrayerTimings"
    case users = "Users"
}

// UserDefaults (@AppStorage)
enum UserDefaultsKey {
    static let kHasSeenOnboardingView = "hasSeenOnboardingView"
    static let isFirstLoad = "isFirstLoad"
}

enum Constants {
    // MARK: Ints
    static let numberOfVotesToPassMasjidChangeRequest   :    Int = 1 // 5 in future
    static let maxNumberOfJumas                         :    Int = 5
    // MARK: Strings
    static let jumaTimesTitle                           : String = "Juma Times"
    static let prayerTimesTitle                         : String = "Prayer Times"
}
