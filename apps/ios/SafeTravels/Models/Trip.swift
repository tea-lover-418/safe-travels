//
//  Trip.swift
//  SafeTravels
//
//  Created by Mathijs Bernson on 23/07/2025.
//

import Foundation
import SwiftData

@Model
final class Trip {
    var title: String
    var body: String?
    var totalKM: Double = 0
    var startDate: Date
    var endDate: Date?

    @Relationship(deleteRule: .cascade)
    var locations: [Location]

    @Relationship(deleteRule: .cascade)
    var posts: [Post]

    init(title: String, body: String, startDate: Date, endDate: Date? = nil, locations: [Location] = [Location](), posts: [Post] = [Post]()) {
        self.title = title
        self.body = body
        self.startDate = startDate
        self.endDate = endDate
        self.locations = locations
        self.posts = posts
    }

    init(polarstepsTrip trip: PolarstepsTrip, locations: [Location]) {
        self.title = trip.name
        self.body = nil
        self.totalKM = trip.totalKM
        self.startDate = Date(timeIntervalSince1970: trip.startDate)
        self.endDate = Date(timeIntervalSince1970: trip.endDate)
        self.posts = trip.allSteps.map(Post.init(polarstepsStep:))
        self.locations = locations
    }
}
