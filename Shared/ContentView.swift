//
//  ContentView.swift
//  Shared
//
//  Created by Loyi Hsu on 2021/9/29.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \SubscriptionCategory.name, ascending: true)],
        animation: .default)
    private var categories: FetchedResults<SubscriptionCategory>

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \SubscriptionItem.name, ascending: true)],
        animation: .default)
    private var items: FetchedResults<SubscriptionItem>


    var body: some View {
        NavigationView {
            List {
                Button("All Items") {

                }

                ForEach(categories) { category in
                    Section(category.name ?? "") {
                        ForEach(items.filter({ $0.category == category })) { item in
                            Button("\(item.name!)") { }
                        }
                        Button(action: {
                            addSubscriptionItem(name: "New Item in \(category.name!)", url: "Some URL", category: category.self)
                        }, label: {
                            Text("Add New Item")
                                .foregroundColor(.secondary)
                        })
                    }
                }

                ForEach(items.filter({ $0.category == nil })) { item in
                    Button("\(item.name!)") { }
                }
                Button(action: {
                    addSubscriptionItem(name: "New Item with no category", url: "Some url")
                }) {
                    Text("Add new item")
                        .foregroundColor(.secondary)
                }
            }
            .toolbar {
                ToolbarItem {
                    Button(action: {
                        addCategory(name: "New Category \(categories.count)")
                    }) {
                        Label("Add Category", systemImage: "plus")
                    }
                }
            }
            .navigationTitle("Feedex")
        }
    }

    private func addSubscriptionItem(name: String, url: String, category: SubscriptionCategory? = nil) {
        withAnimation {
            let newItem = SubscriptionItem(context: viewContext)
            newItem.name = name
            newItem.url = url
            newItem.category = category

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

    private func addCategory(name: String) {
        withAnimation {
            let newItem = SubscriptionCategory(context: viewContext)
            newItem.name = name

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

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

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

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//
//    }
//}
