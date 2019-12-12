//
//  FooterCell.swift
//  kirayFan
//
//  Created by кирилл корнющенков on 03.12.2019.
//  Copyright © 2019 кирилл корнющенков. All rights reserved.
//

import UIKit

class Cell: UICollectionViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageCell.contentMode = .scaleToFill
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageCell.frame = bounds
    }
    
    @IBOutlet weak var imageCell: UIImageView!
    @IBOutlet weak var checkImageCell: UIImageView!
    
}
