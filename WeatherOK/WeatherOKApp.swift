//
//  WeatherOKApp.swift
//  WeatherOK
//
//  Created by MAC on 15.03.2023.
//

import SwiftUI

@main
struct WeatherOKApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
