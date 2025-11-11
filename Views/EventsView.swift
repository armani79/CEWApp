//
//  EventsView.swift
//  CityEventsWeatherApp
//
//  Created by Arman Mohiuddin on 11/09/25.
//

import SwiftUI

struct EventsView: View {
    @State private var city = ""
    @State private var events: [Event] = []
    @State private var isLoading = false

    var body: some View {
        ZStack {
            AppTheme.sageGreen.ignoresSafeArea()

            VStack(spacing: 18) {

                Text("Events")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(AppTheme.textDark)

                TextField("Enter city for events...", text: $city)
                    .padding()
                    .background(AppTheme.cardBackground)
                    .cornerRadius(AppTheme.cornerRadius)
                    .shadow(color: AppTheme.shadow, radius: 6)
                    .padding(.horizontal)

                Button("Search") {
                    Task { await fetchEventsData() }
                }
                .font(.system(.headline))
                .foregroundColor(.white)
                .padding(.horizontal, 26)
                .padding(.vertical, 10)
                .background(AppTheme.textDark)
                .cornerRadius(AppTheme.cornerRadius)

                if isLoading { ProgressView().tint(AppTheme.textDark) }

                List(events) { event in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(event.name)
                            .font(.system(.headline))

                        Text(event.dates?.start?.localDate ?? "Date TBD")
                            .font(.system(.subheadline))
                            .foregroundColor(.gray)
                    }
                    .padding(.vertical, 6)
                }
                .scrollContentBackground(.hidden)
                .background(Color.clear)
            }
            .padding(.top, 30)
        }
    }

    func fetchEventsData() async {
        guard !city.isEmpty else { return }
        isLoading = true

        do {
            events = try await EventsService.fetchEvents(for: city)
        } catch {
            print("Error: \(error)")
        }

        isLoading = false
    }
}


