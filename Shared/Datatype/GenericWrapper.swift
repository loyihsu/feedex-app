//
//  GenericWrapper.swift
//  Feedex (iOS)
//
//  Created by Yu-Sung Loyi Hsu on 30/09/2021.
//

import Foundation

class Wrapped<T>: Identifiable {
    var id = UUID()
    var item: T

    init(_ item: T) {
        self.item = item
    }
}
