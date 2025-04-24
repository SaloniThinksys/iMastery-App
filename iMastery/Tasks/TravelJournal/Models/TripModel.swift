//
//  TripModel.swift
//  iMastery
//
//  Created by Saloni Singh on 23/04/25.
//

import Foundation
import SwiftUI
import CoreLocation

struct TripModel: Identifiable, Codable {
    var id: UUID
    var location: String
    var startDate: Date
    var endDate: Date
    var imageData: Data?
    var notes: String
    var latitude: Double?
    var longitude: Double?
}

