//
//  PostsView.swift
//  SafeTravels
//
//  Created by Mathijs Bernson on 09/07/2025.
//

import SwiftUI
import SwiftData

struct PostsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Post]
    @State var presentWritePostView = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(items) { item in
                    NavigationLink {
                        Text(item.title)
                    } label: {
                        Text(item.title)
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .overlay {
                if items.isEmpty {
                    ContentUnavailableView(
                        "No Posts",
                        systemImage: "book.pages.fill",
                        description: Text("You haven't added any posts yet. Tap the plus button to add a new post.")
                    )
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button {
                        presentWritePostView = true
                    } label: {
                        Label("Compose", systemImage: "square.and.pencil")
                    }
                }
            }
            .navigationTitle("Posts")
            .sheet(isPresented: $presentWritePostView) {
                NavigationStack {
                    PostComposeView()
                }
                .interactiveDismissDisabled()
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

#Preview(traits: .modifier(SampleData())) {
    PostsView()
}

#Preview("Empty") {
    PostsView()
}
