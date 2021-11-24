//
//  BookingDetails.swift
//  CouchSurfing
//
//  Created by Андрей Бобр on 10.11.21.
//

import Foundation

protocol BookingDetails {
    var name: String { get set }
    var description: String { get set }
    var quantity: Int { get set }
}
