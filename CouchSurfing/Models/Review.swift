//
//  Review.swift
//  CouchSurfing
//
//  Created by Андрей Бобр on 4.12.21.
//

import Foundation

struct Review {
    var title: String
    var textReview: String
    var mark: Int?
    var authorID: String
    var houseID: String
    
    // TODO: Implement adding photo to review
    var image: String?
}
