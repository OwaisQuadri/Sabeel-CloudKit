//
//  SProfileViewModel.swift
//  Sabeel
//
//  Created by Owais on 2023-08-10.
//

import Foundation

final class SProfileViewModel: ObservableObject {

    @Published var prayerStats: PrayerStats = PrayerStats(record: MockData.prayerStats)
    
}
