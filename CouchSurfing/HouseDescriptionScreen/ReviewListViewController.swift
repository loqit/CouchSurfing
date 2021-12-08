//
//  ReviewListViewController.swift
//  CouchSurfing
//
//  Created by Андрей Бобр on 4.12.21.
//

import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift
import Firebase
import SwiftUI

class ReviewListViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var houseReviews: [Review] = []
    var thisHouseID: String?
    var review: Review?
    var ownerID: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNabigationController()
        configureCollectionView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchReviews()
    }
    
    private func checkUser() {
        let userID = Auth.auth().currentUser!.uid
        if userID == ownerID {
            navigationItem.rightBarButtonItem?.tintColor = .gray
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }

    private func configureCollectionView() {
        collectionView.register(UINib(nibName: ReviewCell.unqueIdentified, bundle: nil), forCellWithReuseIdentifier: ReviewCell.unqueIdentified)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func configureNabigationController() {
        self.title = "Reviews"
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.prefersLargeTitles = true
        let writeButton = UIBarButtonItem(image: .add, style: .plain, target: self, action: #selector(writeReview))
        writeButton.tintColor = .red
        navigationItem.rightBarButtonItem = writeButton
        checkUser()
    }
    
    @objc
    func writeReview() {
        guard let vc = storyboard?.instantiateViewController(identifier: "CreateReviewViewController") as? CreateReviewViewController else { return }
        vc.houseID = thisHouseID
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func fetchReviews() {
        let db = Firestore.firestore()
        var dict: [[String: Any]] = []
        DispatchQueue.global().async {
            guard let thisHouseID = self.thisHouseID else { return }
            db.collection("reviews").whereField("HouseID", isEqualTo: thisHouseID)
                .getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            dict.append(document.data())
                            print(document.data())
                        }
                        self.updateCollectionView(with: dict)
                    }
            }
        }
    }
    
    private func updateCollectionView(with data: [[String:Any]]) {
        for item in data {
            let title = item["Title"] as? String ?? ""
            let textReview = item["Text"] as? String ?? ""
            let authorID = item["AuthorID"] as? String ?? ""
            let mark = item["Mark"] as? String ?? ""
            let houseID = item["HouseID"] as? String ?? ""
            
            let review = Review(title: title, textReview: textReview, mark: Int(mark), authorID: authorID, houseID: houseID, image: nil)
            houseReviews.append(review)
        }
        collectionView.reloadData()
    }
}

extension ReviewListViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = self.houseReviews.count
        return count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReviewCell.unqueIdentified, for: indexPath) as! ReviewCell
        let review = self.houseReviews[indexPath.item]
        cell.setCell(with: review)
        self.review = review
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let offset: CGFloat = 20
        let screenWidth = UIScreen.main.bounds.size.width
        let cellWidth = screenWidth - offset * 2
        return CGSize(width: cellWidth, height: 218.14)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CSConstans.cellIndent
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let house = self.houseReviews[indexPath.item]
        let storyboard = UIStoryboard(name: "HouseDescription", bundle: nil)
        guard let destinationVC = storyboard.instantiateViewController(identifier: "HouseDescriptionViewController") as? HouseDescriptionViewController else { return }
    }
}
