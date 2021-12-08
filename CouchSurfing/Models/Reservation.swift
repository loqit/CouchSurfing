//
//  Reservation.swift
//  CouchSurfing
//
//  Created by Андрей Бобр on 7.12.21.
//

import Foundation

struct Reservation {
    var houseID: String
    var userID: String
    var checkInDate: Date
    var checkoutDate: Date
    var numberOfGuests: Int
}
