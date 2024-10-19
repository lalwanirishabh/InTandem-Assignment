//
//  InTandemMapsApp.swift
//  InTandemMaps
//
//  Created by Rishabh Lalwani on 19/10/24.
//

import SwiftUI
import SwiftData

@main
struct InTandemMapsApp: App {

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Pin.self)
    }
}
