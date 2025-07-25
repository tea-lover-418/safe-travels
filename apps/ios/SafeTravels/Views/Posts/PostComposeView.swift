//
//  PostComposeView.swift
//  SafeTravels
//
//  Created by Mathijs Bernson on 23/07/2025.
//

import SwiftUI
import SwiftData
import CoreLocation
import MapKit
import FactoryKit

struct PostComposeView: View {
    enum LocationStatus {
        case loading
        case success(CLLocation)
        case error(Error)

        var location: Location? {
            if case .success(let clLocation) = self {
                return Location(clLocation: clLocation)
            } else {
                return nil
            }
        }
    }

    @State var title: String = ""
    @State var text: String = ""
    @State var addLocation = true
    @State var location: LocationStatus?
    @State var error: Error?

    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss

    @Injected(\.apiClient) var apiClient

    var body: some View {
        Form {
            Section("Title") {
                TextField("Title", text: $title)
            }
            Section {
                TextEditor(text: $text)
            } header: {
                Text("Text")
            } footer: {
                Text("You can use markdown: _\\_italic\\__ **\\*\\*bold\\*\\***")
            }

            if let location {
                Section("Location") {
                    Toggle("Add current location", isOn: $addLocation)
                    switch location {
                    case .loading:
                        ProgressView()
                    case .success(let location):
                        Map {
                            Marker("Current Location", coordinate: location.coordinate)
                        }
                        .aspectRatio(16 / 9, contentMode: .fill)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    case .error(let error):
                        Text("Error requesting location: \(error.localizedDescription)")
                    }
                }
            }
        }
        .alert("Error creating post", error: $error)
        .task {
            await requestLocation()
        }
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                AsyncButton("Save") {
                    if await savePost() {
                        dismiss()
                    }
                }
            }
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel", role: .cancel) {
                    dismiss()
                }
            }
        }
    }

    func requestLocation() async {
        location = .loading
        let requester = LocationRequester()
        do {
            if let clLocation = try await requester.requestCurrentLocation() {
                location = .success(clLocation)
            }
        } catch {
            location = .error(error)
        }
    }

    func savePost() async -> Bool {
        do {
            let location: Location? = location?.location
            let post = Post(title: title, body: text, timestamp: .now, location: location)
            modelContext.insert(post)
            try modelContext.save()

            let request = CreateFeedPostRequest(images: [], title: title, description: text, location: location.flatMap {
                FeedPostLocation(latitude: $0.latitude, longitude: $0.longitude, timestamp: $0.timestamp)
            })
            try await apiClient.createFeedPost(request: request)

            return true
        } catch {
            self.error = error
            return false
        }
    }
}

#Preview {
    PostComposeView()
}
