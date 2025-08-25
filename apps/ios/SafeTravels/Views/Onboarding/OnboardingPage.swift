//
//  OnboardingPage.swift
//  SafeTravels
//
//  Created by Mathijs Bernson on 25/07/2025.
//

import SwiftUI

struct OnboardingPage<Title: View, Content: View, Actions: View>: View {
    @ViewBuilder var title: () -> Title
    @ViewBuilder var content: () -> Content
    @ViewBuilder var actions: () -> Actions

    var body: some View {
        VStack(spacing: 24) {
            title()
                .multilineTextAlignment(.center)

            ScrollView {
                content()
            }

            actions()
                .buttonStyle(.fullWidthProminent)
        }
        .padding(.horizontal, 32)
        .padding(.vertical)
    }
}

extension OnboardingPage {
    init(
        _ title: LocalizedStringResource,
        @ViewBuilder content: @escaping () -> Content,
        @ViewBuilder actions: @escaping () -> Actions
    ) where Title == Text {
        self.title = {
            Text(title)
                .font(.largeTitle.bold())
        }
        self.content = content
        self.actions = actions
    }
}

#Preview {
    OnboardingPage {
            Text(verbatim: "Welcome to\nSafeTravels")
                .font(.largeTitle.bold())
                .multilineTextAlignment(.center)

            Text(verbatim: "The privacy friendly travel diary, for self hosting.")
                .fontWeight(.medium)
    } content: {
        Text(verbatim: "This is the content")
    } actions: {
        Button("Continue") {
        }
    }
}
