//
//  CredentialsManagerTest.swift
//  SafeTravelsTests
//
//  Created by Mathijs Bernson on 25/07/2025.
//

import Foundation
import Testing
import Security
@testable import SafeTravels

class CredentialsManagerTest {

    @Test("Store and retrieve credentials")
    func store() throws {
        let credentialManager = CredentialManager()
        #expect(credentialManager.apiToken == nil)
        #expect(credentialManager.serverURL == nil)

        // Store dummy credentials
        let serverURL = URL(string: "https://example.com")!
        let apiToken = "dummyToken"
        try credentialManager.setCredentials(serverURL: serverURL, apiToken: apiToken)
        #expect(credentialManager.apiToken == apiToken)
        #expect(credentialManager.serverURL == serverURL)

        let credentialManager2 = CredentialManager()
        #expect(credentialManager2.apiToken == apiToken)
        #expect(credentialManager2.serverURL == serverURL)
    }

    deinit {
        let updateOrDeleteQuery: [String: Any] = [
            kSecClass as String: kSecClassInternetPassword,
            kSecAttrAccount as String: "SafeTravelUser",
        ]

        let status = SecItemDelete(updateOrDeleteQuery as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            fatalError("Failed to delete existing credentials from Keychain, OSStatus \(status)")
        }
    }
}
