//
//  FullWidthProminentButtonStyle.swift
//  SafeTravels
//
//  Created by Mathijs Bernson on 25/07/2025.
//

import SwiftUI

struct FullWidthProminentButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) var isEnabled

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.title3.weight(.semibold))
            .padding()
            .frame(maxWidth: .infinity)
            .background(isEnabled ? .blue : .gray)
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .contentShape(Rectangle())
            .opacity(configuration.isPressed ? 0.7 : 1.0)
    }
}

extension ButtonStyle where Self == FullWidthProminentButtonStyle {
    static var fullWidthProminent: Self { Self() }
}

#Preview {
    Button("Continue") {
        print("Hello world")
    }
    .buttonStyle(.fullWidthProminent)
    .padding()
}
