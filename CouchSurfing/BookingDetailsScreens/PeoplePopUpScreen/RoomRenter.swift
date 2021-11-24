//
//  RoomRenters.swift
//  CouchSurfing
//
//  Created by Андрей Бобр on 10.11.21.
//

import Foundation
import UIKit

class RoomRenter {
    var roomRenters: [Renter] = []
    
    init() {
        setup()
    }
    
    func setup() {
        let roomRenterCategory1 = Renter(name: "Adult", description: "16+ year", quantity: 0)
        let roomRenterCategory2 = Renter(name: "Teens", description: "12-15 years", quantity: 0)
        let roomRenterCategory3 = Renter(name: "Children", description: "2-11 years", quantity: 0)
        let roomRenterCategory4 = Renter(name: "Infants", description: "under 2 years", quantity: 0)
        self.roomRenters = [roomRenterCategory1, roomRenterCategory2, roomRenterCategory3, roomRenterCategory4]
    }
}
