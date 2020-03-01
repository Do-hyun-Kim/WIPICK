//
//  PostViewController.swift
//  WiPick
//
//  Created by 김도현 on 19/12/2019.
//  Copyright © 2019 김도현. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import KakaoOpenSDK
import Photos
import ImageIO
import SnapKit

struct configure {
    var WiPICK_TITLE : [String?] = []
    var WIPICK_CONTENT : [String?] = []
    var WIPICK_IMG : [String?] = []
    var WIPICK_PROFILEIMG : [String?] = []
    var WIPICK_NICKNAME : [String?] = []
    var WIPICK_PROVIDER : String? = ""
    var WIPICK_Category : [String?] = []
}





class PostViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    
    
    
    
    @IBOutlet weak var PostCollectionView: UICollectionView!
    var cellconfigure = configure()
    var headers: HTTPHeaders = ["Accept" : "application/json"]
    var arrRes = [[String:AnyObject]]()
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setPostViewLayout()
        WIPICK_PHOTO_WITHCONTENT_GET(url: "http://172.30.1.10:8002/WIPICK_GET_PHOTOWITH_CONTENT", method: .get, header: headers)
//        WIPICK_APP_CHECK_GET(url: "http://172.30.1.11:8002/WIPICK_APP_CHECK_GET", method: .get, header: headers)
        PostCollectionView.delegate = self
        PostCollectionView.dataSource = self
        PostCollectionView.register(UINib(nibName: "PostCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PostCell")
        
        
    }
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
//        WIPICK_PHOTO_WITHCONTENT_GET(url: "http://172.30.1.22:8002/WIPICK_GET_PHOTOWITH_CONTENT", method: .get, header: headers)
        self.navigationController?.navigationBar.topItem?.title = "Post"
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellconfigure.WIPICK_CONTENT.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let PostCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostCell", for: indexPath) as? PostCollectionViewCell
        //Cell Layout source
        PostCell?.contentView.layer.cornerRadius = 5.0
//        PostCell?.layer.borderColor = UIColor.black.cgColor
//        PostCell?.layer.borderWidth = 1.0
        
        //Server DB GET
        PostCell?.Post_Title.text = self.cellconfigure.WiPICK_TITLE[indexPath.row]
        PostCell?.Post_content.text = self.cellconfigure.WIPICK_CONTENT[indexPath.row]
        if self.cellconfigure.WIPICK_PROFILEIMG[indexPath.row]?.isEmpty == true{
            PostCell?.Post_UserProfile.image = UIImage(named: "profile.png")
        }else if self.cellconfigure.WIPICK_PROFILEIMG[indexPath.row]?.isValidURL() == true{
            let PostUrl : URL?  = URL(string: self.cellconfigure.WIPICK_PROFILEIMG[indexPath.row]!)
            if let OptionalBinding = PostUrl {
                let PostData : Data = try! Data(contentsOf: OptionalBinding)
                PostCell?.Post_UserProfile.image = UIImage(data: PostData)
                PostCell?.Post_UserProfile.contentMode = .scaleToFill
        }
            
        if self.cellconfigure.WIPICK_IMG[indexPath.row] == nil {
            PostCell?.Post_Img.isHidden = true
        }else{
            //ContentImage data
            let ImageURL : URL = URL(string: self.cellconfigure.WIPICK_IMG[indexPath.row]!)!
            let ImageData : Data = try! Data(contentsOf: ImageURL)
            PostCell?.Post_Img.image = UIImage(data: ImageData)?.resizeImage(size: CGSize(width: (PostCell?.frame.size.width)!, height: (PostCell?.Post_Img.frame.size.height)!))
            
        }
            //Name Data
            if (self.cellconfigure.WIPICK_NICKNAME[indexPath.row]?.isEmpty == true){
                PostCell?.Post_UserID.text = "컴맹"
            }else{
                PostCell?.Post_UserID.text = self.cellconfigure.WIPICK_NICKNAME[indexPath.row]
            }
        }
        PostCell?.Post_Category.text = self.cellconfigure.WIPICK_Category[indexPath.row]

        
        return PostCell!
    }
    func convierteImagen(cadenaImagen: String) -> UIImage? {
        var strings = cadenaImagen.components(separatedBy: ",")
        var bytes = [UInt8]()
        for i in 0..<strings.count {
            if let signedByte = Int8(strings[i]) {
                bytes.append(UInt8(bitPattern: signedByte))
            } else {
                // Do something with this error condition
            }
        }
        let datos: Data = Data(bytes: bytes, count: bytes.count)
        return UIImage(data: datos)
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 400, height: 350)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let PostMainView = collectionView.cellForItem(at: indexPath) as? PostCollectionViewCell else {
            return

        }
        
        let PostMainSB : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        guard let PostVC = PostMainSB.instantiateViewController(identifier: "PostVC") as? PostMainViewController  else { return }

        
        if let NameData = PostMainView.Post_UserID.text {
            PostVC.PostMainName = NameData
        }
        if let ImageData = PostMainView.Post_UserProfile.image {
            PostVC.PostMainProfile = ImageData
        }
        
        if let ContentData = PostMainView.Post_Img.image {
            PostVC.PostMainContentImage = ContentData
        }
        
        if let ContentTitleData = PostMainView.Post_Title.text {
            PostVC.PostMainTitle = ContentTitleData
        }
        
        if let ContentText = PostMainView.Post_content.text {
            PostVC.PostMainContent = ContentText
        }
        
        if let CategoryData = PostMainView.Post_Category.text {
            PostVC.PostMainCategory = CategoryData
        }
        
        PostVC.PostMainID = indexPath.row
        
        
        self.navigationController?.pushViewController(PostVC, animated: true)
        
