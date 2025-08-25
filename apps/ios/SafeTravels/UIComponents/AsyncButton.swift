//
//  AsyncButton.swift
//  SafeTravels
//
//  Created by Mathijs Bernson on 25/07/2025.
//

import SwiftUI

// Thanks to Swift by Sundell: https://www.swiftbysundell.com/articles/building-an-async-swiftui-button/

struct AsyncButton<Label: View>: View {
    var role: ButtonRole?
    var action: () async -> Void
    var actionOptions = Set(ActionOption.allCases)
    @ViewBuilder var label: () -> Label

    @State private var isDisabled = false
    @State private var showProgressView = false

    var body: some View {
        Button(
            role: role,
            action: {
                if actionOptions.contains(.disableButton) {
                    isDisabled = true
                }

                Task {
                    var progressViewTask: Task<Void, Error>?

                    if actionOptions.contains(.showProgressView) {
                        progressViewTask = Task {
                            try await Task.sleep(nanoseconds: 150_000_000)
                            showProgressView = true
                        }
                    }

                    await action()
                    progressViewTask?.cancel()

                    isDisabled = false
                    showProgressView = false
                }
            },
            label: {
                ZStack {
                    label().opacity(showProgressView ? 0 : 1)

                    if showProgressView {
                        ProgressView()
                    }
                }
            }
        )
        .disabled(isDisabled)
    }
}

extension AsyncButton {
    enum ActionOption: CaseIterable {
        case disableButton
        case showProgressView
    }
}

extension AsyncButton where Label == Text {
    init(_ label: LocalizedStringKey,
         role: ButtonRole? = nil,
         actionOptions: Set<ActionOption> = Set(ActionOption.allCases),
         action: @escaping () async -> Void) {
        self.init(role: role, action: action) {
            Text(label)
        }
    }

    init(verbatim label: String,
         role: ButtonRole? = nil,
         actionOptions: Set<ActionOption> = Set(ActionOption.allCases),
         action: @escaping () async -> Void) {
        self.init(role: role, action: action) {
            Text(label)
        }
    }
}

extension AsyncButton where Label == Image {
    init(imageName: String,
         role: ButtonRole? = nil,
         actionOptions: Set<ActionOption> = Set(ActionOption.allCases),
         action: @escaping () async -> Void) {
        self.init(role: role, action: action) {
            Image(imageName)
        }
    }

    init(systemImageName: String,
         role: ButtonRole? = nil,
         actionOptions: Set<ActionOption> = Set(ActionOption.allCases),
         action: @escaping () async -> Void) {
        self.init(role: role, action: action) {
            Image(systemName: systemImageName)
        }
    }
}

#Preview("Slow action") {
    AsyncButton(verbatim: "Async Button") {
        try? await Task.sleep(seconds: 3)
    }
}

#Preview("Fast action") {
    AsyncButton(verbatim: "Async Button") {
        try? await Task.sleep(seconds: 0.1)
    }
}
