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
    func setupCell(house: House) {
        nameLabel.text = house.title
        if let url = URL(string: house.imageURL ?? "") {
            image.kf.setImage(with: url)
        }
        priceLabel.text = house.city
        //bookNowButton.isHidden = canBook
    }
}
