//
//  LocationManager.swift
//  Sabeel
//
//  Created by Owais on 2023-08-10.
//

import MapKit
import SwiftUI

final class MasjidManager: ObservableObject {
    @Published var masjids: [Masjid] = []
    @Published var selectedMasjid: Masjid? = nil
    
    init(_ masjids: [Masjid] = [], selected masjid: Masjid? = nil) {
        self.masjids = masjids
        self.selectedMasjid = masjid
    }
    
    func getMasjids(){
            CloudKitManager.shared.read(recordType: .masjid, predicate: NSPredicate(value: true)) {masjids in
                DispatchQueue.main.async { [self] in
                    self.masjids = masjids
                }
        }
    }
    
}
