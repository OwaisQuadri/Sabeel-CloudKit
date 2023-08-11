//
//  PrayerStats.swift
//  Sabeel
//
//  Created by Owais on 2023-08-09.
//

import CloudKit

struct PrayerStats {
    static let kfajrAttended    = "fajrAttended"
    static let kfajrMissed      = "fajrMissed"
    static let kdhuhrAttended   = "dhuhrAttended"
    static let kdhuhrMissed     = "dhuhrMissed"
    static let kasrAttended     = "asrAttended"
    static let kasrMissed       = "asrMissed"
    static let kmaghribAttended = "maghribAttended"
    static let kmaghribMissed   = "maghribMissed"
    static let kishaAttended    = "ishaAttended"
    static let kishaMissed      = "ishaMissed"
        
    
    var record          : CKRecord
    
    var fajrAttended    : Double
    var fajrMissed      : Double
    var dhuhrAttended   : Double
    var dhuhrMissed     : Double
    var asrAttended     : Double
    var asrMissed       : Double
    var maghribAttended : Double
    var maghribMissed   : Double
    var ishaAttended    : Double
    var ishaMissed      : Double
}

extension PrayerStats: CKObject {
    init(record: CKRecord) {
        
        self.record = record
        fajrAttended    = record[PrayerStats.kfajrAttended    ] as? Double ?? 0
        fajrMissed      = record[PrayerStats.kfajrMissed      ] as? Double ?? 0
        dhuhrAttended   = record[PrayerStats.kdhuhrAttended   ] as? Double ?? 0
        dhuhrMissed     = record[PrayerStats.kdhuhrMissed     ] as? Double ?? 0
        asrAttended     = record[PrayerStats.kasrAttended     ] as? Double ?? 0
        asrMissed       = record[PrayerStats.kasrMissed       ] as? Double ?? 0
        maghribAttended = record[PrayerStats.kmaghribAttended ] as? Double ?? 0
        maghribMissed   = record[PrayerStats.kmaghribMissed   ] as? Double ?? 0
        ishaAttended    = record[PrayerStats.kishaAttended    ] as? Double ?? 0
        ishaMissed      = record[PrayerStats.kishaMissed      ] as? Double ?? 0
    }
    init? (
        fajrAttended    : Double,
        fajrMissed      : Double,
        dhuhrAttended   : Double,
        dhuhrMissed     : Double,
        asrAttended     : Double,
        asrMissed       : Double,
        maghribAttended : Double,
        maghribMissed   : Double,
        ishaAttended    : Double,
        ishaMissed      : Double
    ){
        let record = CKRecord(.prayerStats)
        
        record[PrayerStats.kfajrAttended    ] = fajrAttended
        record[PrayerStats.kfajrMissed      ] = fajrMissed
        record[PrayerStats.kdhuhrAttended   ] = dhuhrAttended
        record[PrayerStats.kdhuhrMissed     ] = dhuhrMissed
        record[PrayerStats.kasrAttended     ] = asrAttended
        record[PrayerStats.kasrMissed       ] = asrMissed
        record[PrayerStats.kmaghribAttended ] = maghribAttended
        record[PrayerStats.kmaghribMissed   ] = maghribMissed
        record[PrayerStats.kishaAttended    ] = ishaAttended
        record[PrayerStats.kishaMissed      ] = ishaMissed
        
        self.init(record: record)
    }
    init (){
        let record = CKRecord(.prayerStats)
        
        record[PrayerStats.kfajrAttended    ] = 0
        record[PrayerStats.kfajrMissed      ] = 0
        record[PrayerStats.kdhuhrAttended   ] = 0
        record[PrayerStats.kdhuhrMissed     ] = 0
        record[PrayerStats.kasrAttended     ] = 0
        record[PrayerStats.kasrMissed       ] = 0
        record[PrayerStats.kmaghribAttended ] = 0
        record[PrayerStats.kmaghribMissed   ] = 0
        record[PrayerStats.kishaAttended    ] = 0
        record[PrayerStats.kishaMissed      ] = 0
        
        self.init(record: record)
    }
}
