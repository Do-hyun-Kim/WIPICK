//
//  PageViewCell.swift
//  WiPick
//
//  Created by 김도현 on 08/12/2019.
//  Copyright © 2019 김도현. All rights reserved.
//

import UIKit

class PageViewCell: UICollectionViewCell {

    
    var label: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addSubview(label)
        // Initialization code
        self.backgroundColor = .white
        label.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }

}
