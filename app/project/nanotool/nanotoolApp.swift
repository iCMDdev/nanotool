//
//  nanotoolApp.swift
//  nanotool
//
//  Copyright 2022 Cristian Dinca (@iCMDgithub). See github.com/iCMDgithub/nanotool for license terms.
//

import SwiftUI

@main
struct nanotoolApp: App {
    @State private var connected: Bool = false
    var body: some Scene {
        WindowGroup {
            ContentView(showTitleMsg: $connected)
                .navigationTitle("Nanotool - \(connected ? "Connected" : "Disconnected") ")
        }
    }
}
