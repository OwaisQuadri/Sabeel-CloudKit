//
//  UserLocationManager.swift
//  Sabeel
//
//  Created by Owais on 2023-08-15.
//

import Foundation
import CoreLocation

final class UserLocationManager: CLLocationManager {
    static let shared = CLLocationManager()
    
    private override init() { super.init() }
    
    
}
