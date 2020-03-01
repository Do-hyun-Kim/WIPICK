//
//  MainCollectionViewCell.swift
//  WiPick
//
//  Created by 김도현 on 13/12/2019.
//  Copyright © 2019 김도현. All rights reserved.
//

import UIKit

class MainCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var Category_Img: UIImageView!
    @IBOutlet weak var Category_Label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        Category_Label.textColor = UIColor.black
        Category_Label.textAlignment = .center
        Category_Img.frame = CGRect(x: Category_Img.frame.origin.x, y: Category_Img.frame.origin.y, width: Category_Img.frame.size.width, height: Category_Img.frame.size.height)
        Category_Label.font = .systemFont(ofSize: 14)
        Category_Label.frame = CGRect(x: Category_Label.frame.origin.x, y: Category_Label.frame.origin.y + 15, width: Category_Label.frame.size.width, height: Category_Label.frame.size.height)
        // Initialization code
//        self.Category_Img.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
//        self.Category_Label.frame = CGRect(x: 0, y:140 , width: 100, height: 100)
    }

}
