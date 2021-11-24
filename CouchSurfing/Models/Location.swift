//
//  Location.swift
//  CouchSurfing
//
//  Created by Андрей Бобр on 25.10.21.
//

import Foundation

struct Location {
    var term: String?
    var moresuggestions: Int?
    var autoSuggestInstance: String? // Type?
    var trackingID: String?
    var misspellingfallback: Bool?
    var suggestions: [Suggestion]?
    var geocodeFallback: Bool?
}

struct Suggestion {
    var group: String?
    var entities: [Entity]?
}

struct Entity {
    var geoId: String?
    var destinationId: String?
    var landmarkCityDestinationId: String? // Type?
    var type: String?
    var redirectPage: String?
    var latitude: Double?
    var longitude: Double?
    var searchDetail: String? // Type?
    var caption: String?
    var name: String?
}
