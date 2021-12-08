//
//  HouseListViewController.swift
//  CouchSurfing
//
//  Created by Андрей Бобр on 30.11.21.
//

import UIKit
import Firebase
import FirebaseFirestore

class HouseListViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var userHouses: [House] = []
    private var house: House?
    private let storageRef = Storage.storage().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserHouses()
        configureCollectionView()
    }
    
    private func configureCollectionView() {
        collectionView.register(UINib(nibName: "TopHouseCell", bundle: nil), forCellWithReuseIdentifier: "TopHouseCell")
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func getUserHouses() {
        let db = Firestore.firestore()
        var dict: [[String: Any]] = []
        DispatchQueue.global().async {
            db.collection("houses").whereField("LandlordID", isEqualTo: Auth.auth().currentUser!.uid)
                .getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            dict.append(document.data())
                        }
                        self.updateCollectionView(with: dict)
                    }
            }
        }
    }
    
    func updateCollectionView(with data: [[String: Any]]) {
        DispatchQueue.main.async {
            for item in data {
                let newHouse = CSConstans.setHouse(with: item)
                self.userHouses.append(newHouse)
            }
            self.collectionView.reloadData()
        }
    }
}

extension HouseListViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userHouses.count
    }
    
    // внешний вид и содержание задаем
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopHouseCell", for: indexPath) as! TopHouseCell
        let house = self.userHouses[indexPath.item]
        cell.setupCell(house: house, canBook: true)
        self.house = house
       /* cell.bookNowButtonPressed = { [weak self] in
            guard let self = self else { return }
            let storyboard = UIStoryboard(name: "HouseDescription", bundle: nil)
            guard let destinationVC = storyboard.instantiateViewController(identifier: "HouseDescriptionViewController") as? HouseDescriptionViewController else { return }
            guard let hotel = self.house else { return }
            destinationVC.hotel = hotel
            self.navigationController?.pushViewController(destinationVC, animated: true)
        }*/
//        cell.bookNowButtonPressed = {
//            if self.wishListCatalog.contains(where: { $0.name == }) {
//
//                return false
//            } else {
//                self.wishListCatalog.append(hotel)
//                return true
//            }
//        }
        
        return cell
    }
    
    //  размер ячейки задаем
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let offset: CGFloat = 20
        let screenWidth = UIScreen.main.bounds.size.width
        let cellWidth = screenWidth - offset * 2
        return CGSize(width: cellWidth, height: 218.14)
    }
    
    // отспут между ячейками задаем
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CSConstans.cellIndent
    }
    
    // отрабатываем нажатие на ячейку
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let house = self.userHouses[indexPath.item]
        let storyboard = UIStoryboard(name: "HouseDescription", bundle: nil)
        guard let destinationVC = storyboard.instantiateViewController(identifier: "HouseDescriptionViewController") as? HouseDescriptionViewController else { return }
        destinationVC.house = house
        show(destinationVC, sender: nil)
    }
}
