//
//  MasjidChangeRequest.swift
//  Sabeel
//
//  Created by Owais on 2023-08-07.
//

import CloudKit

struct MasjidChangeRequest {
    // create constants for cloudkit keys
    static let kname        = "name"
    static let kemail       = "email"
    static let kaddress     = "address"
    static let kphoneNumber = "phoneNumber"
    static let kwebsite     = "website"
    static let kprayerTimes = "prayerTimes"
    static let kyesVotes    = "yesVotes"
    static let knoVotes     = "noVotes"
    static let kvotesToPass = "votesToPass"
    
    // structure
    var record  : CKRecord
    var name        : String
    var email       : String?
    var address     : String
    var phoneNumber : String?
    var website     : String?
    var prayerTimes : CKRecord.Reference!
    var yesVotes    : Int = 0
    var noVotes     : Int = 0
    var votesToPass : Int = 3
}

extension MasjidChangeRequest: CKObject {

    // create init befcause we want to create it using a record
    init(record: CKRecord) {
        self.record  = record
        name        = record[MasjidChangeRequest.kname       ] as? String ?? "N/A"
        email       = record[MasjidChangeRequest.kemail      ] as? String
        address     = record[MasjidChangeRequest.kaddress    ] as? String ?? "N/A"
        phoneNumber = record[MasjidChangeRequest.kphoneNumber] as? String
        website     = record[MasjidChangeRequest.kwebsite    ] as? String
        prayerTimes = record[MasjidChangeRequest.kprayerTimes] as? CKRecord.Reference
        yesVotes    = record[MasjidChangeRequest.kyesVotes   ] as? Int ?? 0
        noVotes     = record[MasjidChangeRequest.knoVotes    ] as? Int ?? 0
        votesToPass = record[MasjidChangeRequest.kvotesToPass] as? Int ?? 3
    }
    // membawize
    init? (
        name        : String,
        email       : String?,
        address     : String,
        phoneNumber : String?,
        website     : String?,
        prayerTimes : PrayerTimes,
        yesVotes    : Int = 0,
        noVotes     : Int = 0,
        votesToPass : Int = 3
    ){
        let record = CKRecord(.changeRequest)
        record[MasjidChangeRequest.kname       ] = name
        record[MasjidChangeRequest.kemail      ] = email
        record[MasjidChangeRequest.kaddress    ] = address
        record[MasjidChangeRequest.kphoneNumber] = phoneNumber
        record[MasjidChangeRequest.kwebsite    ] = website
        record[MasjidChangeRequest.kprayerTimes] = prayerTimes.record.reference(.deleteSelf)
        record[MasjidChangeRequest.kyesVotes   ] = yesVotes
        record[MasjidChangeRequest.knoVotes    ] = noVotes
        record[MasjidChangeRequest.kvotesToPass] = votesToPass
        self.init(record: record)
    }
}
