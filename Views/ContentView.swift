//
//  ContentView.swift
//  CityEventsWeatherApp
//
//  Created by Arman Mohiuddin on 11/06/25.
//

import SwiftUI
import MapKit
import CoreLocation

struct ContentView: View {
    @State private var city = ""
    @State private var weather: WeatherResponse?
    @State private var events: [Event] = []
    @State private var isLoading = false
    @State private var errorMessage: String?

    var body: some View {
        ZStack {
            AppTheme.sageGreen.ignoresSafeArea()

            VStack(spacing: 22) {

                Text("City Weather")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(AppTheme.textDark)

                TextField("Enter a city...", text: $city)
                    .padding()
                    .background(AppTheme.cardBackground)
                    .cornerRadius(AppTheme.cornerRadius)
                    .shadow(color: AppTheme.shadow, radius: 6)
                    .padding(.horizontal)

                Button(action: {
                    Task { await fetchData() }
                }) {
                    Text("Search")
                        .font(.system(.headline))
                        .foregroundColor(.white)
                        .padding(.horizontal, 26)
                        .padding(.vertical, 10)
                        .background(AppTheme.textDark)
                        .cornerRadius(AppTheme.cornerRadius)
                }

                if isLoading { ProgressView().tint(AppTheme.textDark) }

                // Weather Result Card
                if let weather = weather {
                    VStack(spacing: 6) {
                        Text(weather.name)
                            .font(.system(.title2, weight: .semibold))
                            .foregroundColor(AppTheme.textDark)

                        Text("\(Int(weather.main.temp))°F")
                            .font(.system(size: 48, weight: .bold))
                            .foregroundColor(AppTheme.textDark)

                        Text(weather.weather.first?.description.capitalized ?? "")
                            .font(.system(.subheadline))
                            .foregroundColor(AppTheme.textDark.opacity(0.7))
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(AppTheme.cardBackground)
                    .cornerRadius(AppTheme.cornerRadius)
                    .shadow(color: AppTheme.shadow, radius: 10)
                    .padding(.horizontal)
                }
              if let weather = weather {
                  VStack(spacing: 10) {

                      Text(activityRecommendation(for: weather))
                          .font(.subheadline)
                          .foregroundColor(.white)
                          .padding()
                          .frame(maxWidth: .infinity)
                          .background(Color.black.opacity(0.25))
                          .cornerRadius(14)
                          .padding(.horizontal)
                  }
              }


                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                }

                Spacer()
            }
            .padding(.top, 40)
        }
    }

  func fetchData() async {
      guard !city.isEmpty else { return }
      isLoading = true
      errorMessage = nil

      do {
          // 1. Convert address → coordinates
          let coordinate = try await GeocodingService.geocode(address: city)

          // 2. Call weather using lat/lon
          weather = try await WeatherService.fetchWeather(lat: coordinate.latitude, lon: coordinate.longitude)

          // 3. Convert lat/lon back into a real city name using Core Location reverse geocoding
          let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
          let geocoder = CLGeocoder()
          if let placemark = try await geocoder.reverseGeocodeLocation(location).first,
             let detectedCity = placemark.locality, !detectedCity.isEmpty {
              events = try await EventsService.fetchEvents(for: detectedCity)
          }

      } catch {
          errorMessage = "Error: \(error.localizedDescription)"
      }

      isLoading = false
  }

  func activityRecommendation(for weather: WeatherResponse) -> String {
      let description = weather.weather.first?.description.lowercased() ?? ""
      let temp = weather.main.temp

      if description.contains("rain") || description.contains("storm") || description.contains("snow") {
          return "Looks like the weather is rough — we recommend indoor activities like museums, cafes, or movies."
      } else if temp >= 80 {
          return "It's warm and sunny — great day for outdoor activities like parks, street fairs, and walking tours!"
      } else if temp <= 45 {
          return "A bit chilly outside — consider indoor activities."
      } else {
          return "Weather looks pleasant — indoor or outdoor activities both work today!"
      }
  }


}
