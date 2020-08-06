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





class PostViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    

    
    
    
    
  
    
    @IBOutlet weak var PostTableView: UITableView!
    @IBOutlet weak var PostCollectionView: UICollectionView!
    var cellconfigure = configure()
    var headers: HTTPHeaders = ["Accept" : "application/json"]
    var arrRes = [[String:AnyObject]]()
    var heders2 : HTTPHeaders = ["Accept" : "application/json","Content-Type": "application/x-www-form-urlencoded"]
    
    lazy var ImageButton : UIButton = {
           let LigthButton = UIButton(type: .custom)
           LigthButton.setImage(UIImage(named: "bell.png"), for: .normal)
           
           LigthButton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
           LigthButton.layer.masksToBounds = false
           LigthButton.addTarget(self, action: #selector(NavigationAction(_:)), for: .touchUpInside)
           
           return LigthButton
       }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        WIPICK_PHOTO_WITHCONTENT_GET(url: "http://192.168.8.103:8002/WIPICK_GET_PHOTOWITH_CONTENT", method: .get, header: headers)
//        PostCollectionView.delegate = self
//        PostCollectionView.dataSource = self
//        PostCollectionView.register(UINib(nibName: "PostCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PostCell")
        self.PostTableView.delegate = self
        self.PostTableView.dataSource = self
        self.PostTableView.register(UINib(nibName: "PostTableViewCell", bundle: nil), forCellReuseIdentifier: "PostTableView")
        self.PostTableView.separatorStyle = .none
        self.PostTableView.estimatedRowHeight = 350
        self.PostTableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        let RightButton = UIBarButtonItem(customView: ImageButton)
        self.tabBarController?.navigationItem.rightBarButtonItem = RightButton
        self.initRefresh()
       
//        self.WIPICK_DELETE_CONTENT(url: "http://172.30.1.11:8002/WIPICK_DELETE_CONTENT/341", method: .delete, header: heders2)
    }
    
    
    
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
//        WIPICK_PHOTO_WITHCONTENT_GET(url: "http://172.30.1.22:8002/WIPICK_GET_PHOTOWITH_CONTENT", method: .get, header: headers)
        let RightButton = UIBarButtonItem(customView: ImageButton)
        self.tabBarController?.navigationItem.rightBarButtonItem = RightButton
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cellconfigure.WIPICK_CONTENT.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let PostTableCell = tableView.dequeueReusableCell(withIdentifier: "PostTableView", for: indexPath) as? PostTableViewCell
           PostTableCell?.contentView.layer.cornerRadius = 5.0
        //        PostCell?.layer.borderColor = UIColor.black.cgColor
        //        PostCell?.layer.borderWidth = 1.0

                //Server DB GET
                PostTableCell?.PostTable_Title.text = self.cellconfigure.WiPICK_TITLE[indexPath.row]
                PostTableCell?.PostTable_content.text = self.cellconfigure.WIPICK_CONTENT[indexPath.row]
                if self.cellconfigure.WIPICK_PROFILEIMG[indexPath.row]?.isEmpty == true{
                    PostTableCell?.PostTable_UserProfile.image = UIImage(named: "profile.png")
                }else if self.cellconfigure.WIPICK_PROFILEIMG[indexPath.row]?.isValidURL() == true{
                    let PostUrl : URL?  = URL(string: self.cellconfigure.WIPICK_PROFILEIMG[indexPath.row]!)
                    if let OptionalBinding = PostUrl {
                        let PostData : Data = try! Data(contentsOf: OptionalBinding)
                        PostTableCell?.PostTable_UserProfile.image = UIImage(data: PostData)
                        PostTableCell?.PostTable_UserProfile.contentMode = .scaleToFill
                }
                    
                if self.cellconfigure.WIPICK_IMG[indexPath.row] == nil {
                    PostTableCell?.PostTable_Img.isHidden = true
                }else{
                    //ContentImage data
        //            let ImageURL : URL = URL(string: self.cellconfigure.WIPICK_IMG[indexPath.row]!)!
        //            let ImageData : Data = try! Data(contentsOf: ImageURL)
        //            PostCell?.Post_Img.image = UIImage(data: ImageData)?.resizeImage(size: CGSize(width: (PostCell?.frame.size.width)!, height: (PostCell?.Post_Img.frame.size.height)!))
                    
                }
                    //Name Data
                    
                    if (self.cellconfigure.WIPICK_NICKNAME[indexPath.row]?.isEmpty == true){
                        PostTableCell?.PostTable_UserID.text = "컴맹"
                    }else{
                        PostTableCell?.PostTable_UserID.text = self.cellconfigure.WIPICK_NICKNAME[indexPath.row]
                    }
                }
                PostTableCell?.PostTable_Category.text = self.cellconfigure.WIPICK_Category[indexPath.row]
                
               
             
        
         
        
        
        return PostTableCell!
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 350
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let PostMainView = tableView.cellForRow(at: indexPath) as? PostTableViewCell else {
                    return
        
                }
        
                let PostMainSB : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                guard let PostVC = PostMainSB.instantiateViewController(identifier: "PostVC") as? PostMainViewController  else { return }
        
        
            if let NameData = PostMainView.PostTable_UserID.text {
                    PostVC.PostMainName = NameData
                }
                if let ImageData = PostMainView.PostTable_UserProfile.image {
                    PostVC.PostMainProfile = ImageData
                }
        
