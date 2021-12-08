//
//  Constants.swift
//  CouchSurfing
//
//  Created by Андрей Бобр on 20.10.21.
//

import Foundation
import UIKit
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class CSConstans {
    static let customOrange: UIColor = UIColor(red: 242/255, green: 65/255, blue: 49/255, alpha: 1)
    static let cellIndent: CGFloat = 12.86
    
    static func setHouseImageRef(userOwnerID: String, houseID: String) -> String{
        let ref = "\(userOwnerID)//\(houseID)/image.png"
        return ref
    }
    
    static func setHouse(with data: [String: Any]) -> House {
        let ownerID = data["LandlordID"] as? String ?? ""
        let title = data["Title"] as? String ?? ""
        let city = data["City"] as? String ?? ""
        let country = data["Country"] as? String ?? ""
        let adress = data["Adress"] as? String ?? ""
        let desc = data["Description"] as? String ?? ""
        let houseID = data["HouseID"] as? String ?? ""
        let houseImageURL = data["ImageURL"] as? String ?? ""

        let newHouse = House(houseID: UUID(uuidString: houseID)!, imageURL: houseImageURL, title: title, adress: adress, city: city, country: country, userOwnerID: ownerID, description: desc, rating: nil, capacity: 1)
        return newHouse
    }
    
    var currentUser: CSUser
    init(user: CSUser) {
        currentUser = user
    }
    
    static func setUser(with data: [String: Any]) -> CSUser {
        let userName = data["Name"] as? String ?? ""
        let email = data["Email"] as? String ?? ""
        let userID = data["UserID"] as? String ?? ""
        let phoneNumber = data["PhoneNumber"] as? String ?? ""
        let currentUser = CSUser(userID: userID, name: userName, email: email, phoneNumber: phoneNumber)
        return currentUser
    }
}

