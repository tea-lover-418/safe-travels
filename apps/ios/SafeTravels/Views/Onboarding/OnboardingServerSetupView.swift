//
//  OnboardingServerSetupView.swift
//  SafeTravels
//
//  Created by Mathijs Bernson on 25/07/2025.
//

import FactoryKit
import SwiftUI

struct OnboardingServerSetupView: View {
    @State var serverURL: String = ""
    @State var apiToken: String = ""

    @State var connectionTestResult: Result<Void, Error>?
    @State var credentialsError: Error?

    @Injected(\.apiClient) var apiClient
    @InjectedObservable(\.credentialManager) var credentialManager

    var isValid: Bool {
        guard let _ = URL(string: serverURL), !apiToken.isEmpty else { return false }
        if case .success = connectionTestResult {
            return true
        } else {
            return false
        }
    }

    let action: () -> Void

    var body: some View {
        OnboardingPage("Configure server") {
            Text("You need to set up a SafeTravel server instance")

            VStack(alignment: .leading, spacing: 16) {
                LabeledContent("Server URL") {
                    TextField("Server URL", text: $serverURL)
                        .textContentType(.URL)
                        .textInputAutocapitalization(.never)
                }
                LabeledContent("API Token") {
                    TextField("API Token", text: $apiToken)
                        .autocorrectionDisabled()
                        .textContentType(.password)
                        .textInputAutocapitalization(.never)
                }

                AsyncButton("Test connection") {
                    await testConnection()
                }

                if let connectionTestResult {
                    ConnectionTestResultLabel(result: connectionTestResult)
                }
            }
            .labeledContentStyle(FormFieldLabeledContentStyle())
            .textFieldStyle(.roundedBorder)
        } actions: {
            Button("Continue") {
                do {
                    try credentialManager.setCredentials(serverURL: URL(string: serverURL)!, apiToken: apiToken)
                    action()
                } catch {
                    self.credentialsError = error
                }
            }
            .disabled(!isValid)
            Button("Set up later") {
                action()
            }
            .buttonStyle(.plain)
        }
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
}

struct ConnectionTestResultLabel: View {
    let result: Result<Void, Error>

    var body: some View {
        switch result {
        case .success:
            Label {
                Text("Connection successful")
            } icon: {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(.green)
            }
        case .failure(let error):
            Label {
                Text("Error: \(error.localizedDescription)")
            } icon: {
                Image(systemName: "exclamationmark.circle.fill")
                    .foregroundStyle(.red)
            }
        }
    }
}

struct FormFieldLabeledContentStyle: LabeledContentStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            configuration.label
                .font(.headline)
            configuration.content
        }
    }
}

#Preview {
    OnboardingServerSetupView(action: {})
}
