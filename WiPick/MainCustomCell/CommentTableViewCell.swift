//
//  CommentTableViewCell.swift
//  WiPick
//
//  Created by 김도현 on 31/03/2020.
//  Copyright © 2020 김도현. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    @IBOutlet weak var Comment_Profile: UIImageView!
    @IBOutlet weak var Comment_Writer: UILabel!
    @IBOutlet weak var Comment_Content: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.Comment_Profile.frame = CGRect(x: self.Comment_Profile.frame.origin.x, y: self.Comment_Profile.frame.origin.y, width: self.Comment_Profile.frame.size.width, height: self.Comment_Profile.frame.size.height)
        self.Comment_Profile.layer.cornerRadius = self.Comment_Profile.frame.height/2
        self.Comment_Profile.clipsToBounds = true
        self.Comment_Profile.layer.borderColor = UIColor.lightGray.cgColor
        self.Comment_Profile.layer.borderWidth = 1.0
        
        self.Comment_Writer.frame = CGRect(x: self.Comment_Writer.frame.origin.x, y: self.Comment_Writer.frame.origin.y, width: self.Comment_Writer.frame.size.width, height: self.Comment_Writer.frame.size.height)
        self.Comment_Content.frame = CGRect(x: self.Comment_Content.frame.origin.x, y: self.Comment_Content.frame.origin.y, width: self.Comment_Content.frame.size.width, height: self.Comment_Content.frame.size.height)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
