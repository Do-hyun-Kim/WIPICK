//
//  CategoryViewController.swift
//  WiPick
//
//  Created by 김도현 on 19/02/2020.
//  Copyright © 2020 김도현. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON



struct categoryconfigure {
    var WiPICK_Category_TITLE : [String?] = []
    var WIPICK_Category_CONTENT : [String?] = []
    var WIPICK_Category_IMG : [String?] = []
    var WIPICK_Category_PROFILEIMG : [String?] = []
    var WIPICK_Category_NICKNAME : [String?] = []
}

class CategoryViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    
//Category XIB
//Category identifier : CategoryCell
//
    
    
    @IBOutlet weak var CategoryCollectionView: UICollectionView!
    var headers: HTTPHeaders = ["Content-Type":"application/json;charset:utf-8"]
    var CategoryConfigure = categoryconfigure()
    override func viewDidLoad() {
        super.viewDidLoad()
        let CategoryData = self.navigationItem.title
//        self.CategoryCollectionLayout()
        guard let DataBinding = CategoryData else { return }
        var paramter : Parameters = ["Category" : "\(DataBinding)"]
        self.WIPCIK_CATEGORY_CONTENT(url: "http://172.30.1.10:8002/WIPICK_CATEGORY_POST/\(DataBinding)", method: .get, paramter: paramter, headers: headers)
        self.CategoryCollectionView.delegate = self
        self.CategoryCollectionView.dataSource = self
        self.CategoryCollectionView.register(UINib(nibName: "CategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CategoryCell")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    public func CategoryCollectionLayout(){

        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CategoryConfigure.WIPICK_Category_CONTENT.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let CategoryCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as? CategoryCollectionViewCell
        
        //Title DB
        CategoryCell?.CategoryTitle.text = self.CategoryConfigure.WiPICK_Category_TITLE[indexPath.row]
        
        //Content DB
        CategoryCell?.CategoryContent.text = self.CategoryConfigure.WIPICK_Category_CONTENT[indexPath.row]
        
        //NICKNAME DB
        if (self.CategoryConfigure.WIPICK_Category_NICKNAME[indexPath.row]?.isEmpty == true) {
            CategoryCell?.CategoryUserID.text = "컴맹"
        }else{
            CategoryCell?.CategoryUserID.text = self.CategoryConfigure.WIPICK_Category_NICKNAME[indexPath.row]
        }
        
        //ProfileImage DB
        if self.CategoryConfigure.WIPICK_Category_PROFILEIMG[indexPath.row]?.isEmpty == true {
            CategoryCell?.CategoryUserProfile.isHidden = true
        }else{
            
            let ProfileURL = URL(string: self.CategoryConfigure.WIPICK_Category_PROFILEIMG[indexPath.row]!)
            if let ProfileImage =  ProfileURL{
                let ProfileData = try? Data(contentsOf: ProfileImage)
                CategoryCell?.CategoryUserProfile.image = UIImage(data: ProfileData!)
            }
        }
    
        //ContentImage DB
        if self.CategoryConfigure.WIPICK_Category_IMG[indexPath.row] == nil {
            CategoryCell?.CategoryImg.isHidden = true
        }else{
            let ImageURL : URL = URL(string: self.CategoryConfigure.WIPICK_Category_IMG[indexPath.row]!)!
            let ImageData : Data = try! Data(contentsOf: ImageURL)
            CategoryCell?.CategoryImg.image = UIImage(data: ImageData)?.resizeImage(size: CGSize(width: (CategoryCell?.frame.size.width)!, height: (CategoryCell?.CategoryImg.frame.size.height)!))
        }
        
        
        return CategoryCell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 400, height: 350)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    }
    
    
     func WIPCIK_CATEGORY_CONTENT(url : String, method : HTTPMethod, paramter : Parameters,headers : HTTPHeaders) {
        Alamofire.request(url, method: method, encoding: JSONEncoding.prettyPrinted, headers: headers).responseJSON { (response) in
            if let data = response.result.value {
                print(data)
                let json = JSON(data)
                    for (key,subJson):(String,JSON) in json["Categorycontent"] {
                        debugPrint(key)
                        debugPrint(subJson)
                        self.CategoryConfigure.WiPICK_Category_TITLE.append(subJson["title"].stringValue)
                        self.CategoryConfigure.WIPICK_Category_CONTENT.append(subJson["content"].stringValue)
                        self.CategoryConfigure.WIPICK_Category_IMG.append(subJson["img"].stringValue)
                        self.CategoryConfigure.WIPICK_Category_PROFILEIMG.append(subJson["profileImg"].stringValue)
                        self.CategoryConfigure.WIPICK_Category_NICKNAME.append(subJson["WiPiCK_ID"].stringValue)
                        
                        print("테스트 입니다\(subJson["title"])")
                        print("테스트 content입니다\(subJson["content"])")
                        print("테스트 img입니다\(subJson["img"])")
                        print("테스트 Profileimg입니다\(subJson["profileImg"])")
                        print("테스트 Profileimg입니다\(subJson["WiPiCK_ID"])")
                        print("테스트 Category 입니다\(subJson["Category"])")
                    }
                }
                DispatchQueue.main.async {
                    self.CategoryCollectionView.reloadData()
                }
            }
        }
}
