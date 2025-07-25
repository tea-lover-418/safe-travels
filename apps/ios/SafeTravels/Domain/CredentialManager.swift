//
//  CredentialManager.swift
//  SafeTravels
//
//  Created by Mathijs Bernson on 25/07/2025.
//

import Foundation
import Security
import os.log

@Observable
class CredentialManager {
    private(set) var serverURL: URL?
    private(set) var apiToken: String?

    private let account = "SafeTravelUser"
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "CredentialManager")

    init() {
        loadCredentials()
    }

    func setCredentials(serverURL: URL, apiToken: String) throws {
        self.serverURL = serverURL
        self.apiToken = apiToken

        guard let host = serverURL.host() else {
            throw NSError(domain: NSURLErrorDomain, code: NSURLErrorBadURL, userInfo: [NSLocalizedDescriptionKey : "Invalid server URL"])
        }
        guard let `protocol` = serverURL.scheme, `protocol` == "http" || `protocol` == "https" else {
            throw NSError(domain: NSURLErrorDomain, code: NSURLErrorBadURL, userInfo: [NSLocalizedDescriptionKey : "Invalid server URL scheme"])
        }
        guard let apiTokenData = apiToken.data(using: .utf8) else {
            throw NSError(domain: "SafeTravelsErrorDomain", code: 1, userInfo: [NSLocalizedDescriptionKey : "Failed to convert API token to Data"])
        }
        try deleteItems()
        try insertItem(server: host, protocol: `protocol`, apiToken: apiTokenData)
        logger.info("Credentials stored successfully in Keychain")
    }

    private func loadCredentials() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassInternetPassword,
            kSecAttrAccount as String: account,
            kSecReturnAttributes as String: true,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)

        if status == errSecSuccess, let existingItem = item as? [String: Any],
           let server = existingItem[kSecAttrServer as String] as? String,
           let `protocol` = existingItem[kSecAttrProtocol as String] as? String,
           let apiTokenData = existingItem[kSecValueData as String] as? Data {
            self.serverURL = URL(string: "\(`protocol`)://\(server)")
            self.apiToken = String(data: apiTokenData, encoding: .utf8)
            logger.info("Credentials loaded successfully from Keychain")
        } else if status == errSecItemNotFound {
            logger.info("No credentials found in Keychain")
        } else {
            logger.error("Failed to load credentials from Keychain, OSStatus \(status)")
        }
    }

    private func deleteItems() throws {
        let updateOrDeleteQuery: [String: Any] = [
            kSecClass as String: kSecClassInternetPassword,
            kSecAttrAccount as String: account,
        ]

        let status = SecItemDelete(updateOrDeleteQuery as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            logger.error("Failed to delete existing credentials from Keychain, OSStatus \(status)")
            throw NSError(domain: NSOSStatusErrorDomain, code: Int(status), userInfo: [NSLocalizedDescriptionKey : "Failed to store credentials in Keychain"])
        }
    }

    private func insertItem(server: String, protocol: String, apiToken: Data) throws {
        let addQuery: [String: Any] = [
            kSecClass as String: kSecClassInternetPassword,
            kSecAttrServer as String: server,
            kSecAttrProtocol as String: `protocol`,
            kSecAttrAccount as String: account,
            kSecValueData as String: apiToken,
            // Disable iCloud Keychain synchronization for this item
            kSecAttrSynchronizable as String: false,
        ]
        let status = SecItemAdd(addQuery as CFDictionary, nil)
        guard status == errSecSuccess else {
            logger.error("Failed to store credentials in Keychain, OSStatus \(status)")
            throw NSError(domain: NSOSStatusErrorDomain, code: Int(status), userInfo: [NSLocalizedDescriptionKey : "Failed to store credentials in Keychain"])
        }
    }

    func clearCredentials() {
        serverURL = nil
        apiToken = nil
    }
}
