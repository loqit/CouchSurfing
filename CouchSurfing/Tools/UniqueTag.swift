//
//  UniqueTag.swift
//  CouchSurfing
//
//  Created by Андрей Бобр on 17.10.21.
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
