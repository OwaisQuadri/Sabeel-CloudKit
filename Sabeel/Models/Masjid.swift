//
//  Masjid.swift
//  Sabeel
//
//  Created by Owais on 2023-08-07.
//

import Foundation

struct Masjid : Equatable {
    static func == (lhs: Masjid, rhs: Masjid) -> Bool {
        lhs.name == rhs.name && lhs.email == rhs.email && lhs.address == rhs.address && lhs.phoneNumber == rhs.phoneNumber && lhs.website == rhs.website && lhs.prayerTimes == rhs.prayerTimes
    }
    
    var name: String = "Oshawa Masjid"
    var email: String?
    var address: String = "1234 Address Dr, Oshawa, ON, Canada, A1A 1A1"
    var phoneNumber : String? = "2899438996"
    var website : String? = "www.google.com"
    var prayerTimes: PrayerTimes = PrayerTimes()
    var changeRequest: MasjidChangeRequest? // TODO: create prepopulate values on the request maker when changing times for prayer + warn when leaving page if edits are made
}
