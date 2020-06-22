//
//  PostImageTableViewCell.swift
//  WiPick
//
//  Created by 김도현 on 04/03/2020.
//  Copyright © 2020 김도현. All rights reserved.
//

import UIKit

class PostImageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var ImageCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}
