//
//  APIClient.swift
//  SafeTravels
//
//  Created by Mathijs Bernson on 25/07/2025.
//

import Foundation

class APIClient {
    private let urlSession: URLSession
    private let credentialManager: CredentialManager

    private let encoder: JSONEncoder
    private let decoder: JSONDecoder

    init(credentialManager: CredentialManager) {
        self.urlSession = URLSession(configuration: .default)
        self.credentialManager = credentialManager
        self.encoder = JSONEncoder()
        self.encoder.dateEncodingStrategy = .iso8601
        self.decoder = JSONDecoder()
        self.decoder.dateDecodingStrategy = .iso8601
    }

    func testConnection(serverURL: String, apiToken: String) async throws {
        guard let serverURL = URL(string: serverURL) else {
            throw NSError(domain: "OnboardingServerSetupView", code: 1, userInfo: [NSLocalizedDescriptionKey : "Invalid server URL"])
        }
        guard !apiToken.isEmpty else {
            throw NSError(domain: "OnboardingServerSetupView", code: 2, userInfo: [NSLocalizedDescriptionKey : "API token cannot be empty"])
        }
        var request = URLRequest(url: serverURL.appending(path: "api/health"))
        request.setValue(apiToken, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        let (_, response) = try await urlSession.data(for: request)
        try validate(response)
    }

    private func makeRequest(_ method: String = "GET", path: String) throws -> URLRequest {
        guard let serverURL = credentialManager.serverURL else {
            throw NSError(domain: "OnboardingServerSetupView", code: 1, userInfo: [NSLocalizedDescriptionKey : "Invalid server URL"])
        }
        guard let apiToken = credentialManager.apiToken else {
            throw NSError(domain: "OnboardingServerSetupView", code: 2, userInfo: [NSLocalizedDescriptionKey : "API token cannot be empty"])
        }
        var request = URLRequest(url: serverURL.appending(path: path))
        request.setValue(apiToken, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = method
        return request
    }

    private func validate(_ response: URLResponse) throws {
        guard let urlResponse = response as? HTTPURLResponse else {
            throw NSError(domain: "APIClientError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])
        }

        guard (200...299).contains(urlResponse.statusCode) else {
            throw NSError(domain: "APIClientError", code: urlResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Server returned status code \(urlResponse.statusCode)"])
        }
    }

    private func request<Request: Encodable, Response: Decodable>(_ method: String, path: String, body: Request) async throws -> Response {
        var request = try makeRequest(method, path: path)
        request.httpBody = try encoder.encode(body)
        let (data, urlResponse) = try await urlSession.data(for: request)
        try validate(urlResponse)
        return try decoder.decode(Response.self, from: data)
    }

    private func request<Request: Encodable>(_ method: String, path: String, body: Request) async throws  {
        var request = try makeRequest(method, path: path)
        request.httpBody = try encoder.encode(body)
        let (_, urlResponse) = try await urlSession.data(for: request)
        try validate(urlResponse)
    }

    func createLocation(request: CreateLocationRequest) async throws -> CreateLocationResponse {
        return try await self.request("POST", path: "api/location", body: request)
    }

    func createFeedPost(request: CreateFeedPostRequest) async throws {
        try await self.request("POST", path: "api/feed", body: request)
    }
}

struct CreateLocationRequest: Encodable {
    let latitude: Double
    let longitude: Double
    let timestamp: Date
}

struct CreateLocationResponse: Decodable {
    let id: String
}

struct CreateFeedPostRequest: Encodable {
    enum FeedPostType: String, Encodable {
        case feedImage = "FeedImage" // Currently the only supported type
    }
    let type: FeedPostType = .feedImage
    let images: [URL]?
    let title: String
    let description: String?
    let location: FeedPostLocation?
}

struct FeedPostLocation: Encodable {
    let latitude: Double
    let longitude: Double
    let timestamp: Date
}
