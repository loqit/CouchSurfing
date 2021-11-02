//
//  CSUser.swift
//  CouchSurfing
//
//  Created by Андрей Бобр on 2.11.21.
//

import Foundation

struct CSUser {
    
    private var csUserId: UUID
    private var name: String
    private var rate: Float
    private var houses: [House]
}
