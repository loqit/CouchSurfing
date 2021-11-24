//
//  TopHouseCell.swift
//  CouchSurfing
//
//  Created by Андрей Бобр on 05.11.21.
//

import UIKit
import Kingfisher

class TopHouseCell: UICollectionViewCell {
    var bookNowButtonPressed: (() -> ())?

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var markButton: UIButton!
    @IBOutlet weak var bookNowButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        view.setupShadowAndRadius()
        backView.setupShadowAndRadius()
        bookNowButton.layer.borderWidth = 1
        bookNowButton.layer.borderColor = customOrange.cgColor
        bookNowButton.layer.cornerRadius = 5
    }
    
    @IBAction func markButtonPressed(_ sender: UIButton) {
//        guard let pressed = bookNowButtonPressed?() else { return }
//
//        if pressed {
//            markButton.setImage(UIImage(named: "BookMarkColor"), for: UIControl.State.normal)
//        } else {
//            markButton.setImage(UIImage(named: "BookMarkBorder"), for: UIControl.State.normal)
//        }
    }
    
    @IBAction func bookNowButtonPressed(_ sender: UIButton) {
        bookNowButtonPressed?()
    }
    
    //MARK:- использовать данные из сети
//    func setupCell(hotel: Hotel) {
//        self.imageView.image = hotel.image
//        self.nameLabel.text = hotel.name
//        self.priceLabel.text = "$ \(hotel.price)"
//    }
    
    
    //MARK:- использовать локальные данные 
    func setupCell(hotel: Result) {
        if let photoUrlString = hotel.optimizedThumbUrls?.srpDesktop {
            if let photoUrl = URL(string: photoUrlString) {
                self.imageView.kf.setImage(with: photoUrl)
            }
        }

        self.nameLabel.text = hotel.name
        self.priceLabel.text = hotel.ratePlan?.price?.current
        if let rating = hotel.starRating {
            self.ratingLabel.text = String(rating)
        }
    }
}
