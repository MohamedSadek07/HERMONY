//
//  MyProductsCollectionViewCell.swift
//  HERMONY
//
//  Created by Mohamed Ahmed Sadek on 4/30/19.
//  Copyright © 2019 Magdy rizk. All rights reserved.
//

import UIKit
protocol transferData {
    func deleteProduct(index : Int)
}

class MyProductsCollectionViewCell: UICollectionViewCell {
    
    var delegate : transferData?
    var indexPath : IndexPath?
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var deletBtn: UIButton!
    @IBOutlet weak var advImageView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBAction func deletebtnAction(_ sender: UIButton) {
        delegate?.deleteProduct(index: indexPath!.row)
        
    }
}
