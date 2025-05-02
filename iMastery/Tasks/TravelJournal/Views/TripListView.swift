//
//  TripListView.swift
//  iMastery
//
//  Created by Saloni Singh on 23/04/25.
//

import SwiftUI

struct TripListView: View {
    @StateObject private var viewModel = TripViewModel()
    @State private var showAddTrip = false
    @State private var showMap = false
    
    var body: some View {
        NavigationStack{
            VStack{
                List {
                    ForEach(viewModel.trips) { trip in
                        HStack(alignment: .top, spacing: 15) {
                            if let imageData = trip.imageData,
                               let uiImage = UIImage(data: imageData) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 80, height: 80)
                                    .clipped()
                                    .cornerRadius(10)
                            } else {
                                Rectangle()
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(width: 80, height: 80)
                                    .cornerRadius(10)
                                    .overlay(
                                        Image(systemName: "photo")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 30, height: 30)
                                            .foregroundColor(.gray)
                                    )
                            }

                            VStack(alignment: .leading, spacing: 6) {
                                Text(trip.location)
                                    .font(.headline)

                                Text("\(formattedDate(trip.startDate)) - \(formattedDate(trip.endDate))")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)

                                if !trip.notes.isEmpty {
                                    Text("Note: \(trip.notes)")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                        .padding(.vertical, 8)
                    }
                    .onDelete(perform: viewModel.deleteTrip)
                }
                .listStyle(.plain)
                
                Spacer()
                Button(action: {
                    showAddTrip = true
                }, label: {
                    Text("Add Trip")
                })
                .padding()
                .frame(maxWidth: .infinity)
                .font(.title3.bold())
                .foregroundColor(.white)
                .background(LinearGradient.blueGradient)
                .cornerRadius(10)
                .padding(.bottom, 10)
            }
            .padding()
            .navigationTitle("Travel Journal")
            .toolbar{
                ToolbarItem(placement: .topBarTrailing){
                    Button(action: {
                        showMap = true
                    } , label: {
                        Image(systemName: "mappin.and.ellipse.circle")
                            .font(.title2.bold())
                            .foregroundStyle(LinearGradient.blueGradient)
                    })
                }
            }
            .background(.gray.opacity(0.1))
            .navigationDestination(isPresented: $showMap){
                MapView(trips: viewModel.trips)
            }
            .navigationDestination(isPresented: $showAddTrip){
                AddTripView(viewModel: viewModel)
            }
        }
    }
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: date)
    }
}

#Preview {
    TripListView()
}
