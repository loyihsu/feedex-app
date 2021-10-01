//
//  ContentView.swift
//  Shared
//
//  Created by Loyi Hsu on 2021/9/29.
//

import SwiftUI
import CoreData

struct ContentView: View {
    // MARK: - Declaration
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \SubscriptionCategory.date, ascending: true)],
        animation: .default)
    private var categories: FetchedResults<SubscriptionCategory>

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \SubscriptionItem.name, ascending: true)],
        animation: .default)
    private var items: FetchedResults<SubscriptionItem>

    @State var callerCategory: Wrapped<SubscriptionCategory?>? = nil
    @State var addCategoryIsPresented = false

    // MARK: - View (Protocol)
    var body: some View {
        NavigationView {
            List {
                createAllFeedsSection()
                createAllCategorySections()
                createUncategoriedSection()

            }
            .popover(isPresented: $addCategoryIsPresented) {
                AddCategoryView(addCategoryIsPresented: $addCategoryIsPresented)
            }
            .sheet(item: $callerCategory) { _ in
                AddSubscriptionView(callerCategory: $callerCategory)
            }
            .toolbar {
#if os(iOS)
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
#endif
                ToolbarItem {
                    Button(action: {
                        addCategoryIsPresented = true
                    }) {
                        Label("Add Category", systemImage: "plus")
                    }
                }
            }
            .navigationBarTitle("Feedex")
        }
    }

    // MARK: - Sections

    private func createAllFeedsSection() -> some View {
        Section {
            // This section is for feed from all the subscribed channels.
            Button("All Feeds") {
                let result = items
                    .flatMap({ fetchXMLContents($0.url!, source: $0.name ?? "")})
                    .sorted(by: { $0.date > $1.date })
                result.forEach {
                    print("\($0.title): \($0.date) - \($0.sourceName)")
                }
            }
        }
    }

    private func createAllCategorySections() -> some View {
        // This part of code will create a section for all the categories.
        ForEach(categories) { category in
            Section(category.name ?? "") {
                if items.contains(where: { $0.category == category}) {
                    // Each category will have an 'all feeds' item.
                    Button("All in \(category.name ?? "")") {
                        let allItems = items.filter({ $0.category == category })
                        let result = allItems
                            .flatMap({ fetchXMLContents($0.url!, source: $0.name ?? "")})
                            .sorted(by: { $0.date > $1.date })
                        result.forEach {
                            print("\($0.title): \($0.date) - \($0.sourceName)")
                        }
                    }
                }

                // This part will display all the subscribed items.
                ForEach(items.filter({ $0.category == category })) { item in
                    Button(action: {
                        print(fetchXMLContents(item.url!, source: item.name ?? ""))
                    }) {
                        generateSubscriptionItemRepresentation(from: item)
                    }
                }
                .onDelete { offsets in
                    let list = items.filter({ $0.category == category })
                    deleteSubscriptionItems(offsets: offsets, from: list)
                }

                // An 'Add Subscription' button is available at the end of each category
                Button(action: {
                    callerCategory = Wrapped(category.self)
                }) {
                    Text("Add Subscription")
                        .foregroundColor(.secondary)
                }
            }
        }
    }

    private func createUncategoriedSection() -> some View {
        // This part is for the items without a category.
        Section("Uncategorised") {
            if items.contains(where: {$0.category == nil}) {
                Button("All in Uncategorised") {
                    let allItems = items.filter({ $0.category == nil })
                    let result = allItems
                        .flatMap({ fetchXMLContents($0.url!, source: $0.name ?? "")})
                        .sorted(by: { $0.date > $1.date })
                    result.forEach {
                        print("\($0.title): \($0.date) - \($0.sourceName)")
                    }
                }
            }

            ForEach(items.filter({ $0.category == nil })) { item in
                Button(action: {
                    print(fetchXMLContents(item.url!, source: item.name ?? ""))
                }) {
                    generateSubscriptionItemRepresentation(from: item)
                }
            }
            .onDelete { offsets in
                let list = items.filter({ $0.category == nil })
                deleteSubscriptionItems(offsets: offsets, from: list)
            }

            Button(action: {
                callerCategory = Wrapped<SubscriptionCategory?>(nil)
            }) {
                Text("Add Subscription")
                    .foregroundColor(.secondary)
            }
        }
    }

    private func generateSubscriptionItemRepresentation(from item: SubscriptionItem) -> some View {
        VStack(alignment: .leading) {
            if let name = item.name, name != "" {
                Text("\(name)")
                if name != item.url! {
                    Text("\(item.url!)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            } else {
                Text("\(item.url!)")
                    .font((item.name ?? "") != "" ? .caption : .body)
                    .foregroundColor((item.name ?? "") != "" ? .secondary : .accentColor)
            }
        }
    }

    // MARK: - CoreData
    private func deleteSubscriptionItems(offsets: IndexSet, from list: [SubscriptionItem]) {
        withAnimation {
            offsets.map { list[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}