//
//  MapView.swift
//  SafeTravels
//
//  Created by Mathijs Bernson on 23/07/2025.
//

import SwiftUI
import MapKit
import SwiftData

struct MapView: View {
    @Query(sort: \Location.timestamp, order: .reverse)
    var locations: [Location]

    @Query(sort: \Post.timestamp, order: .reverse)
    var posts: [Post]

    @State var selectedLocation: Location?

    enum ViewMode: Hashable {
        case map
        case list
    }
    @State var viewMode: ViewMode = .map

    @ViewBuilder var content: some View {
        switch viewMode {
        case .map:
            LocationMapView(posts: posts, locations: locations)
        case .list:
            LocationListView(locations: locations)
        }
    }

    var body: some View {
        NavigationStack {
            content
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Picker("Mode", selection: $viewMode) {
                            Text("Map").tag(ViewMode.map)
                            Text("List").tag(ViewMode.list)
                        }
                        .pickerStyle(.segmented)
                    }
                }
        }
    }
}

struct LocationMapView: View {
    var posts: [Post]
    var locations: [Location]
    @State var selectedPost: Post?

    var body: some View {
        Map(selection: $selectedPost) {
            MapPolyline(coordinates: locations.map(\.coordinate))
                .stroke(.blue, lineWidth: 5)

            ForEach(posts) { post in
                if let location = post.location {
                    Marker(coordinate: location.coordinate) {
                        Text(post.title)
                    }
                    .tag(post)
                }
            }
        }
        .safeAreaInset(edge: .bottom) {
            if let selectedPost {
                Text(selectedPost.title)
            }
        }
    }
}

extension CLLocationCoordinate2D {
    static let q42 = CLLocationCoordinate2D(latitude: 52.0676294, longitude: 4.3464126)
}

#Preview(traits: .modifier(SampleData())) {
    MapView()
}
