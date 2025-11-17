//
//  TabViewCustom.swift
//  CityEventsWeatherApp
//
//  Created by Arman Mohiuddin on 11/09/25.
//

import SwiftUI

struct TabViewCustom: View {
  var body: some View {
    TabView{
      ContentView() // Home Screen
                      .tabItem {
                          Label("Home", systemImage: "house")
                      }

      EventsView()
          .tabItem {
              Label("Events", systemImage: "calendar")
          }



                  ResView()
                      .tabItem {
                          Label("Restaurants", systemImage: "fork.knife")
                      }
    }

  }
}
