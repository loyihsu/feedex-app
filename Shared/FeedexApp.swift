//
//  FeedexApp.swift
//  Shared
//
//  Created by Loyi Hsu on 2021/9/29.
//

import SwiftUI

@main
struct FeedexApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
