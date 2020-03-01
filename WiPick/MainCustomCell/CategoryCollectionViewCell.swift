//
//  CategoryCollectionViewCell.swift
//  WiPick
//
//  Created by 김도현 on 19/02/2020.
//  Copyright © 2020 김도현. All rights reserved.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var CategoryBackView: UIView!
    @IBOutlet weak var CategoryUserProfile: UIImageView!
    @IBOutlet weak var CategoryTitle: UILabel!
    @IBOutlet weak var CategoryUserID: UILabel!
    @IBOutlet weak var CategoryImg: UIImageView!
    @IBOutlet weak var CategoryContent: UITextView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 10)
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = false
        self.layer.shadowOpacity = 0.23
        self.layer.shadowRadius = 4
        
        
        //CategoryCell Layout Init
        
        CategoryContent.isUserInteractionEnabled = true
        CategoryContent.isEditable = false
        self.CategoryUserProfile.layer.cornerRadius = self.CategoryUserProfile.frame.height/2
        self.CategoryUserProfile.clipsToBounds = true
        self.CategoryUserProfile.layer.borderColor = UIColor.lightGray.cgColor
        self.CategoryUserProfile.layer.borderWidth = 1.0
        self.CategoryUserID.textAlignment = .left
        self.CategoryUserID.font = UIFont.systemFont(ofSize: 15)
        self.CategoryUserID.textColor = UIColor.lightGray
                
        let deviceWidth = UIScreen.main.bounds.width
        self.CategoryBackView.frame = CGRect(x: self.frame.origin.x, y: 0, width: self.frame.size.width, height: self.contentView.frame.height)
        self.CategoryBackView.layer.shadowColor = UIColor.darkGray.cgColor
        self.CategoryBackView.layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
        self.CategoryBackView.layer.shadowRadius = 25.0
        self.CategoryBackView.layer.shadowOpacity = 0.9
        self.CategoryBackView.layer.masksToBounds = true
        self.CategoryBackView.layer.shadowPath = UIBezierPath(roundedRect: self.CategoryBackView.bounds, cornerRadius: 10).cgPath
        self.CategoryBackView.layer.shouldRasterize = true
        self.CategoryBackView.layer.rasterizationScale = UIScreen.main.scale
        
        
        
        
    }

}
