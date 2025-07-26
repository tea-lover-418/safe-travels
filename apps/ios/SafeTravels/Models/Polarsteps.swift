//
//  Polarsteps.swift
//  SafeTravels
//
//  Created by Mathijs Bernson on 23/07/2025.
//

import Foundation

// MARK: Models

struct PolarstepsTrackingLocations: Decodable {
    let locations: [PolarstepsTrackingLocation]
}

struct PolarstepsTrackingLocation: Decodable {
    let latitude: Double
    let longitude: Double
    let timestamp: Double

    enum CodingKeys: String, CodingKey {
        case latitude = "lat"
        case longitude = "lon"
        case timestamp = "time"
    }
}

struct PolarstepsTrip: Decodable {
    let id: Int
    // let userID: Int
    let name: String
    let visibility: Int
    let slug: String
    let startDate, endDate: Double
    let isDeleted: Bool
    let totalKM: Double
    let views: Int
    let timezoneID, summary: String
    let coverPhotoPath, coverPhotoThumbPath: String
    let coverPhoto: PolarstepsCoverPhoto
    let plannedStepsVisible: Bool
    let creationTime: Double
    let stepCount: Int
    let travelTrackerDevice: PolarstepsTravelTrackerDevice
    let uuid: String
    let allSteps: [PolarstepsStep]

    // let id, userID: Int
    // let name: String
    // let type: JSONNull?
    // let visibility: Int
    // let slug: String
    // let startDate, endDate: Int
    // let isDeleted: Bool
    // let openGraphID, fbPublishStatus: JSONNull?
    // let totalKM: Double
    // let views: Int
    // let featured, featuredPriorityForNewUsers, featureText, featureDate: JSONNull?
    // let language: JSONNull?
    // let timezoneID, summary: String
    // let coverPhotoPath, coverPhotoThumbPath: String
    // let coverPhoto: CoverPhoto
    // let plannedStepsVisible: Bool
    // let futureTimelineLastModified: JSONNull?
    // let creationTime: Double
    // let stepCount: Int
    // let travelTrackerDevice: TravelTrackerDevice
    // let uuid: String
    // let allSteps: [AllStep]

    enum CodingKeys: String, CodingKey {
        case id
        // case userID = "user_id"
        case name, visibility, slug
        // case type
        case startDate = "start_date"
        case endDate = "end_date"
        case isDeleted = "is_deleted"
        // case openGraphID = "open_graph_id"
        // case fbPublishStatus = "fb_publish_status"
        case totalKM = "total_km"
        case views
        // case featured
        // case featuredPriorityForNewUsers = "featured_priority_for_new_users"
        // case featureText = "feature_text"
        // case featureDate = "feature_date"
        // case language
        case timezoneID = "timezone_id"
        case summary
        case coverPhotoPath = "cover_photo_path"
        case coverPhotoThumbPath = "cover_photo_thumb_path"
        case coverPhoto = "cover_photo"
        case plannedStepsVisible = "planned_steps_visible"
        // case futureTimelineLastModified = "future_timeline_last_modified"
        case creationTime = "creation_time"
        case stepCount = "step_count"
        case travelTrackerDevice = "travel_tracker_device"
        case uuid
        case allSteps = "all_steps"
    }
}

struct PolarstepsStep: Decodable {
    let id, tripID, locationID: Int
    let name, displayName, description, slug: String
    let displaySlug: String
    let type: Int
    let startTime: Double
    let endTime: Double?
    let creationTime: Double
    let location: PolarstepsLocation
    let isDeleted: Bool
    let timezoneID: String
    let views, commentCount: Int
    let weatherCondition: String
    let weatherTemperature: Int
    let uuid: String
    // let supertype: Supertype
    // let mainMediaItemPath: Type?
    // let openGraphID, fbPublishStatus: JSONNull?

    enum CodingKeys: String, CodingKey {
        case id
        case tripID = "trip_id"
        case locationID = "location_id"
        // case mainMediaItemPath = "main_media_item_path"
        case name
        case displayName = "display_name"
        case description, slug
        case displaySlug = "display_slug"
        case type
        case startTime = "start_time"
        case endTime = "end_time"
        case creationTime = "creation_time"
        case location
        // case supertype
        case isDeleted = "is_deleted"
        // case openGraphID = "open_graph_id"
        // case fbPublishStatus = "fb_publish_status"
        case timezoneID = "timezone_id"
        case views
        case commentCount = "comment_count"
        case weatherCondition = "weather_condition"
        case weatherTemperature = "weather_temperature"
        case uuid
    }
}

struct PolarstepsLocation: Decodable {
    let id: Int
    let name, detail, fullDetail, countryCode: String
    let latitude, longitude: Double
    let uuid: String

    enum CodingKeys: String, CodingKey {
        case id, uuid, name, detail
        case fullDetail = "full_detail"
        case countryCode = "country_code"
        case latitude = "lat",
             longitude = "lon"
    }
}

struct PolarstepsCoverPhoto: Decodable {
    let id: Int
    let path, largeThumbnailPath, smallThumbnailPath: String
    let type, mediaID, tripID: Int
    let fullResUnavailable: Bool
    let lastModified: Double
    let uuid: String

    enum CodingKeys: String, CodingKey {
        case id, path
        case largeThumbnailPath = "large_thumbnail_path"
        case smallThumbnailPath = "small_thumbnail_path"
        case type
        case mediaID = "media_id"
        case tripID = "trip_id"
        case fullResUnavailable = "full_res_unavailable"
        case lastModified = "last_modified"
        case uuid
    }
}

struct PolarstepsTravelTrackerDevice: Decodable {
    let id, tripID: Int
    let deviceName: String
    let trackingStatus: Int
    let uuid: String

    enum CodingKeys: String, CodingKey {
        case id
        case tripID = "trip_id"
        case deviceName = "device_name"
        case trackingStatus = "tracking_status"
        case uuid
    }
}
