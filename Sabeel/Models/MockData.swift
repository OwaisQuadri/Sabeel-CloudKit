//
//  MockData.swift
//  Sabeel
//
//  Created by Owais on 2023-08-09.
//

import CloudKit

struct MockData {
    static var location = CLLocation(latitude: 43.8924901, longitude: -78.8649466)
    static var masjid: CKRecord {
        let record = CKRecord(.masjid)
        record[Masjid.kName]        = "Oshawa Masjid"
        record[Masjid.kEmail]       = "owaisquadri01+Sabeel@gmail.com"
        record[Masjid.kAddress]     = "23 Lloyd St, Oshawa, ON L1H 1X2"
        record[Masjid.kPhoneNumber] = "2899438996"
        record[Masjid.kWebsite]     = "www.google.com"
        record[Masjid.kLocation]    = CLLocation(latitude: 43.8924901, longitude: -78.8649466)
        let prayerTimes = PrayerTimes(record: MockData.prayerTimes)
        record[Masjid.kPrayerTimes] = prayerTimes.record.reference(.deleteSelf)
        return record
    }
    static var masjidWithChangeRequest: CKRecord {
        let record = CKRecord(.masjid)
        record[Masjid.kName]        = "Oshawa Masjid"
        record[Masjid.kEmail]       = "owaisquadri01+Sabeel@gmail.com"
        record[Masjid.kAddress]     = "23 Lloyd St, Oshawa, ON L1H 1X2"
        record[Masjid.kPhoneNumber] = "2899438996"
        record[Masjid.kWebsite]     = "www.google.com"
        record[Masjid.kLocation]    = CLLocation(latitude: 43.8924901, longitude: -78.8649466)
        let prayerTimes = PrayerTimes(record: MockData.prayerTimes)
        record[Masjid.kPrayerTimes] = prayerTimes.record.reference(.deleteSelf)
        let changeReq = MasjidChangeRequest(name: "Oshawa Mosque", email: "owaisquadri01+Sabeel@gmail.com", address: "some random place in canada", phoneNumber: "2899438996", website: "www.anothersite.com", prayerTimes: PrayerTimes(record: MockData.changeRequestPrayerTimes),
                                            location: CLLocation(latitude: 43.8924901, longitude: -78.8649466))
        record[Masjid.kChangeRequest] = changeReq.record.reference(.deleteSelf)
        
        return record
    }
    static var prayerTimes: CKRecord {
        let record = CKRecord(.prayerTimes)
        record[PrayerTimes.kFajr]    = "5:25pm"
        record[PrayerTimes.kDhuhr]   = "5:25pm"
        record[PrayerTimes.kAsr]     = "5:25pm"
        record[PrayerTimes.kMaghrib] = "5:25pm"
        record[PrayerTimes.kIsha]    = "5:25pm"
        record[PrayerTimes.kJuma]    = ["5:25pm"]
        return record
    }
    
    static var changeRequestPrayerTimes: CKRecord {
        let record = CKRecord(.prayerTimes)
        record[PrayerTimes.kFajr]    = "5:25am"
        record[PrayerTimes.kDhuhr]   = "5:25am"
        record[PrayerTimes.kAsr]     = "5:25am"
        record[PrayerTimes.kMaghrib] = "5:25am"
        record[PrayerTimes.kIsha]    = "5:25am"
        record[PrayerTimes.kJuma]    = ["5:25am","5:25am"]
        return record
    }
    
    static var prayerStats: CKRecord {
        let record = CKRecord(.prayerStats)
        record[PrayerStats.kfajrAttended    ] = 1
        record[PrayerStats.kfajrMissed      ] = 0
        record[PrayerStats.kdhuhrAttended   ] = 1
        record[PrayerStats.kdhuhrMissed     ] = 1
        record[PrayerStats.kasrAttended     ] = 1
        record[PrayerStats.kasrMissed       ] = 0
        record[PrayerStats.kmaghribAttended ] = 1
        record[PrayerStats.kmaghribMissed   ] = 0
        record[PrayerStats.kishaAttended    ] = 1
        record[PrayerStats.kishaMissed      ] = 0
        return record
    }
}
