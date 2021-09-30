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

    @State var callerCategory: Wrapped<SubscriptionCategory?>? = nil
    @State var addCategoryIsPresented = false

    @State var addUrl: String = ""
    @State var addItemName: String = ""
    @State var urlStep2: Bool = false

    @State var newCategoryName = ""

    var body: some View {
        NavigationView {
            List {
                Section {
                    Button("All Items") {

                    }
                }


                ForEach(categories) { category in
                    Section(category.name ?? "") {
                        if items.contains(where: { $0.category == category}) {
                            Button("All items") { }
                        }
                        ForEach(items.filter({ $0.category == category })) { item in
                            Button(action: {

                            }) {
                                VStack(alignment: .leading) {
                                    if item.name! != item.url! {
                                        Text("\(item.name!)")
                                        Text("\(item.url!)")
                                            .foregroundColor(.secondary)
                                            .font(.caption)
                                    } else {
                                        Text("\(item.url!)")
                                    }
                                }
                            }
                        }
                        .onDelete { offsets in
                            let list = items.filter({ $0.category == category })
                            deleteSubscriptionItems(offsets: offsets, list: list)
                        }

                        Button(action: {
                            callerCategory = Wrapped(category.self)
                        }, label: {
                            Text("Add New Item")
                                .foregroundColor(.secondary)
                        })
                    }
                }

                ForEach(items.filter({ $0.category == nil })) { item in
                    Button(action: {

                    }) {
                        VStack(alignment: .leading) {
                            if item.name! != item.url! {
                                Text("\(item.name!)")
                                Text("\(item.url!)")
                                    .foregroundColor(.secondary)
                                    .font(.caption)
                            } else {
                                Text("\(item.url!)")
                            }
                        }
                    }
                }
                .onDelete { offsets in
                    let list = items.filter({ $0.category == nil })
                    deleteSubscriptionItems(offsets: offsets, list: list)
                }

                Button(action: {
                    callerCategory = Wrapped<SubscriptionCategory?>(nil)
                }) {
                    Text("Add New item")
                        .foregroundColor(.secondary)
                }
                .sheet(item: $callerCategory) { wrappedCategory in
                    NavigationView {
                        VStack(spacing: 24) {
                            TextField("URL", text: $addUrl)
                            if !urlStep2 {
                                Button("Search") {
                                    if let document = checkAndFetchXML(addUrl),
                                       let title = try? document.title() {
                                        addItemName = title
                                        urlStep2 = true
                                    }
                                }
                                Spacer()
                            }
                            if urlStep2 {
                                TextField("Name", text: $addItemName)
                                Spacer()
                            }
                        }
                        .padding()
                        .navigationTitle("Add Subscription")
                        .navigationBarItems(leading: Button("Close") {
                            callerCategory = nil
                        }, trailing: Button("Add") {
                            addSubscriptionItem(name: addItemName,
                                                url: addUrl,
                                                category: wrappedCategory.item)
                            urlStep2 = false
                            callerCategory = nil
                            addItemName = ""
                            addUrl = ""
                        }.disabled(!urlStep2))
                    }
                }
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
            .navigationTitle("Feedex")
            .sheet(isPresented: $addCategoryIsPresented) {
                NavigationView {
                    VStack {
                        TextField("Category Name", text: $newCategoryName)
                        Spacer()
                    }
                    .padding()
                    .navigationTitle("Add Category")
                    .navigationBarItems(leading: Button("Close") {
                        addCategoryIsPresented = false
                    }, trailing: Button("Add") {
                        addCategory(name: newCategoryName)
                        newCategoryName = ""
                        addCategoryIsPresented = false
                    })
                }
            }
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

    private func deleteSubscriptionItems(offsets: IndexSet, list: [SubscriptionItem]) {
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
