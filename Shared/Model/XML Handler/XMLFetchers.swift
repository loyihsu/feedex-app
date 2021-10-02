//
//  XMLFetcher.swift
//  Feedex (iOS)
//
//  Created by Yu-Sung Loyi Hsu on 01/10/2021.
//

import Foundation
import SwiftSoup

let dateFormatter = DateFormatter()

struct RssRepresentation: Identifiable {
    let id = UUID()
    let title: String
    let link: String
    let date: Date
    let content: String

    let sourceName: String
}

func checkAndFetchXML(_ url: String) -> Document? {
    guard let url = URL(string: url) else { return nil }
    guard let content = try? String(contentsOf: url) else { return nil }
    return try? SwiftSoup.parse(content, "", Parser.xmlParser())
}

func fetchXMLContents(_ url: String, source: String) -> [RssRepresentation] {
    var output = [RssRepresentation]()
    if let document = checkAndFetchXML(url) {
        for search in ["item", "entry"] {
            if output.isEmpty == false {
                break
            }
            if let items = try? document.getElementsByTag(search) {
                let titles = items
                    .compactMap({ try? $0.getElementsByTag("title").text() })
                let links = items
                    .compactMap({ try? $0.getElementsByTag("link").text() })

                var dates: [Date] = []

                for dateSearch in ["pubDate", "updated", "published"] {
                    for formatSearch in ["E, d MMM yyyy HH:mm:ss Z", "yyyy-MM-dd'T'HH:mm:ssZ"] {
                        dateFormatter.dateFormat = formatSearch
                        if dates.isEmpty == false {
                            break
                        }
                        dates = items
                            .compactMap({ try? $0.getElementsByTag(dateSearch).text()})
                            .compactMap({ dateFormatter.date(from: $0) })
                    }
                }

                var contents = items
                    .compactMap({ try? $0.getElementsByTag("content:encoded").text() })
                    .filter({ !$0.isEmpty })

                if contents.isEmpty {
                    contents = items
                        .compactMap({ try? $0.getElementsByTag("description").text()})
                }

                let elems = (0..<titles.count)
                    .map({ RssRepresentation(title: titles[$0],
                                             link: links[$0],
                                             date: dates[$0],
                                             content: contents[$0],
                                             sourceName: source) })

                output = elems
            }
        }
    }
    return output
}
