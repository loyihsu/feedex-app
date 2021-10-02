//
//  FeedList.swift
//  Feedex
//
//  Created by Yu-Sung Loyi Hsu on 03/10/2021.
//

import SwiftUI

struct FeedList: View {
    var contents: [RssRepresentation]

    var body: some View {
        List(contents) { item in
            VStack (alignment: .leading, spacing: 4) {
                Text(item.title)
                    .bold()
                HStack (spacing: 5) {
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

struct FeedList_Previews: PreviewProvider {
    static var previews: some View {
        let contents: [RssRepresentation] = [
            .init(title: "Some title", link: "https://www.google.com", date: Date(), content: "The content goes here.", sourceName: "Google"),
            .init(title: "Some title", link: "https://www.facebook.com", date: Date(), content: "The content goes here.", sourceName: "Facebook"),
            .init(title: "Some title", link: "https://www.google.com", date: Date(), content: "The content goes here.", sourceName: "Google"),
            .init(title: "Some title", link: "https://www.facebook.com", date: Date(), content: "The content goes here.", sourceName: "Facebook"),
            .init(title: "Some title", link: "https://www.facebook.com", date: Date(), content: "The content goes here.", sourceName: "Facebook")
        ]

        FeedList(contents: contents)
    }
}
