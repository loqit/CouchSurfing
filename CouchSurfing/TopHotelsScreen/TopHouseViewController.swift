//
//  TopHouseViewController.swift
//  CouchSurfing
//
//  Created by Андрей Бобр on 05.11.21.
//

import UIKit

class TopHouseViewController: UIViewController {
    
    var catalog: Catalog?
    var wishListCatalog: [House] = []
    var allHotelsCatalog: [Result] = []
    var list: List?
    var location: String?
    var hotel: Result?
    var pageNumber: Int = 1

    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tapBar: UITabBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let location = self.location {
            locationLabel.text = location
        }
        
        collectionView.register(UINib(nibName: "TopHouseCell", bundle: nil), forCellWithReuseIdentifier: "TopHouseCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        //        let vc2 = WishlistViewController()
        
        guard let seachResult = self.list?.data?.body?.searchResults?.results, let totalCount = self.list?.data?.body?.searchResults?.totalCount else { return }
        allHotelsCatalog.append(contentsOf: seachResult)
        let numberOfPages: Int = Int(ceil(CGFloat(totalCount) / CGFloat(allHotelsCatalog.count)))
        for page in 1...numberOfPages {
//        for page in 1...2 {
            if page == 1 {
                continue
            }
            
            NetworkManagerList.fetch(pageNumber: page, pageSize: 25, destinationId: "118894", locale: "ru_RU") { [weak self] (list) in
                guard let self = self else { return }
                guard let seachResult = list.data?.body?.searchResults?.results else { return }
                self.allHotelsCatalog.append(contentsOf: seachResult)
                self.collectionView.reloadData()
            }
        }
    }
}

extension TopHouseViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // количество ячеек задаем
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //        guard let count = catalog?.hotels.count else { return 0 }
//        guard let count = self.list?.data?.body?.searchResults?.results?.count else { return 0 }
        let count = self.allHotelsCatalog.count
        return count
    }
    
    // внешний вид и содержание задаем
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopHouseCell", for: indexPath) as! TopHouseCell
//        guard let hotel = catalog?.hotels[indexPath.item] else { return cell }
//        guard let hotel = self.list?.data?.body?.searchResults?.results?[indexPath.item] else { return cell }
        let hotel = self.allHotelsCatalog[indexPath.item]
        cell.setupCell(hotel: hotel)
        self.hotel = hotel
        cell.bookNowButtonPressed = { [weak self] in
            guard let self = self else { return }
            let storyboard = UIStoryboard(name: "HouseDescription", bundle: nil)
            guard let destinationVC = storyboard.instantiateViewController(identifier: "HouseDescriptionViewController") as? HouseDescriptionViewController else { return }
            guard let hotel = self.hotel else { return }
            destinationVC.hotel = hotel
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
        return 12.86
    }
    
    // отрабатываем нажатие на ячейку
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        guard let hotel = list?.data?.body?.searchResults?.results?[indexPath.row] else { return }
        let hotel = self.allHotelsCatalog[indexPath.item]
        let storyboard = UIStoryboard(name: "HouseDescription", bundle: nil)
        guard let destinationVC = storyboard.instantiateViewController(identifier: "HouseDescriptionViewController") as? HouseDescriptionViewController else { return }
        destinationVC.hotel = hotel
        navigationController?.pushViewController(destinationVC, animated: true)
//        show(destinationVC, sender: nil)
    }
}
