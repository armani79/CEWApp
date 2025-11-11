//
//  Models.swift
//  CityEventsWeatherApp
//
//  Created by Arman Mohiuddin on 11/06/25.
//


import Foundation

struct WeatherResponse: Codable {
    let name: String
    let main: MainWeather
    let weather: [WeatherDescription]
}

struct MainWeather: Codable {
    let temp: Double
}

struct WeatherDescription: Codable {
    let description: String
}

// Ticketmaster JSON Models
struct TMResponse: Codable {
    let _embedded: EmbeddedEvents?
}

struct EmbeddedEvents: Codable {
    let events: [Event]
}

struct Event: Codable, Identifiable {
    let id: String
    let name: String
    let dates: EventDates?
}

struct EventDates: Codable {
    let start: EventStart?
}

struct EventStart: Codable {
    let localDate: String?
}
