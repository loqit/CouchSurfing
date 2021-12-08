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
    
    static let uniqueIdentifier: String = "TopHouseCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }
    
    private func configureUI() {
        view.setupShadowAndRadius()
        backView.setupShadowAndRadius()
        bookNowButton.layer.borderWidth = 1
        bookNowButton.layer.borderColor = CSConstans.customOrange.cgColor
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
    
    func setupCell(house: House, canBook: Bool = false) {
        nameLabel.text = house.title
        if let url = URL(string: house.imageURL ?? "") {
            imageView.kf.setImage(with: url)
        }
        priceLabel.text = house.city
        bookNowButton.isHidden = canBook
    }
}
