//
//  RestaurantMapView.swift
//  CityEventsWeatherApp
//
//  Created by Arman Mohiuddin on 11/17/25.
//

import SwiftUI
import MapKit

struct RestaurantMapView: View {
    let restaurant: Restaurant
    let coordinate: CLLocationCoordinate2D

    @State private var region: MKCoordinateRegion

    init(restaurant: Restaurant, coordinate: CLLocationCoordinate2D) {
        self.restaurant = restaurant
        self.coordinate = coordinate
        _region = State(wrappedValue: MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        ))
    }

    var body: some View {
        Map(coordinateRegion: $region, annotationItems: [RestaurantMapAnnotation(coordinate: coordinate)]) { item in
            MapMarker(coordinate: item.coordinate, tint: .red)
        }
        .navigationTitle(restaurant.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct RestaurantMapAnnotation: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}


