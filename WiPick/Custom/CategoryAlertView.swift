//
//  CategoryAlertView.swift
//  WiPick
//
//  Created by 김도현 on 01/06/2020.
//  Copyright © 2020 김도현. All rights reserved.
//

import UIKit
import Alamofire







class CategoryAlertView: UIView,UICollectionViewDataSource,UICollectionViewDelegate {
    @IBOutlet weak var CategoryParentView: UIView!
    @IBOutlet weak var CategoryCollectionView: UICollectionView!
    @IBOutlet weak var CategoryAlertTitle: UILabel!
    @IBOutlet weak var CategoryAlertNaviBar: UIView!
    @IBOutlet weak var CategoryAlertImg: UIImageView!
    var CategoryData = ""
    let Category = ["Kotiln","Swift","C++","JAVA","JS","C#","Ionic","Python"]
    var selected: Bool {
        get {
            return false
        }
        set {
            _ = true
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //        self.addSubview(CategoryCollectionView)
    }
    
    
    
    override func layoutSubviews() {
        self.initCollectionView()
        self.CustomAlertLayout()
    }
    
    
    class func instanceFromNib() -> UIView{
        return UINib(nibName: "CategoryAlertView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
        
    }
    
    
    
    
    private func initCollectionView(){
        let CategoryNib = UINib(nibName: "CategoryDetailCollectionViewCell", bundle: nil)
        CategoryCollectionView.register(CategoryNib, forCellWithReuseIdentifier: "CategoryDetail")
        CategoryCollectionView.delegate = self
        CategoryCollectionView.dataSource = self
        
        CategoryCollectionView.frame = CGRect(x: self.CategoryCollectionView.frame.origin.x, y: self.CategoryCollectionView.frame.origin.y, width: self.CategoryParentView.frame.size.width, height: self.CategoryCollectionView.frame.size.height)
    }
    private func CustomAlertLayout(){
        self.CategoryAlertTitle.text = "카테고리"
        self.CategoryAlertTitle.font = UIFont.systemFont(ofSize: 20)
        self.CategoryAlertTitle.textColor = UIColor.white
        self.CategoryAlertTitle.textAlignment = .center
        self.CategoryAlertTitle.frame = CGRect(x: self.CategoryAlertTitle.frame.origin.x, y: self.CategoryAlertTitle.frame.origin.y, width: self.CategoryAlertTitle.frame.size.width, height: self.CategoryAlertTitle.frame.size.height)
        self.CategoryAlertImg.image = UIImage(named: "category4.png")
        self.CategoryAlertImg.contentMode = .scaleAspectFit
        self.CategoryAlertNaviBar.backgroundColor = UIColor(red: 255/255, green: 101/255, blue: 83/255, alpha: 1.0)
        
        
    }
    
    override func awakeFromNib() {
        self.CategoryCollectionView.delegate = self
        self.CategoryCollectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let CategoryDetailCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryDetail", for: indexPath) as? CategoryDetailCollectionViewCell
        
        CategoryDetailCell?.CategoryTitle.setTitle(self.Category[indexPath.row], for: .normal)
        CategoryDetailCell?.CategoryTitle.layer.cornerRadius = (CategoryDetailCell?.CategoryTitle.frame.size.height)! / 2
        CategoryDetailCell?.CategoryTitle.layer.borderColor = UIColor.gray.cgColor
        //            CategoryDetailCell?.CategoryTitle.tag = indexPath.item
        //            CategoryDetailCell?.CategoryTitle.addTarget(self, action: #selector(self.CateogrySeletor(_:)), for: .touchUpInside)
        
        return CategoryDetailCell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let CategorySelectCell = collectionView.cellForItem(at: indexPath) as? CategoryDetailCollectionViewCell {
            switch indexPath.item {
            case MainCategory.KotilnCategory.rawValue:
                CategorySelectCell.CategoryTitle.layer.borderColor = UIColor(red: 249/255, green: 1/255, blue: 203/255, alpha: 1.0).cgColor
                CategorySelectCell.CategoryTitle.setTitleColor(UIColor(red: 249/255, green: 1/255, blue: 203/255, alpha: 1.0), for: .normal)
            case MainCategory.SwiftCategory.rawValue:
                CategorySelectCell.CategoryTitle.layer.borderColor = UIColor(red: 249/255, green: 1/255, blue: 203/255, alpha: 1.0).cgColor
                CategorySelectCell.CategoryTitle.setTitleColor(UIColor(red: 249/255, green: 1/255, blue: 203/255, alpha: 1.0), for: .normal)
            case MainCategory.C_PlusCategory.rawValue:
                CategorySelectCell.CategoryTitle.layer.borderColor = UIColor(red: 249/255, green: 1/255, blue: 203/255, alpha: 1.0).cgColor
                CategorySelectCell.CategoryTitle.setTitleColor(UIColor(red: 249/255, green: 1/255, blue: 203/255, alpha: 1.0), for: .normal)
            case MainCategory.JavaCategory.rawValue:
                CategorySelectCell.CategoryTitle.layer.borderColor = UIColor(red: 249/255, green: 1/255, blue: 203/255, alpha: 1.0).cgColor
                CategorySelectCell.CategoryTitle.setTitleColor(UIColor(red: 249/255, green: 1/255, blue: 203/255, alpha: 1.0), for: .normal)
            case MainCategory.JavaScriptCategory.rawValue:
                CategorySelectCell.CategoryTitle.layer.borderColor = UIColor(red: 249/255, green: 1/255, blue: 203/255, alpha: 1.0).cgColor
                CategorySelectCell.CategoryTitle.setTitleColor(UIColor(red: 249/255, green: 1/255, blue: 203/255, alpha: 1.0), for: .normal)
            case MainCategory.C_symbolsCategory.rawValue :
                CategorySelectCell.CategoryTitle.layer.borderColor = UIColor(red: 249/255, green: 1/255, blue: 203/255, alpha: 1.0).cgColor
                CategorySelectCell.CategoryTitle.setTitleColor(UIColor(red: 249/255, green: 1/255, blue: 203/255, alpha: 1.0), for: .normal)
            case MainCategory.IonicCategory.rawValue :
                CategorySelectCell.CategoryTitle.layer.borderColor = UIColor(red: 249/255, green: 1/255, blue: 203/255, alpha: 1.0).cgColor
                CategorySelectCell.CategoryTitle.setTitleColor(UIColor(red: 249/255, green: 1/255, blue: 203/255, alpha: 1.0), for: .normal)
            case MainCategory.PythonCategory.rawValue :
                CategorySelectCell.CategoryTitle.layer.borderColor = UIColor(red: 249/255, green: 1/255, blue: 203/255, alpha: 1.0).cgColor
                CategorySelectCell.CategoryTitle.setTitleColor(UIColor(red: 249/255, green: 1/255, blue: 203/255, alpha: 1.0), for: .normal)
            default:
                CategorySelectCell.CategoryTitle.layer.borderColor = UIColor.lightGray.cgColor
                CategorySelectCell.CategoryTitle.setTitleColor(UIColor.lightGray, for: .normal)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.Category.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 150, height: 10)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 50, bottom: 0, right: 50)
    }
    
    
}


