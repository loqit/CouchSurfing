//
//  House.swift
//  CouchSurfing
//
//  Created by Андрей Бобр on 25.10.21.
//

import Foundation
import UIKit

struct House {
    var houseID: UUID
    var imageURL: String?
    var title: String
    var adress: String
    var city: String
    var country: String
    var userOwnerID: String?
    var description: String
    var rating: Float?
    var capacity: Int
}

