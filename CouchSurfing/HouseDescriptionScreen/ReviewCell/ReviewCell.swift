//
//  CollectionViewCell.swift
//  CouchSurfing
//
//  Created by Андрей Бобр on 4.12.21.
//

import UIKit
import FirebaseFirestore
import Firebase
import FirebaseFirestoreSwift

class ReviewCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var reviewTextView: UITextView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var markLabel: UILabel!
    
    static let unqueIdentified: String = "ReviewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.tintColor = CSConstans.customOrange
    }


    func setCell(with review: Review) {
        titleLabel.text = review.title
        reviewTextView.text = review.textReview
        let mark = review.mark ?? 0
        markLabel.text = String(mark)
        let authorID = review.authorID
        getUserData(by: authorID)
        layer.cornerRadius = 10
        layer.borderWidth = 1
        layer.borderColor = CSConstans.customOrange.cgColor
    }
    
    private func setAuthor(_ user: CSUser) {
        authorLabel.text = user.name
    }
    
    private func getUserData(by authorID: String) {
        let db = Firestore.firestore()
        var dict: [String: Any] = [:]
        DispatchQueue.global().async {
            db.collection("users").whereField("UserID", isEqualTo: authorID)
                .getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            dict = document.data()
                        }
                        let user = CSConstans.setUser(with: dict)
                        self.setAuthor(user)
                    }
                }
        }
        
    }
}
