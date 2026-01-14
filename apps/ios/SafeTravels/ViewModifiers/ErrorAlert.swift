//
//  ErrorAlert.swift
//  SafeTravels
//
//  Created by Mathijs Bernson on 25/07/2025.
//

import Foundation
import SwiftUI

extension View {
    /// Presents an alert when an error is present, with custom actions.
    func alert<E: Error, Actions: View>(
        _ title: LocalizedStringKey,
        error: Binding<E?>,
        @ViewBuilder actions: @escaping () -> Actions
    ) -> some View {
        modifier(ErrorAlert(error: error, title: title, actions: actions))
    }

    /// Presents an alert when an error is present.
    func alert<E: Error>(
        _ title: LocalizedStringKey,
        error: Binding<E?>,
        buttonTitleKey: LocalizedStringKey = "Ok"
    ) -> some View {
        modifier(ErrorAlert(error: error, title: title, actions: {
            Button(buttonTitleKey) {
                error.wrappedValue = nil
            }
        }))
    }
}

/// A modifier that presents an alert when an error is present.
private struct ErrorAlert<E: Error, ActionButton: View>: ViewModifier {
    @Binding var error: E?
    let title: LocalizedStringKey
    @ViewBuilder let actions: () -> ActionButton

    var isPresented: Bool {
        error != nil
    }

    func body(content: Content) -> some View {
        content.alert(title, isPresented: .constant(isPresented), actions: actions) {
            Text(error?.localizedDescription ?? "")
        }
    }
}

#Preview("Error alert") {
    let error = NSError(domain: "TestDomain", code: 1, userInfo: [NSLocalizedDescriptionKey: "This is a test error."])
    return Text(verbatim: "Preview text")
        .alert("An error occurred", error: .constant(error)) {
            Button("Ok") {}
        }
}
