//
//  WeatherService.swift
//  CityEventsWeatherApp
//
//  Created by Arman Mohiuddin
//

import Foundation

struct WeatherService {
    static let apiKey = "0b841370d40bbffd3e503b5fc0c029a8"

    static func fetchWeather(for city: String) async throws -> WeatherResponse {
        let cityQuery = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? city
        let url = URL(string:
            "https://api.openweathermap.org/data/2.5/weather?q=\(cityQuery)&units=imperial&appid=\(apiKey)"
        )!

        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(WeatherResponse.self, from: data)
    }

    static func fetchWeather(lat: Double, lon: Double) async throws -> WeatherResponse {
        guard let url = URL(string:
            "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&units=imperial&appid=\(apiKey)"
        ) else {
            throw URLError(.badURL)
        }

        let (data, response) = try await URLSession.shared.data(from: url)
        guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        return try JSONDecoder().decode(WeatherResponse.self, from: data)
    }
}
