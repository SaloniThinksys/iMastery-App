//
//  CalendarView.swift
//  iMastery
//
//  Created by Saloni Singh on 24/04/25.
//

import SwiftUI

struct CalendarView: View {
    let unavailableDates: Set<Date>
    let allowFromDate: Date
    let allowToDate: Date
    var onDateSelected: (Date) -> Void

    @State private var currentMonth: Date = Date()

    private var daysInMonth: [Date] {
        guard let range = Calendar.current.range(of: .day, in: .month, for: currentMonth) else { return [] }
        return range.compactMap { day -> Date? in
            var components = Calendar.current.dateComponents([.year, .month], from: currentMonth)
            components.day = day
            return Calendar.current.date(from: components)
        }
    }

    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    currentMonth = Calendar.current.date(byAdding: .month, value: -1, to: currentMonth) ?? currentMonth
                }) {
                    Image(systemName: "chevron.left")
                }

                Spacer()
                Text(currentMonth, style: .date)
                    .font(.headline)
                Spacer()

                Button(action: {
                    currentMonth = Calendar.current.date(byAdding: .month, value: 1, to: currentMonth) ?? currentMonth
                }) {
                    Image(systemName: "chevron.right")
                }
            }.padding()

            let gridItems = Array(repeating: GridItem(.flexible()), count: 7)

            LazyVGrid(columns: gridItems, spacing: 10) {
                ForEach(daysInMonth, id: \.self) { date in
                    let isUnavailable = unavailableDates.contains(Calendar.current.startOfDay(for: date))
                    let isSelectable = (date >= allowFromDate && date <= allowToDate && !isUnavailable)

                    Text("\(Calendar.current.component(.day, from: date))")
                        .frame(width: 35, height: 35)
                        .background(isSelectable ? Color.blue.opacity(0.2) : Color.gray.opacity(0.2))
                        .foregroundColor(isSelectable ? .black : .gray)
                        .clipShape(Circle())
                        .onTapGesture {
                            if isSelectable {
                                onDateSelected(date)
                            }
                        }
                }
            }
            .padding(.bottom)
        }
        .padding()
    }
}

