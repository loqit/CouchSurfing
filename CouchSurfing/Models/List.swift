//
//  List.swift
//  CouchSurfing
//
//  Created by Андрей Бобр on 25.10.21.
//

import Foundation

struct List {
    var result: String?
    var data: Data?
}

struct Data {
    var body: Body?
}

struct Body {
    var searchResults: SearchResults?
}

struct SearchResults {
    var totalCount: Int?
    var results: [Result]?
}

struct Result {
    var id: Int?
    var name: String?
    var starRating: Double?
    var ratePlan: RatePlan?
    var optimizedThumbUrls: OptimizedThumbUrls?
}

struct RatePlan {
    var price: Price?
}

struct Price {
    var current: String?
}

struct OptimizedThumbUrls {
    var srpDesktop: String?
}
