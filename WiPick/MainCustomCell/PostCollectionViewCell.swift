//
//  PostCollectionViewCell.swift
//  WiPick
//
//  Created by 김도현 on 07/01/2020.
//  Copyright © 2020 김도현. All rights reserved.
//

import UIKit

class PostCollectionViewCell: UICollectionViewCell,UITableViewDelegate,UITableViewDataSource {
    
   
    
    
   
    @IBOutlet weak var PostImageTableView: UITableView!
    @IBOutlet weak var TestImage: UIImageView!
    @IBOutlet weak var PostBackView: UIView!
    @IBOutlet weak var Post_Title: UILabel!
    @IBOutlet weak var Post_created: UILabel!
    @IBOutlet weak var Post_content: UITextView!
    @IBOutlet weak var Post_UserProfile: UIImageView!
    @IBOutlet weak var Post_UserID: UILabel!
    @IBOutlet weak var Post_Img: UIImageView!
    @IBOutlet weak var Post_Category: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 10)
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = false
        self.layer.shadowOpacity = 0.23
        self.layer.shadowRadius = 4
        Post_content.isUserInteractionEnabled = true
        Post_content.isEditable = false
//        self.Post_UserProfile.frame = CGRect(x: 20, y: 0, width: 80, height: 80)
        self.Post_UserProfile.layer.cornerRadius = self.Post_UserProfile.frame.height/2
        self.Post_UserProfile.clipsToBounds = true
        self.Post_UserProfile.layer.borderColor = UIColor.lightGray.cgColor
        self.Post_UserProfile.layer.borderWidth = 1.0
        self.Post_UserID.textAlignment = .left
        self.Post_UserID.font = UIFont.systemFont(ofSize: 15)
        self.Post_UserID.textColor = UIColor.lightGray
        
        let deviceWidth = UIScreen.main.bounds.width
        self.PostBackView.frame = CGRect(x: self.frame.origin.x, y: 0, width: self.frame.size.width, height: self.contentView.frame.height)
        self.PostBackView.layer.shadowColor = UIColor.darkGray.cgColor
        self.PostBackView.layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
        self.PostBackView.layer.shadowRadius = 25.0
        self.PostBackView.layer.shadowOpacity = 0.9
        self.PostBackView.layer.masksToBounds = true
        self.PostBackView.layer.shadowPath = UIBezierPath(roundedRect: self.PostBackView.bounds, cornerRadius: 10).cgPath
        self.PostBackView.layer.shouldRasterize = true
        self.PostBackView.layer.rasterizationScale = UIScreen.main.scale
        self.PostImageTableView.register(UINib(nibName: "PostImageTableViewCell", bundle: nil), forCellReuseIdentifier: "PostTableCell")
//     self.PostImageCollectionView.register(UINib(nibName: "PostImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PostCollectionCell")
        self.PostImageTableView.delegate = self
        self.PostImageTableView.dataSource = self
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return 1
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let ImageCell = tableView.dequeueReusableCell(withIdentifier: "PostTableCell", for: indexPath) as? PostImageTableViewCell
        
        return ImageCell!
       }
    
    
    
    

}


//
//extension PostCollectionViewCell  : UICollectionViewDataSource {
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 4
//    }
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let PostImageCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostImageCell", for: indexPath) as? PostImageCollectionViewCell
//        
//        
//     
//        
//        
//        
//        return PostImageCell!
//    }
//    
//    
//}
