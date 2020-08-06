//
//  CategoryAlertView.swift
//  WiPick
//
//  Created by 김도현 on 01/06/2020.
//  Copyright © 2020 김도현. All rights reserved.
//

import UIKit
import Alamofire




enum state {
    case Confirm
    case Cancel
}




@IBDesignable extension CategoryAlertView {
    @IBInspectable var borderColor: UIColor? {
        set {
            layer.borderColor = newValue?.cgColor
        }
        get {
            guard let color = layer.borderColor else {
                return nil
            }
            return UIColor(cgColor: color)
        }
    }
    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
            clipsToBounds = newValue > 0
        }
        get {
            return layer.cornerRadius
        }
    }
}


class CategoryAlertView: UIView,UICollectionViewDataSource,UICollectionViewDelegate {
    @IBOutlet weak var CategoryParentView: UIView!
    @IBOutlet weak var CategoryCollectionView: UICollectionView!
    @IBOutlet weak var CategoryAlertTitle: UILabel!
    @IBOutlet weak var CategoryAlertNaviBar: UIView!
    @IBOutlet weak var CategoryAlertImg: UIImageView!
    @IBOutlet weak var CategoryAlerPostLabel: UILabel!
    @IBOutlet weak var CategoryConfirmButtom: UIButton!
    weak var PostDeailVC : PostDetailViewController?
    var CategoryTitle = ""
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
        
        self.CategoryConfirmButtom.addTarget(self, action: #selector(self.ConfirmAction), for: .touchUpInside)
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
        self.CategoryAlertNaviBar.layer.shadowOffset = CGSize(width: 1, height: 8)
        self.CategoryAlertNaviBar.layer.shadowColor = UIColor.gray.cgColor
        self.CategoryAlertNaviBar.layer.shadowOpacity = 10.0
        self.CategoryAlertNaviBar.layer.shadowRadius = 10.0
        self.CategoryAlertNaviBar.layer.masksToBounds = false
        
        self.CategoryAlerPostLabel.text = "* 한 가지 카테고리를 선택하세요"
        self.CategoryAlerPostLabel.textColor = UIColor.systemPink
        self.CategoryAlerPostLabel.font = UIFont.systemFont(ofSize: 11)
        self.CategoryConfirmButtom.setTitle("확인", for: .normal)
        self.CategoryConfirmButtom.tintColor = UIColor.black
        self.CategoryAlertNaviBar.layer.cornerRadius = 10.0
        self.CategoryParentView.layer.cornerRadius = 20.0
        self.CategoryConfirmButtom.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight(rawValue: 1.0))
        
    }
    
    @objc func ConfirmAction(){
        self.removeFromSuperview()
    }
    
    @objc func CancelAction(){
        self.removeFromSuperview()
    }
    
    //Auto Laoyout Code
    public func AlertButtonLayout(){
        
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
            if CategorySelectCell.CategoryTitle.isSelected == false {
                self.CategoryAlerPostLabel.text = "* 한 가지 카테고리만 선택하실수 있습니다."
                self.CategoryTitle = CategorySelectCell.CategoryTitle.titleLabel!.text!
                self.CategoryAlerPostLabel.textColor = UIColor.red
                
                self.PostDeailVC?.onConfirmUserAction(Confirmdata: self.CategoryTitle)
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
        
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    
}


