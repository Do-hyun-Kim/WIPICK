//
//  PostTableViewCell.swift
//  WiPick
//
//  Created by 김도현 on 04/03/2020.
//  Copyright © 2020 김도현. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class PostTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var ImageCollectionView: UICollectionView!
    @IBOutlet weak var PostTableBackView: UIView!
    @IBOutlet weak var PostTable_Title: UILabel!
    
    @IBOutlet weak var PostTable_content: UITextView!
    @IBOutlet weak var PostTable_UserProfile: UIImageView!
    @IBOutlet weak var PostTable_UserID: UILabel!
    @IBOutlet weak var PostTable_Img: UIImageView!
    @IBOutlet weak var PostTable_Category: UILabel!
    var cellconfigure = configure()
    var headers: HTTPHeaders = ["Accept" : "application/json"]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 10)
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = false
        self.layer.shadowOpacity = 0.23
        self.layer.shadowRadius = 4
        self.PostTable_content.isUserInteractionEnabled = true
        self.PostTable_content.isEditable = false
        //        self.Post_UserProfile.frame = CGRect(x: 20, y: 0, width: 80, height: 80)
        self.PostTable_UserProfile.layer.cornerRadius = self.PostTable_UserProfile.frame.height/2
        self.PostTable_UserProfile.clipsToBounds = true
        self.PostTable_UserProfile.layer.borderColor = UIColor.lightGray.cgColor
        self.PostTable_UserProfile.layer.borderWidth = 1.0
        self.PostTable_UserID.textAlignment = .left
        self.PostTable_UserID.font = UIFont.systemFont(ofSize: 15)
        self.PostTable_UserID.textColor = UIColor.lightGray
        
        let deviceWidth = UIScreen.main.bounds.width
        self.PostTableBackView.frame = CGRect(x: self.frame.origin.x, y: 0, width: self.frame.size.width, height: self.contentView.frame.height)
        self.PostTableBackView.layer.shadowColor = UIColor.darkGray.cgColor
        self.PostTableBackView.layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
        self.PostTableBackView.layer.shadowRadius = 25.0
        self.PostTableBackView.layer.shadowOpacity = 0.9
        self.PostTableBackView.layer.masksToBounds = true
        self.PostTableBackView.layer.shadowPath = UIBezierPath(roundedRect: self.PostTableBackView.bounds, cornerRadius: 10).cgPath
        self.PostTableBackView.layer.shouldRasterize = true
        self.PostTableBackView.layer.rasterizationScale = UIScreen.main.scale
        self.ImageCollectionView.register(UINib(nibName: "ImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ImageCell")
        self.ImageCollectionView.delegate = self
        self.ImageCollectionView.dataSource = self
        WIPICK_PHOTO_ARRAYCONTENT_GET(url: "http://192.168.8.103:8002/WIPICK_GET_PHOTOWITH_CONTENT", method: .get, header: headers)
        print("이미지 wipick_image입니다 \(self.cellconfigure.WIPICK_IMG)")
        // Initialization code
    }
    
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    private func WIPICK_PHOTO_ARRAYCONTENT_GET(url : String, method : HTTPMethod ,header : HTTPHeaders){
        Alamofire.request(url, method: method, encoding: JSONEncoding.prettyPrinted, headers: header).responseJSON{ (response) in
            if let data = response.result.value {
                let json = JSON(data)
                for (key,subJson):(String,JSON) in json["content"] {
                    debugPrint(key)
                    debugPrint(subJson)
                    self.cellconfigure.WIPICK_IMG.append(subJson["img"].stringValue)
                }
                var ArrayData : [String?] = []
                for i in 0..<self.cellconfigure.WIPICK_IMG.count{
                    for ImageData in self.cellconfigure.WIPICK_IMG {
                        ArrayData = (ImageData?.components(separatedBy: ","))!
                    }
                    self.cellconfigure.WIPICK_IMG.insert(contentsOf: ArrayData, at: i)
                }
            }
            DispatchQueue.main.async {
                self.ImageCollectionView.reloadData()
                
            }
        }
    }
    
    
}





extension PostTableViewCell : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  self.cellconfigure.WIPICK_IMG.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let ImageCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as? ImageCollectionViewCell
        print("이미지 wipick_image입니다 \(self.cellconfigure.WIPICK_IMG)")
        
        if self.cellconfigure.WIPICK_IMG.isEmpty == true || self.cellconfigure.WIPICK_IMG == nil {
            ImageCell?.Post_ImageView.isHidden = true
        }else{
//            let componetUrl : URL = URL(string: self.cellconfigure.WIPICK_IMG[indexPath.row]!)!
//            let ComponentData : Data = try! Data(contentsOf: componetUrl)
//            ImageCell?.Post_ImageView.contentMode = .scaleAspectFill
//            ImageCell?.Post_ImageView.clipsToBounds = true
//            ImageCell?.Post_ImageView.image = UIImage(data: ComponentData)?.resizeImage(size: CGSize(width: 100, height: 100)).withRenderingMode(.alwaysOriginal)
        }
        
        
        return ImageCell!
        return UICollectionViewCell()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        
        return UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        return CGSize(width: 100, height: 100)
    }
    
}
