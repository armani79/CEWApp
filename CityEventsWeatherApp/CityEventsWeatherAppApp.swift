//
//  CityEventsWeatherAppApp.swift
//  CityEventsWeatherApp
//
//  Created by Arman Mohiuddin on 11/06/25.
//

import SwiftUI

@main
struct CityEventsWeatherAppApp: App {
    @StateObject var appState = AppState()

    var body: some Scene {
        WindowGroup {
            TabViewCustom()
                .environmentObject(appState) 
        }
    }
}
