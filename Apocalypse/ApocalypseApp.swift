//
//  ApocalypseApp.swift
//  Apocalypse
//
//  Created by David Trojak on 08.01.2023.
//

import SwiftUI

@main
struct ApocalypseApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
