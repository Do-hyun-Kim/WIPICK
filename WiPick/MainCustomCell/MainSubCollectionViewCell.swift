//
//  MainSubCollectionViewCell.swift
//  WiPick
//
//  Created by 김도현 on 13/12/2019.
//  Copyright © 2019 김도현. All rights reserved.
//

import UIKit

class MainSubCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var ContentBackView: UIView!
    @IBOutlet weak var Profile_Name: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 10)
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = false
        self.layer.shadowOpacity = 0.23
        self.layer.shadowRadius = 4
        self.ContentBackView.frame = CGRect(x: 0, y: 0, width: self.contentView.frame.size.width, height: self.contentView.frame.height)
        self.ContentBackView.layer.shadowColor = UIColor.darkGray.cgColor
        self.ContentBackView.layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
        self.ContentBackView.layer.shadowRadius = 25.0
        self.ContentBackView.layer.shadowOpacity = 0.9
        self.ContentBackView.layer.masksToBounds = true
        self.ContentBackView.layer.shadowPath = UIBezierPath(roundedRect: self.ContentBackView.bounds, cornerRadius: 10).cgPath
        self.ContentBackView.layer.shouldRasterize = true
        self.ContentBackView.layer.rasterizationScale = UIScreen.main.scale
        
    }

}
