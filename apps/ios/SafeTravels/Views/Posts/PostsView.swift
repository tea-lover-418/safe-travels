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

    var body: some View {
        NavigationSplitView {
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
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
            .navigationTitle("Posts")
        } detail: {
            Text("Select an item")
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Post(title: "Hello World", body: "This is the _body_", timestamp: .now, location: .example)
            modelContext.insert(newItem)
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
