//
//  AddTripView.swift
//  iMastery
//
//  Created by Saloni Singh on 23/04/25.
//

import SwiftUI
import PhotosUI

struct AddTripView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel: TripViewModel
    @StateObject private var locationService = LocationSearchService()
    
    @State private var location: String = ""
    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var notes: String = ""
    
    //@State private var showDateConflictAlert = false
    @State private var imageData: UIImage? = nil
    @State private var selectedItem: PhotosPickerItem?
    
    @State private var showSuggestions = false
    
    @State private var showStartCalendar = false
    @State private var showEndCalendar = false

    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                Color.gray.opacity(0.1).ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        Text("Add Trip")
                            .font(.largeTitle.bold())
                        
                        LocationLoader()
                        
                        HStack(spacing: 40) {
                            DatePickerButton(
                                title: "Start Date",
                                date: startDate,
                                showCalendar: $showStartCalendar,
                                allowFromDate: Date(),
                                allowToDate: Date().addingTimeInterval(60*60*24*365),
                                unavailableDates: viewModel.getUnavailableDates()
                            ) { selected in
                                startDate = selected
                                if endDate < selected {
                                    endDate = selected
                                }
                            }
                            
                            DatePickerButton(
                                title: "End Date",
                                date: endDate,
                                showCalendar: $showEndCalendar,
                                allowFromDate: startDate,
                                allowToDate: Date().addingTimeInterval(60*60*24*365),
                                unavailableDates: viewModel.getUnavailableDates()
                            ) { selected in
                                endDate = selected
                            }
                        }

                        
                        ImageLoader()
                        
                        VStack(alignment: .leading) {
                            Text("Notes")
                                .bold()
                            TextField("", text: $notes)
                                .padding(5)
                                .frame(height: 80)
                                .background(.gray.opacity(0.1))
                                .cornerRadius(10)
                        }
                        
                        Button(action: {
                            let geocoder = CLGeocoder()
                            geocoder.geocodeAddressString(location) { placemarks, error in
                                if let coordinate = placemarks?.first?.location?.coordinate {
                                    let trip = TripModel(
                                        id: UUID(),
                                        location: location,
                                        startDate: startDate,
                                        endDate: endDate,
                                        imageData: imageData?.jpegData(compressionQuality: 0.8),
                                        notes: notes,
                                        latitude: coordinate.latitude,
                                        longitude: coordinate.longitude
                                    )
                                    viewModel.addTrip(trip)
                                    dismiss()
                                } else {
                                    print("Geocoding failed: \(error?.localizedDescription ?? "Unknown error")")
                                }
                            }
                        }, label: {
                            Text("Save Trip")
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
                    .background(.white)
                    .cornerRadius(10)
                    .padding()
                }
            }
        }
    }

    @ViewBuilder
    func ImageLoader() -> some View {
        VStack(alignment: .leading) {
            Text("Image")
                .bold()
            if let imageData {
                Image(uiImage: imageData)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 80)
                    .clipped()
                    .cornerRadius(10)
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 100, height: 80)
                    .overlay(Text("No image selected").foregroundColor(.gray))
                    .cornerRadius(10)
            }

            PhotosPicker(selection: $selectedItem, matching: .images) {
                Text("Select Image")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.blue.opacity(0.2))
                    .cornerRadius(10)
            }
            .onChange(of: selectedItem) {
                Task {
                    if let item = selectedItem,
                       let data = try? await item.loadTransferable(type: Data.self),
                       let uiImage = UIImage(data: data) {
                        imageData = uiImage
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    func LocationLoader() -> some View {
        VStack(alignment: .leading) {
            Text("Location")
                .bold()
            
            ZStack(alignment: .topLeading) {
                TextField("Enter city", text: $location)
                    .padding()
                    .background(.gray.opacity(0.1))
                    .cornerRadius(10)
                    .onChange(of: location) {
                        locationService.updateSearch(query: location)
                        withAnimation {
                            showSuggestions = !locationService.suggestions.isEmpty
                        }
                    }

                // Suggestions dropdown
                if showSuggestions {
                    VStack(alignment: .leading, spacing: 0) {
                        ForEach(locationService.suggestions, id: \.self) { suggestion in
                            Text(suggestion)
                                .padding(.horizontal)
                                .padding(.vertical, 10)
                                .background(Color.white)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .onTapGesture {
                                    location = suggestion
                                    showSuggestions = false
                                }
                            Divider()
                        }
                    }
                    .background(Color.white)
                    .cornerRadius(8)
                    .shadow(radius: 2)
                    .padding(.top, 50)
                    .zIndex(1)
                }
            }
            .zIndex(1)
        }
    }
    
    @ViewBuilder
    func DatePickerButton(
        title: String,
        date: Date,
        showCalendar: Binding<Bool>,
        allowFromDate: Date,
        allowToDate: Date,
        unavailableDates: [Date],
        onDateSelected: @escaping (Date) -> Void
    ) -> some View {
        VStack(alignment: .leading) {
            Text(title)
                .bold()
            Button(action: {
                showCalendar.wrappedValue = true
            }) {
                HStack {
                    Text("\(date.formatted(.dateTime.month().day().year()))")
                    Spacer()
                    Image(systemName: "calendar")
                }
            }
            .sheet(isPresented: showCalendar) {
                CalendarView(
                    unavailableDates: Set(viewModel.getUnavailableDates()),
                    allowFromDate: allowFromDate,
                    allowToDate: allowToDate,
                    onDateSelected: { selected in
                        onDateSelected(selected)
                        showCalendar.wrappedValue = false
                    }
                )
            }
        }
    }

}
