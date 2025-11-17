//
//  EventsView.swift
//  CityEventsWeatherApp
//
//  Created by Arman Mohiuddin on 11/09/25.
//

import SwiftUI

struct EventsView: View {
    @EnvironmentObject var appState: AppState
    @State private var city = ""
    @State private var events: [Event] = []
    @State private var isLoading = false
    @State private var errorMessage: String?

    var filteredEvents: [Event] {
        switch appState.recommendationType {
        case .indoor:
            return events.filter { !$0.isOutdoorLikely }
        case .outdoor:
            return events.filter { $0.isOutdoorLikely }
        case .both:
            return events
        }
    }

    var body: some View {
        ZStack {
            AppTheme.sageGreen.ignoresSafeArea()

            VStack(spacing: 18) {

                Text("Events")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(AppTheme.textDark)

                TextField("Enter a city...", text: $city)
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

                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                }

                ScrollView {
                    LazyVStack(spacing: 14) {
                        ForEach(filteredEvents) { event in
                            EventCard(event: event)
                        }
                    }
                    .padding(.horizontal)
                }

                Spacer()
            }
            .padding(.top, 30)
        }
    }

    func fetchEventsData() async {
        guard !city.isEmpty else { return }
        isLoading = true
        errorMessage = nil

        do {
            events = try await EventsService.fetchEvents(for: city)
        } catch {
            errorMessage = "Error loading events: \(error.localizedDescription)"
        }

        isLoading = false
    }
}

struct EventCard: View {
    let event: Event

    var eventImageURL: URL? {
        if let urlString = event.images?
            .sorted(by: { ($0.width ?? 0) > ($1.width ?? 0) })
            .first?.url,
           let url = URL(string: urlString) {
            return url
        }
        return nil
    }

    var indoorOutdoorLabel: String {
        event.isOutdoorLikely ? "🌿 Outdoor" : "🏛️ Indoor"
    }

    var venueName: String {
        event._embedded?.venues?.first?.name ?? ""
    }

    var body: some View {
        HStack(spacing: 14) {


            AsyncImage(url: eventImageURL) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
            }
            .frame(width: 70, height: 70)
            .cornerRadius(12)
            .clipped()

           
            VStack(alignment: .leading, spacing: 6) {
                Text(event.name)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(AppTheme.textDark)

                if !venueName.isEmpty {
                    Text(venueName)
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }

                Text(event.dates?.start?.localDate ?? "Date TBD")
                    .font(.system(size: 14))
                    .foregroundColor(.gray.opacity(0.9))

                Text(indoorOutdoorLabel)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(event.isOutdoorLikely ? Color.green.opacity(0.7) : Color.blue.opacity(0.6))
                    .cornerRadius(8)
            }

            Spacer()
        }
        .padding()
        .background(AppTheme.cardBackground)
        .cornerRadius(AppTheme.cornerRadius)
        .shadow(color: AppTheme.shadow, radius: 6, x: 0, y: 3)
    }
}
