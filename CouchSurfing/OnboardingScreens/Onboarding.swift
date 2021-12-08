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
        let page1 = Page(image: UIImage(named: "Onboarding-1 Illustration")!, title: "Search and save your preference", text: "CouchSurf around the world")
        let page2 = Page(image: UIImage(named: "Onboarding-2 Illustration")!, title: "Meet other cultures", text: "Learn how the locals live")
        let page3 = Page(image: UIImage(named: "Onboarding-3 Illustration")!, title: "Book and enjoy your stay", text: "All lodging is free, and if you want you can donate to the owners")
        
        self.pages = [page1, page2, page3]
    }
}
