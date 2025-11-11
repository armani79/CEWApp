//
//  EvenService.swift
//  CityEventsWeatherApp
//
//  Created by Arman Mohiuddin on 11/11/25.
//

import Foundation

struct EventsService {
    static let apiKey = "QBWGHrjZ4vi9WA8dF2lQIRxWbPlth2WG"

    static func fetchEvents(for city: String) async throws -> [Event] {
        let cityQuery = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? city
        let url = URL(string:
            "https://app.ticketmaster.com/discovery/v2/events.json?city=\(cityQuery)&apikey=\(apiKey)"
        )!

        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(TMResponse.self, from: data)
        return response._embedded?.events ?? []
    }
}

