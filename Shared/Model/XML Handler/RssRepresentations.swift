//
//  RssRepresentations.swift
//  Feedex (iOS)
//
//  Created by Yu-Sung Loyi Hsu on 20/10/2021.
//

import Foundation

class RssList: ObservableObject {
    @Published var list: [RssRepresentation] = []

    init () { }
    init(list: [RssRepresentation]) {
        self.list = list
    }
}

class RssRepresentation: Identifiable, Equatable {
    static func == (lhs: RssRepresentation, rhs: RssRepresentation) -> Bool {
        lhs.id == rhs.id
    }

    let id = UUID()
    var read = false

    let title: String
    let link: String
    let date: Date
    let content: String

    let sourceName: String

    init(title: String, link: String, date: Date, content: String, sourceName: String) {
        self.title = title
        self.link = link
        self.date = date
        self.content = content
        self.sourceName = sourceName
    }

}
