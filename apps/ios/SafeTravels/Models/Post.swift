//
//  Post.swift
//  SafeTravels
//
//  Created by Mathijs Bernson on 09/07/2025.
//

import Foundation
import SwiftData

@Model
final class Post {
    var title: String
    var body: String
    var timestamp: Date
    @Relationship var location: Location?

    init(title: String, body: String, timestamp: Date, location: Location?) {
        self.title = title
        self.body = body
        self.timestamp = timestamp
        self.location = location
    }

    init(polarstepsStep step: PolarstepsStep) {
        self.title = step.displayName
        self.body = step.description
        self.timestamp = Date(timeIntervalSince1970: step.creationTime)
        self.location = Location(polarstepsLocation: step.location, timestamp: Date(timeIntervalSince1970: step.startTime))
    }
}