//        self.performSegue(withIdentifier: "PostMainView", sender: self.cellconfigure.WIPICK_NICKNAME[indexPath.row])
        
        
    }
    
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PostMainView" {
//            let PostCell = PostCollectionView.dequeueReusableCell(withReuseIdentifier: "PostCell", for: IndexPath(item: 0, section: 0)) as? PostCollectionViewCell
//            let indexpath = PostCollectionView.indexPath(for: PostCell!)
//                let PostVC = segue.destination as? PostMainViewController
//            PostVC?.MAIN_Nickname.text
//
//
//
//            let PostMainVC = segue.destination as? PostMainViewController
            
            
        }
    }
    
    
    
    
    
    @objc func NavigationAction(sender : UIBarButtonItem){
        let PostDetailViewController = UIStoryboard(name: "Main", bundle: nil)
        let PostVC = PostDetailViewController.instantiateViewController(identifier: "PostDetailSB")
        PostVC.modalPresentationStyle = .fullScreen
        self.present(PostVC, animated: true, completion: nil)
        
    }
    
    
    private func setPostViewLayout(){
        self.tabBarController?.tabBar.tintColor = .black
        self.navigationController?.navigationBar.topItem?.title = "Post"
        self.navigationController?.navigationBar.sizeThatFits(CGSize(width: UIScreen.main.bounds.width, height: 300))
    }
    
    
    //AutoLayout Code
    private func AutoResizeingLayout(){
      
        
    }
    
    private func WIPICK_APP_CHECK_GET(url : String, method : HTTPMethod ,header : HTTPHeaders){
        Alamofire.request(url, method: method, encoding: JSONEncoding.prettyPrinted, headers: header).responseJSON{ (response) in
            if let data = response.result.value {
                let json = JSON(data)
                for (key,subJson):(String,JSON) in json["content"] {
                    debugPrint(key)
                    debugPrint(subJson)
                    self.cellconfigure.WIPICK_PROVIDER = subJson["provider"].stringValue
//                    self.cellconfigure.WIPICK_PROFILEIMG.append(subJson["profile"].stringValue)
                    self.cellconfigure.WIPICK_NICKNAME.append(subJson["WiPiCK_ID"].stringValue)
                    print("테스트 ProfileImg입니다\(subJson["WIPICK_ID"])")
                    print("테스트 WIPICK_ID입니다\(subJson["profile"])")
                    print("테스트 Provider \(subJson["provider"])")
                }
                DispatchQueue.main.async {
                    self.PostCollectionView.reloadData()
                }
            }
        }
    }
    
    
    
    //SINGLE Content 일때만 서버 호출(IMAGE : NIL)
    private func WIPICK_SINGLE_CONTENT_GET(url: String, method : HTTPMethod, header : HTTPHeaders) {
        
        
        
        
    }
    
    
    
    
    
    
    private func WIPICK_PHOTO_WITHCONTENT_GET(url : String, method : HTTPMethod ,header : HTTPHeaders){
        Alamofire.request(url, method: method, encoding: JSONEncoding.prettyPrinted, headers: header).responseJSON{ (response) in
            if let data = response.result.value {
                let json = JSON(data)
                for (key,subJson):(String,JSON) in json["content"] {
                    debugPrint(key)
                    debugPrint(subJson)
                    self.cellconfigure.WiPICK_TITLE.append(subJson["title"].stringValue)
                    self.cellconfigure.WIPICK_CONTENT.append(subJson["content"].stringValue)
                    self.cellconfigure.WIPICK_IMG.append(subJson["img"].stringValue)
                    self.cellconfigure.WIPICK_PROFILEIMG.append(subJson["profileImg"].stringValue)
                    self.cellconfigure.WIPICK_NICKNAME.append(subJson["WiPiCK_ID"].stringValue)
                    self.cellconfigure.WIPICK_Category.append(subJson["Category"].stringValue)
                    
                    print("테스트 입니다\(subJson["title"])")
                    print("테스트 content입니다\(subJson["content"])")
                    print("테스트 img입니다\(subJson["img"])")
                    print("테스트 Profileimg입니다\(subJson["profileImg"])")
                    print("테스트 Profileimg입니다\(subJson["WiPiCK_ID"])")
                    print("테스트 Category 입니다\(subJson["Category"])")
                }
            }
            DispatchQueue.main.async {
                self.PostCollectionView.reloadData()
            }
        }
    }
    
}
 


// var arrRes = [[String:AnyObject]]()

extension String {

    func isValidURL() -> Bool {
        guard !contains("..") else { return false }

        let head     = "((https|File)://)?([(w|W)]{3}+\\.)?"
        let tail     = "\\.+[A-Za-z]{2,3}+(\\.)?+(/(.)*)?"
        let urlRegEx = head+"+(.)+"+tail

        let urlTest = NSPredicate(format:"SELF MATCHES %@", urlRegEx)
        return urlTest.evaluate(with: trimmingCharacters(in: .whitespaces))
    }
}

