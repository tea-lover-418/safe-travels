//
//  ServerConfigurationView.swift
//  SafeTravels
//
//  Created by Mathijs Bernson on 25/07/2025.
//

import FactoryKit
import SwiftUI

struct ServerConfigurationView: View {
    @Injected(\.apiClient) var apiClient
    @InjectedObservable(\.credentialManager) var credentialManager

    @State var serverURL: String = ""
    @State var apiToken: String = ""
    @State var connectionTestResult: Result<Void, Error>?
    @State var credentialsError: Error?

    var body: some View {
        Form {
            Section(header: Text("Server Configuration")) {
                TextField("Server URL", text: $serverURL)
                    .textContentType(.URL)
                    .keyboardType(.URL)
                    .autocapitalization(.none)

                TextField("API Token", text: $apiToken)
                    .textContentType(.password)
                    .autocapitalization(.none)

                Button("Save") {
                    saveConfiguration()
                }
            }

            Section(header: Text("Connection Test")) {
                AsyncButton("Test connection") {
                    await testConnection()
                }
                if let connectionTestResult {
                    ConnectionTestResultLabel(result: connectionTestResult)
                }
            }
        }
        .task {
            serverURL = credentialManager.serverURL?.absoluteString ?? ""
            apiToken = credentialManager.apiToken ?? ""
        }
        .navigationTitle("Server Configuration")
        .alert("Failed to store credentials", error: $credentialsError)
    }

    func testConnection() async {
        do {
            try await apiClient.testConnection(serverURL: serverURL, apiToken: apiToken)
            connectionTestResult = .success(())
        } catch {
            connectionTestResult = .failure(error)
        }
    }

    func saveConfiguration() {
        do {
            try credentialManager.setCredentials(serverURL: URL(string: serverURL)!, apiToken: apiToken)
        } catch {
            self.credentialsError = error
        }
    }
}

#Preview {
    ServerConfigurationView()
}
