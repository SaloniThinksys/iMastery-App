//
//  MapView.swift
//  iMastery
//
//  Created by Saloni Singh on 23/04/25.
//

import SwiftUI
import MapKit

struct MapView: View {
    let trips: [TripModel]

    @State private var region: MKCoordinateRegion = MKCoordinateRegion()

    var body: some View {
        Map(coordinateRegion: $region, annotationItems: tripsWithCoordinates) { item in
            MapAnnotation(coordinate: item.coordinate) {
                if let data = item.trip.imageData,
                   let image = UIImage(data: data) {
                    Image(uiImage: image)
                        .resizable()
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white, lineWidth: 2))
                        .shadow(radius: 4)
                } else {
                    Image(systemName: "mappin.circle.fill")
                        .font(.title)
                        .foregroundColor(.blue)
                }
            }
        }
        .onAppear {
            setInitialRegion()
        }
        //.edgesIgnoringSafeArea(.all)
    }

    var tripsWithCoordinates: [MapTrip] {
        trips.compactMap { trip in
            if let lat = trip.latitude, let lon = trip.longitude {
                return MapTrip(trip: trip, coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lon))
            }
            return nil
        }
    }

    private func setInitialRegion() {
        let coords = tripsWithCoordinates.map { $0.coordinate }

        guard !coords.isEmpty else { return }

        // Calculate center
        let avgLat = coords.map { $0.latitude }.reduce(0, +) / Double(coords.count)
        let avgLon = coords.map { $0.longitude }.reduce(0, +) / Double(coords.count)

        region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: avgLat, longitude: avgLon),
            span: MKCoordinateSpan(latitudeDelta: 30, longitudeDelta: 30) // You can adjust zoom here
        )
    }
}

struct MapTrip: Identifiable {
    let id = UUID()
    let trip: TripModel
    let coordinate: CLLocationCoordinate2D
}




