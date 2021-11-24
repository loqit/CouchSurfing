//
//  BookingDetailsCell.swift
//  CouchSurfing
//
//  Created by Андрей Бобр on 10.11.21.
//

import UIKit

class BookingDetailsCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    
    var cellPlusPressed: (() -> ())?
    var cellMinusPressed: (() -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupCell(item: BookingDetails) {
        self.nameLabel.text = item.name
        self.descriptionLabel.text = item.description
        self.quantityLabel.text = String(item.quantity)
    }
    
    @IBAction func minusButtonPressed(_ sender: UIButton) {
        cellMinusPressed?()
    }
    
    @IBAction func plusButtonPressed(_ sender: UIButton) {
        cellPlusPressed?()
    }
}
