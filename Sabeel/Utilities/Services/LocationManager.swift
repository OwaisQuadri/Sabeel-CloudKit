//
//  LocationManager.swift
//  Sabeel
//
//  Created by Owais on 2023-08-10.
//

import MapKit

final class LocationManager: ObservableObject {
    @Published var masjids: [Masjid] = []
    @Published var selectedMasjid: Masjid? = nil
}
