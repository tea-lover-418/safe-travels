//
//  Item.swift
//  SafeTravels
//
//  Created by Mathijs Bernson on 09/07/2025.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
