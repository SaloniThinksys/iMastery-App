//
//  LinearGradient.swift
//  iMastery
//
//  Created by Saloni Singh on 30/04/25.
//

import Foundation
import SwiftUI

extension LinearGradient {
    static let purpleGradient = LinearGradient(
        gradient: Gradient(colors: [Color.purple.opacity(0.7), Color.indigo.opacity(0.7)]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

