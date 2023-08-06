//
//  SabeelApp.swift
//  Sabeel
//
//  Created by Owais on 2023-08-05.
//

import SwiftUI

@main
struct SabeelApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            STabView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
