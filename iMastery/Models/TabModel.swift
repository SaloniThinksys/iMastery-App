//
//  TabModel.swift
//  iMastery
//
//  Created by Saloni Singh on 02/05/25.
//

import Foundation

enum TabModel: String, CaseIterable {
    case home = "Home"
    case loginSignUp = "Login"
    case myHabit = "My Habit"
    case podcastPlayer = "Podcast"
    case travelJornal = "Travel"
    
    var systemImage: String {
        switch self {
        case .home:
            return "house"
        case .loginSignUp:
            return "person.badge.shield.exclamationmark.fill"
        case .myHabit:
            return "chart.bar.fill"
        case .podcastPlayer:
            return "headphones"
        case .travelJornal:
            return "airplane.departure"
        }
    }
}
