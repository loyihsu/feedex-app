//
//  FeedList.swift
//  Feedex
//
//  Created by Yu-Sung Loyi Hsu on 03/10/2021.
//

import SwiftUI

struct FeedList: View {
    @ObservedObject var contents = RssList()

    var body: some View {
        List(contents.list) { item in
            Button(action: {
                contents.list[contents.list.firstIndex(of: item)!].read = true
                print(item.read)
                print(contents.list[contents.list.firstIndex(of: item)!].read)
            }) {
                VStack (alignment: .leading, spacing: 4) {
                    HStack {
                        Circle()
                            .frame(width: 10, height: 10)
                            .foregroundColor(.blue)
                            .opacity(0.75)
                        if item.read == false {
                            Text(item.title)
                                .bold()
                                .foregroundColor(Color(.label))
                        }
                    }
                    HStack (spacing: 5) {
                        Circle()
                            .frame(width: 10, height: 10)
                            .opacity(0)
                        Text(item.sourceName)
                        Text("·")
                        Text(item.date, format: .dateTime)
                    }
                    .font(.caption)
                    .foregroundColor(.secondary)
                }
                .padding(6)
            }

        }
    }
}

struct FeedList_Previews: PreviewProvider {
    static var previews: some View {
        let contents: [RssRepresentation] = [
            .init(title: "Some title", link: "https://www.google.com", date: Date(), content: "The content goes here.", sourceName: "Google"),
            .init(title: "Some title", link: "https://www.facebook.com", date: Date(), content: "The content goes here.", sourceName: "Facebook"),
            .init(title: "Some title", link: "https://www.google.com", date: Date(), content: "The content goes here.", sourceName: "Google"),
            .init(title: "Some title", link: "https://www.facebook.com", date: Date(), content: "The content goes here.", sourceName: "Facebook"),
            .init(title: "Some title", link: "https://www.facebook.com", date: Date(), content: "The content goes here.", sourceName: "Facebook")
        ]

        FeedList(contents: RssList(list: contents))
    }
}
