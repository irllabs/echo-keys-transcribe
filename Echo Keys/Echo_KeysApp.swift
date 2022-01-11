//
//  Echo_KeysApp.swift
//  Echo Keys
//
//  Created by Ali Momeni on 1/7/22.
//

import SwiftUI

@main
struct Echo_KeysApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
