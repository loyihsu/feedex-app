//
//  AddCategoryView.swift
//  Feedex
//
//  Created by Yu-Sung Loyi Hsu on 01/10/2021.
//

import SwiftUI

struct AddCategoryView: View {
    // MARK: - Declaration
    @Environment(\.managedObjectContext) private var viewContext

    @State var newCategoryName = ""

    @Binding var addCategoryIsPresented: Bool

    // MARK: - View (Protocol)
    var body: some View {
        NavigationView {
            VStack {
                TextField("Category Name", text: $newCategoryName)
                Spacer()
            }
            .padding()
            .navigationTitle("Add Category")
            .navigationBarItems(leading: Button("Close") {
                addCategoryIsPresented = false
            }, trailing: Button(action: {
                addCategory(name: newCategoryName)
                addCategoryIsPresented = false
            }) {
                Text("Add")
                    .bold()
                    .disabled(newCategoryName.isEmpty)
            })
        }
    }

    // MARK: - CoreData
    private func addCategory(name: String) {
        withAnimation {
            let newItem = Category(context: viewContext)
            newItem.name = name
            newItem.date = Date()

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
