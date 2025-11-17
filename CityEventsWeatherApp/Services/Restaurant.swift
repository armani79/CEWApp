//
//  Restaurant.swift
//  CityEventsWeatherApp
//
//  Created by Arman Mohiuddin on 11/17/25.
//

import Foundation
import MapKit

struct Restaurant: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let address: String
    let coordinate: CLLocationCoordinate2D
    let category: String
    let url: URL?

    /// Determines if restaurant likely has outdoor seating
    var isOutdoorLikely: Bool {
        let lower = name.lowercased()
        let outdoorKeywords = [
            "garden", "park", "beach", "pier", "patio",
            "truck", "food truck", "outdoor", "terrace", "rooftop"
        ]
        return outdoorKeywords.contains(where: { lower.contains($0) })
    }

    // Required for Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(address)
        hasher.combine(category)
        hasher.combine(coordinate.latitude)
        hasher.combine(coordinate.longitude)
    }

    static func == (lhs: Restaurant, rhs: Restaurant) -> Bool {
        lhs.id == rhs.id
    }
}



