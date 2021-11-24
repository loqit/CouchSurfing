//
//  HouseCell.swift
//  CouchSurfing
//
//  Created by Андрей Бобр on 05.11.21.
//

import UIKit
import Kingfisher

class HouseCell: UICollectionViewCell {

//    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib() 
        view.setupShadowAndRadius()
        backView.setupShadowAndRadius()
    }
    
    func setupCell(hotel: Result) {
        guard let photoUrlString = hotel.optimizedThumbUrls?.srpDesktop else { return }
        guard let photoUrl = URL(string: photoUrlString) else { return }
        self.image.kf.setImage(with: photoUrl)
        self.nameLabel.text = hotel.name
        self.priceLabel.text = hotel.ratePlan?.price?.current

    }
    
    
//    func setupCell(hotel: Hotel) {
//        self.image.image = hotel.image
//        self.nameLabel.text = hotel.name
//        self.priceLabel.text = "$ \(hotel.price)"
//    }
}