//                if let ContentData = PostMainView.PostTable_Img.image {
//                    PostVC.PostMainContentImage = ContentData
//                }
        
                if let ContentTitleData = PostMainView.PostTable_Title.text {
                    PostVC.PostMainTitle = ContentTitleData
                }
        
                if let ContentText = PostMainView.PostTable_content.text {
                    PostVC.PostMainContent = ContentText
                }
        
                if let CategoryData = PostMainView.PostTable_Category.text {
                    PostVC.PostMainCategory = CategoryData
                }
        
                PostVC.PostMainID = indexPath.row
        
        
                self.navigationController?.pushViewController(PostVC, animated: true)
        
        //        self.performSegue(withIdentifier: "PostMainView", sender: self.cellconfigure.WIPICK_NICKNAME[indexPath.row])
    }
   
    
    
    
    
    
    
    
    
    
    
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: 400, height: 350)
//    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
//    }
//
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        guard let PostMainView = collectionView.cellForItem(at: indexPath) as? PostCollectionViewCell else {
//            return
//
//        }
//
//        let PostMainSB : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        guard let PostVC = PostMainSB.instantiateViewController(identifier: "PostVC") as? PostMainViewController  else { return }
//
//
//        if let NameData = PostMainView.Post_UserID.text {
//            PostVC.PostMainName = NameData
//        }
//        if let ImageData = PostMainView.Post_UserProfile.image {
//            PostVC.PostMainProfile = ImageData
//        }
//
//        if let ContentData = PostMainView.Post_Img.image {
//            PostVC.PostMainContentImage = ContentData
//        }
//
//        if let ContentTitleData = PostMainView.Post_Title.text {
//            PostVC.PostMainTitle = ContentTitleData
//        }
//
//        if let ContentText = PostMainView.Post_content.text {
//            PostVC.PostMainContent = ContentText
//        }
//
//        if let CategoryData = PostMainView.Post_Category.text {
//            PostVC.PostMainCategory = CategoryData
//        }
//
//        PostVC.PostMainID = indexPath.row
//
//
//        self.navigationController?.pushViewController(PostVC, animated: true)
//
////        self.performSegue(withIdentifier: "PostMainView", sender: self.cellconfigure.WIPICK_NICKNAME[indexPath.row])
//
//
//    }
    
    public func initRefresh(){
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(updateData(refresh:)), for: .valueChanged)
        refresh.clipsToBounds = true
        
        if #available(iOS 10.0, *) {
            self.PostTableView.refreshControl = refresh
        }else{
            self.PostTableView.addSubview(refresh)
        }
    }
    
    @objc func updateData(refresh : UIRefreshControl){
        refresh.endRefreshing()
        self.PostTableView.reloadData()
    }
    
    
    @objc func NavigationAction(_ sender : UIButton){
        let PostDetailViewController = UIStoryboard(name: "Main", bundle: nil)
        let PostVC = PostDetailViewController.instantiateViewController(identifier: "PostDetailSB")
        PostVC.modalPresentationStyle = .fullScreen
        self.present(PostVC, animated: true, completion: nil)
        
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
                    let cell = self.PostTableView.dequeueReusableCell(withIdentifier: "PostTableView", for: IndexPath.init(row: 0, section: 0)) as? PostTableViewCell
                    self.PostTableView.reloadData()
                    cell?.ImageCollectionView.reloadData()
//                    self.PostCollectionView.reloadData()
                }
            }
        }
    }
    
    
    
    //WIPICK_CONTENT : DELETE
    private func WIPICK_DELETE_CONTENT(url: String, method : HTTPMethod, header : HTTPHeaders) {
        let DeleteManager = Alamofire.SessionManager.default
        DeleteManager.request(url, method: method, headers: header).responseJSON { (response) in
            switch (response.result){
            case .success:
                print("WiPICK Delete 성공")
                break
            case .failure(let error):
                print("WiPICK  Delete 실패(\(error.localizedDescription))")
            }
        }
    }
    
    
    
    
    
    //WIPICK_CONTENT : GET
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
//                self.PostCollectionView.reloadData()
                self.PostTableView.reloadData()
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

