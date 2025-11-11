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
        guard let request = MKGeocodingRequest(addressString: address) else {
            throw URLError(.badURL)
        }
        let mapItems = try await request.mapItems
        guard let coordinate = mapItems.first?.placemark.coordinate else {
            throw URLError(.cannotFindHost)
        }
        return coordinate
    }
}
