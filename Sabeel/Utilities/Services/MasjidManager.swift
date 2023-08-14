//
//  LocationManager.swift
//  Sabeel
//
//  Created by Owais on 2023-08-10.
//
// PROJECT REUSABLE: how to create an env object
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
                onMainThread { [self] in
                    self.masjids = masjids
                }
        }
    }
    
}
