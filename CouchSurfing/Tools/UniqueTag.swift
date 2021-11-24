//
//  UniqueTag.swift
//  CouchSurfing
//
//  Created by Андрей Бобр on 15.11.21.
//

import Foundation

struct UniqueTag {

    private var uniqueTag: Int

    init() {
        uniqueTag = 0
    }

    mutating func getUniqueTag() -> Int {
        uniqueTag += 1
        return uniqueTag
    }
}
