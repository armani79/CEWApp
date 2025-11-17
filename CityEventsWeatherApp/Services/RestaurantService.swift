//
//  RestaurantService.swift
//  CityEventsWeatherApp
//
//  Created by Arman Mohiuddin on 11/17/25.
//

import Foundation
import MapKit

struct RestaurantService {

    static func searchRestaurants(
        near coordinate: CLLocationCoordinate2D
    ) async throws -> [Restaurant] {

        var request = MKLocalSearch.Request()
        request.resultTypes = .pointOfInterest
        request.naturalLanguageQuery = "restaurant"
        request.region = MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
        )

        let search = MKLocalSearch(request: request)
        let response = try await search.start()

        return response.mapItems.map { item in
            Restaurant(
                name: item.name ?? "Unknown",
                address: item.placemark.title ?? "Address unavailable",
                coordinate: item.placemark.coordinate,
                category: item.pointOfInterestCategory?.rawValue ?? "Restaurant",
                url: item.url
            )
        }
    }
}

