//
//  PostsEditor.swift
//  SafeTravels
//
//  Created by Mathijs Bernson on 23/07/2025.
//

import SwiftUI

struct PostsEditor: View {
//    @State private var text: AttributedString = ""
//    @State private var selection = AttributedTextSelection()
//    @Environment(\.fontResolutionContext) private var fontResolutionContext

    @State private var text: String = ""

    var body: some View {
        TextEditor(text: $text)
    }

//    var body: some View {
//        TextEditor(text: $text, selection: $selection)
//            .toolbar {
//                // A toggle controlling whether the current selection in the
//                // editor has bold font.
//                Toggle(
//                    "Toggle Boldness",
//                    systemImage: "bold",
//                    isOn: Binding(get: {
//                        // Get the font for the current selection.
//                        let font = selection.typingAttributes(in: text).font
//                        // Resolve the font in the current environment.
//                        let resolved = (font ?? .default).resolve(in: fontResolutionContext)
//                        // Return whether the resolved font is bold.
//                        return resolved.isBold
//                    }, set: { isBold in
//                        // Update each run in the current selection, including
//                        // the typing attributes, to reflect the new `isBold`
//                        // value.
//                        text.transformAttributes(in: &selection) {
//                            // Override the boldness of the font. If no font is
//                            // present, use `Font.default` for the effective
//                            // environment font as the basis.
//                            $0.font = ($0.font ?? .default).bold(isBold)
//                        }
//                    })
//                )
//            }
//    }
}

#Preview {
    PostsEditor()
}
