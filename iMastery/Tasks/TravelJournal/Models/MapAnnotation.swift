//
//  MapAnnotation.swift
//  iMastery
//
//  Created by Saloni Singh on 24/04/25.
//

import MapKit

struct TripAnnotation: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
    let image: UIImage
}

