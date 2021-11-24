//
//  PaymentCheckoutCollectionViewCell.swift
//  CouchSurfing
//
//  Created by Андрей Бобр on 10.11.21.
//

import UIKit

class PaymentCheckoutTableViewCell: UITableViewCell {

    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var arrowImage: UIImageView!
    @IBOutlet weak var separator: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupCell(service: Service) {
        self.logoImage.image = service.logoImage
        self.label.text = service.seviceName
        self.arrowImage.image = service.arrowImage
        self.separator.backgroundColor = UIColor.separator
    }
}
