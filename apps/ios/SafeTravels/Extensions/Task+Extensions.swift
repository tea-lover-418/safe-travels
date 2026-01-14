//
//  Task+Extensions.swift
//  SafeTravels
//
//  Created by Mathijs Bernson on 25/07/2025.
//

import Foundation

extension Task where Failure == Never, Success == Never {
    static func sleep(seconds: Double) async throws {
        try await sleep(nanoseconds: UInt64(seconds * Double(NSEC_PER_SEC)))
    }
}
