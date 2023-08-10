//
//  PrayerTimes.swift
//  Sabeel
//
//  Created by Owais on 2023-08-07.
//

import CloudKit

struct PrayerTimes : Equatable {
    // create constants for cloudkit keys
    static let kFajr    = "fajr"
    static let kDhuhr   = "dhuhr"
    static let kAsr     = "asr"
    static let kMaghrib = "maghrib"
    static let kIsha    = "isha"
    static let kJuma    = "juma"
    // structure
    var record : CKRecord
    var fajr       : String
    var dhuhr      : String
    var asr        : String
    var maghrib    : String
    var isha       : String   
    var juma       : [String]
}
extension PrayerTimes: CKObject {
    // create extended init befcause we also want to create it using a record
    init(record: CKRecord) {
        self.record = record
        fajr       = record[PrayerTimes.kFajr   ] as? String ?? "N/A"
        dhuhr      = record[PrayerTimes.kDhuhr  ] as? String ?? "N/A"
        asr        = record[PrayerTimes.kAsr    ] as? String ?? "N/A"
        maghrib    = record[PrayerTimes.kMaghrib] as? String ?? "N/A"
        isha       = record[PrayerTimes.kIsha   ] as? String ?? "N/A"
        juma       = record[PrayerTimes.kJuma   ] as? [String] ?? []
    }
    init(
        fajr       : String,
        dhuhr      : String,
        asr        : String,
        maghrib    : String,
        isha       : String,
        juma       : [String]
    ) {
        let record = CKRecord(.prayerTimes)
        
        record[PrayerTimes.kFajr   ] = fajr
        record[PrayerTimes.kDhuhr  ] = dhuhr
        record[PrayerTimes.kAsr    ] = asr
        record[PrayerTimes.kMaghrib] = maghrib
        record[PrayerTimes.kIsha   ] = isha
        record[PrayerTimes.kJuma   ] = juma
        
        self.init(record: record)
    }
}
