//
//  MasjidChangeRequest.swift
//  Sabeel
//
//  Created by Owais on 2023-08-07.
//

import Foundation

struct MasjidChangeRequest {
    var name: String = "ooshawa Masjid"
    var email: String?
    var address: String = "1234 Address Dr, Oshawa, ON, Canada, A1A 1A1"
    var phoneNumber : String? = "2899438996"
    var website : String? = "www.google.com"
    var prayerTimes: PrayerTimes = PrayerTimes()
    var yesVotes: Int = 0
    var noVotes: Int = 0
    var votesToPass: Int = 3
}
