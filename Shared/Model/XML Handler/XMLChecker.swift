//
//  XMLChecker.swift
//  Feedex (iOS)
//
//  Created by Yu-Sung Loyi Hsu on 01/10/2021.
//

import Foundation
import SwiftSoup

func checkAndFetchXML(_ url: String) -> Document? {
    guard let url = URL(string: url) else { return nil }
    guard let content = try? String(contentsOf: url) else { return nil }
    return try? SwiftSoup.parse(content, "", Parser.xmlParser())
}
