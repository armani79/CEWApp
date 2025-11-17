//
//  ResView.swift
//  CityEventsWeatherApp
//
//  Created by Arman Mohiuddin on 11/09/25.
//

import SwiftUI
import MapKit
import CoreLocation

struct ResView: View {
    @EnvironmentObject var appState: AppState

    @State private var city = ""
    @State private var restaurants: [Restaurant] = []
    @State private var isLoading = false
    @State private var errorMessage: String?


    @State private var navRestaurant: Restaurant?
    @State private var navCoordinate: CLLocationCoordinate2D?

    // SwiftUI Animation
    @State private var animateCards = false

    // Indoor/Outdoor Filtering Logic
    var filteredRestaurants: [Restaurant] {
        switch appState.recommendationType {
        case .indoor:
            return restaurants.filter { !$0.isOutdoorLikely }
        case .outdoor:
            return restaurants.filter { $0.isOutdoorLikely }
        case .both:
            return restaurants
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.sageGreen.ignoresSafeArea()

                VStack(spacing: 18) {
                    Text("Restaurants")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(AppTheme.textDark)

                    // Search Bar
                    TextField("Enter a city or address...", text: $city)
                        .padding()
                        .background(AppTheme.cardBackground)
                        .cornerRadius(AppTheme.cornerRadius)
                        .shadow(color: AppTheme.shadow, radius: 6)
                        .padding(.horizontal)

                    // SEARCH BUTTON
                    Button("Search") {
                        Task { await searchRestaurants() }
                    }
                    .font(.system(.headline))
                    .foregroundColor(.white)
                    .padding(.horizontal, 26)
                    .padding(.vertical, 10)
                    .background(AppTheme.textDark)
                    .cornerRadius(AppTheme.cornerRadius)

                    // Loading Indicator
                    if isLoading { ProgressView().tint(AppTheme.textDark) }

                    // Error Display
                    if let errorMessage = errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                    }

                    // Restaurant List
                    ScrollView {
                        LazyVStack(spacing: 14) {
                          ForEach(Array(filteredRestaurants.enumerated()), id: \.element.id) { index, rest in
                              RestaurantCard(restaurant: rest) {
                                    Task {
                                        navRestaurant = rest
                                        navCoordinate = rest.coordinate
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }

                    Spacer()
                }
                .padding(.top, 30)
            }
            .navigationDestination(item: $navRestaurant) { restaurant in
                if let coord = navCoordinate {
                    RestaurantMapView(restaurant: restaurant, coordinate: coord)
                }
            }
        }
    }

    func searchRestaurants() async {
        guard !city.isEmpty else { return }
        isLoading = true
        errorMessage = nil

        do {

            let request = MKLocalSearch.Request()
            request.naturalLanguageQuery = city
            let search = MKLocalSearch(request: request)
            let result = try await search.start()

            guard let item = result.mapItems.first else {
                throw NSError(domain: "No results found", code: 1)
            }

            let coordinate = item.placemark.coordinate


            restaurants = try await RestaurantService.searchRestaurants(near: coordinate)

        } catch {
            errorMessage = "Error: \(error.localizedDescription)"
        }

      isLoading = false
      animateCards = false
      withAnimation(.easeOut(duration: 0.5)) {
          animateCards = true
      }

    }
}


struct RestaurantCard: View {
    let restaurant: Restaurant
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 10) {


                Text(restaurant.name)
                    .font(.headline)
                    .foregroundColor(AppTheme.textDark)


                Text("📍 \(restaurant.address)")
                    .font(.subheadline)
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .foregroundColor(.blue)


                Text(restaurant.isOutdoorLikely ? "🌿 Outdoor" : "🏛️ Indoor")
                    .font(.caption2)
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        restaurant.isOutdoorLikely
                        ? Color.green.opacity(0.7)
                        : Color.blue.opacity(0.7)
                    )
                    .cornerRadius(8)

                Spacer()
            }
            .padding()
            .frame(maxWidth: .infinity, minHeight: 130, maxHeight: 130)
            .background(AppTheme.cardBackground)
            .cornerRadius(AppTheme.cornerRadius)
            .shadow(color: AppTheme.shadow, radius: 6)
        }
    }
}

