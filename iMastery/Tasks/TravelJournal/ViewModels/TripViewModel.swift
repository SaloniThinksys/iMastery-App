//
//  TripViewModel.swift
//  iMastery
//
//  Created by Saloni Singh on 23/04/25.
//

import Foundation
import MapKit

class TripViewModel: ObservableObject{
    @Published var trips: [TripModel] = [] {
        didSet { saveTrips() }
    }
    
    private let tripsKey = "saveTrips"
    
    init(){
        loadTrips()
    }
    
    func addTrip(_ trip: TripModel){
        trips.append(trip)
    }
    
    func saveTrips(){
        if let encoded = try? JSONEncoder().encode(trips){
            UserDefaults.standard.set(encoded, forKey: tripsKey)
        }
    }
    
    func loadTrips(){
        if let data = UserDefaults.standard.data(forKey: tripsKey),
           let decoded = try? JSONDecoder().decode([TripModel].self, from: data){
            trips = decoded
        }
    }
    
    func deleteTrip(at offsets: IndexSet) {
        trips.remove(atOffsets: offsets)
        saveTrips()
    }
    
    func getUnavailableDates() -> [Date] {
        var dates: [Date] = []
        for trip in trips {
            var date = trip.startDate
            while date <= trip.endDate {
                dates.append(date)
                date = Calendar.current.date(byAdding: .day, value: 1, to: date)!
            }
        }
        return dates
    }

}
