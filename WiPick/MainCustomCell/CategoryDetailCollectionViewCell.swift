//
//  CategoryDetailCollectionViewCell.swift
//  WiPick
//
//  Created by 김도현 on 11/03/2020.
//  Copyright © 2020 김도현. All rights reserved.
//

import UIKit

class CategoryDetailCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var CategoryTitle: UIButton!
    override var isSelected: Bool {
        didSet {
            if isSelected {
                self.CategoryTitle.layer.borderColor = UIColor(red: 249/255, green: 1/255, blue: 203/255, alpha: 1.0).cgColor
                self.CategoryTitle.setTitleColor(UIColor(red: 249/255, green: 1/255, blue: 203/255, alpha: 1.0), for: .normal)
               
            } else {
                self.CategoryTitle.layer.borderColor = UIColor.lightGray.cgColor
                self.CategoryTitle.setTitleColor(UIColor.lightGray, for: .normal)
            }
        }
    }
    var ButtonTap : Bool?
    override func awakeFromNib() {
        super.awakeFromNib()
        self.CategoryTitle.layer.borderWidth = 1.0
        self.CategoryTitle.frame = CGRect(x: self.CategoryTitle.frame.origin.x, y: self.CategoryTitle.frame.origin.y, width: self.CategoryTitle.frame.size.width, height: self.CategoryTitle.frame.size.height)
        // Initialization code
        self.CategoryTitle.layer.borderColor = UIColor.gray.cgColor
        
    }
}

