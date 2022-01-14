//
//  AddSubscriptionView.swift
//  Feedex
//
//  Created by Yu-Sung Loyi Hsu on 01/10/2021.
//

import SwiftUI

struct AddSubscriptionView: View {
    // MARK: - Declaration
    @Environment(\.managedObjectContext) private var viewContext

    @State var url: String = ""
    @State var subscribedItemName: String = ""
    @State var nextStep: Bool = false

    @Binding var callerCategory: Wrapped<Category?>?

    // MARK: - View (Protocol)
    var body: some View {
        NavigationView {
            VStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 12) {
                    if nextStep {
                        TextField("Name", text: $subscribedItemName)
                            .foregroundColor(.accentColor)
                    }
                    if nextStep {
                        Text(url).foregroundColor(.secondary)
                    } else {
                        TextField("URL", text: $url)
                            .foregroundColor(.secondary)
                            .textContentType(.URL)
                            .keyboardType(.URL)
                    }
                }
                if !nextStep {
                    Button("Search") {
                        UIApplication.shared.resignFirstResponder()
                        if let document = checkAndFetchXML(url),
                           let title = try? document.title() {
                            subscribedItemName = title
                            nextStep = true
                        }
                    }
                }
                Spacer()

            }
            .padding()
            .navigationTitle("Add Subscription")
            .navigationBarItems(leading: Button("Close") {
                callerCategory = nil
            }, trailing: Button("Add") {
                addSubscriptionItem(name: subscribedItemName,
                                    url: url,
                                    category: callerCategory?.item)
                nextStep = false
                callerCategory = nil
                subscribedItemName = ""
                url = ""
            }.disabled(!nextStep))
        }
    }

    // MARK: - CoreData
    private func addSubscriptionItem(name: String, url: String, category: Category? = nil) {
        withAnimation {
            let newItem = Website(context: viewContext)
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
}
