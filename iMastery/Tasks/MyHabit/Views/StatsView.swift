//
//  StatsView.swift
//  iMastery
//
//  Created by Saloni Singh on 21/04/25.
//

import SwiftUI
import Charts

struct StatsView: View {
    @FetchRequest(sortDescriptors: []) var habits: FetchedResults<Habit>

    var body: some View {
        NavigationStack{
            VStack (spacing: 10){
                VStack(alignment: .leading){
                    Text("Weekly Completion")
                        .font(.title3.bold())
                        .foregroundColor(.blue)
                    
                    let weeklyData = getWeeklyData()
                    
                    Chart {
                        ForEach(weeklyData, id: \.0) { (day, count) in
                            BarMark(
                                x: .value("Day", day),
                                y: .value("Completed", count)
                            )
                        }
                    }
                    .frame(height: 250)
                    .padding(20)
                }
                .padding()
                .background(.gray.opacity(0.1))
                .cornerRadius(10)
                
                Spacer()
                
                VStack(spacing: 10){
                    HStack(){
                        Image(systemName: "flame.fill")
                            .foregroundStyle(.yellow)
                        Text("Current Streak: \(calculateStreak()) Days")
                    }
                    Divider()
                    HStack(){
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(.green)
                        Text("Total Completed: \(totalCompletions())")
                    }
                }
                .padding()
                .background(.gray.opacity(0.1))
                .cornerRadius(10)
                .padding(.bottom, 80)
            }
            .padding()
            .navigationTitle("Your Progress")
        }
        .background(.gray.opacity(0.15))
    }

    func getWeeklyData() -> [(String, Int)] {
        let days = ["M", "T", "W", "T", "F", "S", "S"]
        var result: [(String, Int)] = []

        let calendar = Calendar.current
        for (index, day) in days.enumerated() {
            let weekday = index + 2 // Monday = 2
            let filtered = habits.flatMap { $0.completionLog as? [Date] ?? [] }
                .filter { calendar.component(.weekday, from: $0) == weekday }
            result.append((day, filtered.count))
        }
        return result
    }

    func calculateStreak() -> Int {
        let today = Calendar.current.startOfDay(for: Date())
        var streak = 0

        for i in (0..<7).reversed() {
            let date = Calendar.current.date(byAdding: .day, value: -i, to: today)!
            let completed = habits.contains { habit in
                (habit.completionLog as? [Date] ?? []).contains { Calendar.current.isDate($0, inSameDayAs: date) }
            }
            if completed {
                streak += 1
            } else {
                break
            }
        }
        return streak
    }

    func totalCompletions() -> Int {
        habits.compactMap { $0.completionLog as? [Date] }.flatMap { $0 }.count
    }

}


#Preview {
    StatsView()
}
