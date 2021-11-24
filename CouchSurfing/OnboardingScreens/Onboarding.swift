//
//  Onboarding.swift
//  CouchSurfing
//
//  Created by Андрей Бобр on 05.11.21.
//

import Foundation
import UIKit

struct Page {
    var image: UIImage
    var title: String
    var text: String
}

class Onboarding {
    var pages = [Page]()
    
    init() {
        setup()
    }
    
    func setup() {
        let page1 = Page(image: UIImage(named: "Onboarding-1 Illustration")!, title: "Search and save your preference", text: "Browse best hotels from 40,000+ database that fits your unique needs")
        let page2 = Page(image: UIImage(named: "Onboarding-2 Illustration")!, title: "Find the best deals", text: "Find the best deals from any season and book from a curated list")
        let page3 = Page(image: UIImage(named: "Onboarding-3 Illustration")!, title: "Book and enjoy your stay", text: "Select the hotel and date as per your preference to book and have a pleasant stay")
        
        self.pages = [page1, page2, page3]
    }
}
