//
//  MasjidChangeRequest.swift
//  Sabeel
//
//  Created by Owais on 2023-08-07.
//

import CloudKit

struct MasjidChangeRequest {
    // create constants for cloudkit keys
    static let kname                    = "name"
    static let kemail                   = "email"
    static let kaddress                 = "address"
    static let kphoneNumber             = "phoneNumber"
    static let kwebsite                 = "website"
    static let kprayerTimes             = "prayerTimes"
    static let kuserRecordIdVotedYes    = "userRecordIdVotedYes"
    static let kuserRecordIdVotedNo     = "userRecordIdVotedNo"
    static let klocation                = "location"
    static let kvotesToPass             = "votesToPass"
    
    
    // structure
    var record                  : CKRecord
    
    var name                    : String
    var email                   : String?
    var address                 : String
    var phoneNumber             : String?
    var website                 : String?
    var prayerTimes             : CKRecord.Reference!
    var userRecordIdVotedYes    : [String]
    var userRecordIdVotedNo     : [String]
    var votesToPass             : Int
    var location                : CLLocation!
}

extension MasjidChangeRequest: CKObject {

    // create init befcause we want to create it using a record
    init(record: CKRecord) {
        self.record             = record
        name                    = record[MasjidChangeRequest.kname                ] as? String ?? "N/A"
        email                   = (record[MasjidChangeRequest.kemail               ] as? String)
        address                 = record[MasjidChangeRequest.kaddress             ] as? String ?? "N/A"
        phoneNumber             = (record[MasjidChangeRequest.kphoneNumber         ] as? String)
        website                 = (record[MasjidChangeRequest.kwebsite             ] as? String)
        prayerTimes             = record[MasjidChangeRequest.kprayerTimes         ] as? CKRecord.Reference
        userRecordIdVotedYes    = record[MasjidChangeRequest.kuserRecordIdVotedYes] as? [String] ?? []
        userRecordIdVotedNo     = record[MasjidChangeRequest.kuserRecordIdVotedNo ] as? [String] ?? []
        votesToPass             = record[MasjidChangeRequest.kvotesToPass         ] as? Int ?? Constants.numberOfVotesToPassMasjidChangeRequest
        location                = record[MasjidChangeRequest.klocation            ] as? CLLocation
    }
    // membawize
    init (
        name                : String,
        email               : String?,
        address             : String,
        phoneNumber         : String?,
        website             : String?,
        prayerTimes         : PrayerTimes,
        userRecordIdVotedYes: [String] = [],
        userRecordIdVotedNo : [String] = [],
        votesToPass         : Int = 3,
        location            : CLLocation
    ){
        // if string only spaces, send nil
        
        
        let record = CKRecord(.changeRequest)
        record[MasjidChangeRequest.kname                ] = name
        record[MasjidChangeRequest.kemail               ] = email
        record[MasjidChangeRequest.kaddress             ] = address
        record[MasjidChangeRequest.kphoneNumber         ] = phoneNumber
        record[MasjidChangeRequest.kwebsite             ] = website
        record[MasjidChangeRequest.kprayerTimes         ] = prayerTimes.record.reference(.deleteSelf)
        record[MasjidChangeRequest.kuserRecordIdVotedYes] = userRecordIdVotedYes
        record[MasjidChangeRequest.kuserRecordIdVotedNo ] = userRecordIdVotedNo
        record[MasjidChangeRequest.kvotesToPass         ] = votesToPass
        record[MasjidChangeRequest.klocation            ] = location
        self.init(record: record)
    }
}
