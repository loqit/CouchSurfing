//
//  House.swift
//  CouchSurfing
//
//  Created by Андрей Бобр on 17.10.21.
//

import Foundation

struct House {
    
    private var houseId: UUID
    private var title: String
    private var addres: String
    private var description: String
    private var images: [String]
    private var rate: Float
    private var maxCapacity: Int    // Capacity of guests
    
    private var availableDates: [Date]
    // Add User-Owner
    private var userOwner: CSUser
}
