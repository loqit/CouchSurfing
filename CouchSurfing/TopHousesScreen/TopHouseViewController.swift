//
//  TopHouseViewController.swift
//  CouchSurfing
//
//  Created by Андрей Бобр on 05.11.21.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class TopHouseViewController: UIViewController {
    
    var wishListCatalog: [House] = []
    var allHousesCatalog: [House] = []
    var location: String?
    var house: House?
    var params: [String: Any] = [:]
    

    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tapBar: UITabBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLocationLabel()
        configureCollectionView()
        fetchHouses(with: params)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchHouses(with: params)
    }
    
    private func configureLocationLabel() {
        if let location = self.location {
            locationLabel.text = location
        }
    }
    
    private func configureCollectionView() {
        collectionView.register(UINib(nibName: TopHouseCell.uniqueIdentifier, bundle: nil), forCellWithReuseIdentifier: TopHouseCell.uniqueIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func fetchHouses(with params: [String: Any]?) {
        guard let params = params else { return }
        let db = Firestore.firestore()
        let city = params["City"] as? String ?? ""
        let tmp = params["Capacity"] as? String ?? "1"
        let capacity = Int(tmp) ?? 0
        var dict: [[String: Any]] = []
        DispatchQueue.global().async {
            db.collection("houses")
                .whereField("City", isEqualTo: city)
                .whereField("Capacity", isGreaterThanOrEqualTo: capacity)
                .getDocuments()
                { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        dict.append(document.data())
                        print(dict)
                        self.updateCollectionView(with: dict)
                    }
                }
            }
        }

    }
    
    private func fetchHouses() {
        let db = Firestore.firestore()
        var dict: [[String: Any]] = []
        DispatchQueue.global().async {
            db.collection("houses").getDocuments() { (querySnapshot, err) in
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
    
    private func updateCollectionView(with data: [[String: Any]]) {
        allHousesCatalog = []
        for item in data {
            let newHouse = CSConstans.setHouse(with: item)
            self.allHousesCatalog.append(newHouse)
            self.collectionView.reloadData()
        }
    }
}

extension TopHouseViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    // количество ячеек задаем
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = self.allHousesCatalog.count
        return count
    }

    // внешний вид и содержание задаем
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopHouseCell.uniqueIdentifier, for: indexPath) as! TopHouseCell
        let house = self.allHousesCatalog[indexPath.item]
        cell.setupCell(house: house)
        self.house = house
        cell.bookNowButtonPressed = { [weak self] in
            guard let self = self else { return }
            let storyboard = UIStoryboard(name: "HouseDescription", bundle: nil)
            guard let destinationVC = storyboard.instantiateViewController(identifier: "HouseDescriptionViewController") as? HouseDescriptionViewController else { return }
            guard let house = self.house else { return }
            destinationVC.house = house
            self.navigationController?.pushViewController(destinationVC, animated: true)
        }
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
        let house = self.allHousesCatalog[indexPath.item]
        let storyboard = UIStoryboard(name: "HouseDescription", bundle: nil)
        guard let destinationVC = storyboard.instantiateViewController(identifier: "HouseDescriptionViewController") as? HouseDescriptionViewController else { return }
        destinationVC.house = house
        navigationController?.pushViewController(destinationVC, animated: true)
    }
}
