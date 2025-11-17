//
//  GeoCodingService.swift
//  CityEventsWeatherApp
//
//  Created by Arman Mohiuddin on 11/11/25.
//

import Foundation
import MapKit

struct GeocodingService {
    static func geocode(address: String) async throws -> CLLocationCoordinate2D {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = address

        let search = MKLocalSearch(request: request)
        let response = try await search.start()

        guard let item = response.mapItems.first else {
            throw NSError(domain: "No location found", code: 1)
        }

        return item.placemark.coordinate
    }
}
