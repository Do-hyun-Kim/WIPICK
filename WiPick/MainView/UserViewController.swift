//
//  UserViewController.swift
//  WiPick
//
//  Created by 김도현 on 19/12/2019.
//  Copyright © 2019 김도현. All rights reserved.
//

import UIKit
import KakaoOpenSDK
import Alamofire
import SwiftyJSON
import WebKit


struct Userconfigure {
    var WIPICK_PROFILEIMG : [String?] = []
    var WIPICK_NICKNAME : [String?] = []
}



class UserViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,WKUIDelegate,WKNavigationDelegate {
    
    

   
    @IBOutlet var ProfileWebView: WKWebView!
    @IBOutlet weak var UserPostTableView: UITableView!
    @IBOutlet weak var CustomNaviBar: UINavigationBar!
    var UserConfigureDB = Userconfigure()
    let UserDB = KakaoUserInfo()
    private let GetHeader : HTTPHeaders = ["Accept" : "application/json"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.backgroundColor = UIColor.clear
        let attributes = [NSAttributedString.Key.font: UIFont(name: "Symbol", size: 18)!]
        UINavigationBar.appearance().titleTextAttributes = attributes
        
//      UserPostCell delegate
        self.UserPostTableView.delegate = self
        self.UserPostTableView.dataSource = self
        //WIPICK SERVER CODE
        self.WIPICK_APP_CHECK_GET(url: "http://172.30.1.10:8002/WIPICK_APP_CHECK_GET", method: .get, header: self.GetHeader)
        self.setUserLayout()
        
        //이미지 Tab event시 webProfile 호출 기능 넣을지 고민
//        let ProfileWebviewRequest = UITapGestureRecognizer(target: self, action: #selector(WebviewProfile))
//        ProfileImageView.addGestureRecognizer(ProfileWebviewRequest)
        
    }
    
    
    //탭 버튼이동시 navigation title이 안변함 PostViewController viewwillappear NaviBar 쪽 의심
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = true
        //Kakao DB NickName 조회
        self.WIPICK_APP_CHECK_GET(url: "http://172.30.1.10:8002/WIPICK_APP_CHECK_GET", method: .get, header: self.GetHeader)
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.navigationController?.isNavigationBarHidden = false

    }
    private var PostCountLabel : UILabel = {
       let PostLabel = UILabel()
        PostLabel.frame = CGRect(x: 150, y: 120, width: 50, height: 50)
        PostLabel.font = UIFont.boldSystemFont(ofSize: 17)
        PostLabel.text = "2"
        PostLabel.textColor = UIColor.black
        PostLabel.textAlignment = .center
        return PostLabel
    }()
    private var PostCountNameLabel : UILabel = {
        let PostNameLabel = UILabel()
        PostNameLabel.frame = CGRect(x: 150, y: 150, width: 50, height: 50)
        PostNameLabel.font = UIFont.systemFont(ofSize: 15)
        PostNameLabel.text = "게시물"
        PostNameLabel.textColor = UIColor.black
        PostNameLabel.textAlignment = .center
        return PostNameLabel
    }()
    
    private var FollwerCountLabel : UILabel = {
        let FollwerLabel = UILabel()
        FollwerLabel.frame = CGRect(x: 240, y: 120, width: 50, height: 50)
        FollwerLabel.font = UIFont.boldSystemFont(ofSize: 17)
        FollwerLabel.text = "97"
        FollwerLabel.textColor = UIColor.black
        FollwerLabel.textAlignment = .center
        return FollwerLabel
    }()
    
    private var FollwerNameLabel : UILabel = {
        let FollwerName = UILabel()
        FollwerName.frame = CGRect(x: 240, y: 150, width: 50, height: 50)
        FollwerName.font = UIFont.systemFont(ofSize: 15)
        FollwerName.text = "팔로워"
        FollwerName.textColor = UIColor.black
        FollwerName.textAlignment = .center
        return FollwerName
    }()
    
    private var FollwingCountLabel : UILabel = {
        let FollwingLabel = UILabel()
        FollwingLabel.frame = CGRect(x: 330, y: 120, width: 50, height: 50)
        FollwingLabel.font = UIFont.boldSystemFont(ofSize: 17)
        FollwingLabel.text = "102"
        FollwingLabel.textColor = UIColor.black
        FollwingLabel.textAlignment = .center
        
        
        return FollwingLabel
    }()
    
    private var FollwingNameLabel : UILabel = {
        let FollwingName = UILabel()
        FollwingName.frame = CGRect(x: 330, y: 150, width: 50, height: 50)
        FollwingName.font = UIFont.systemFont(ofSize: 15)
        FollwingName.text = "팔로윙"
        FollwingName.textColor = UIColor.black
        FollwingName.textAlignment = .center
        return FollwingName
    }()
    private var ProfileName : UILabel = {
        let KakaoName = UILabel()
        KakaoName.frame = CGRect(x: 20, y: 200, width: 50, height: 50)
        KakaoName.font = UIFont.boldSystemFont(ofSize: 15)
        KakaoName.textColor = UIColor.black
        KakaoName.textAlignment = .center
        
        return KakaoName
    }()
    
    
    private lazy var FollwingButton : UIButton = {
        let UserFollwingButton : UIButton = UIButton(type: UIButton.ButtonType.custom)
        UserFollwingButton.backgroundColor = .clear
        UserFollwingButton.setTitle("팔로윙 하기", for: .normal)
        UserFollwingButton.layer.borderColor = UIColor.systemBlue.cgColor
        UserFollwingButton.layer.borderWidth = 1.0
        UserFollwingButton.setTitleColor(.systemBlue, for: .normal)
        UserFollwingButton.frame = CGRect(x: 250, y: 230, width: 130, height: 40)
        UserFollwingButton.layer.cornerRadius = 20.0
        
        return UserFollwingButton
    }()
    
    
    
    //KakaoProfileImageView
    private var ProfileImageView : UIImageView = {
        let KakaoImageView = UIImageView()
        //KakaoImageView Circle Custom
        KakaoImageView.frame = CGRect(x: 20, y: 100, width: 100, height: 100)
        KakaoImageView.layer.cornerRadius = KakaoImageView.frame.height/2
        KakaoImageView.clipsToBounds = true
        KakaoImageView.layer.borderColor = UIColor.lightGray.cgColor
        KakaoImageView.isUserInteractionEnabled = true
        KakaoImageView.layer.borderWidth = 1.0
        
        return KakaoImageView
    }()
    private func setUserLayout(){
        UINavigationBar.clearShadow()
        self.CustomNaviBar.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 300)
        //추후 UI 수정
        self.CustomNaviBar.topItem?.title = "User"
        self.tabBarController?.tabBar.tintColor = .black
        self.CustomNaviBar.layer.applyShadow(color: .gray, alpha: 0.3, x: 0, y: 0, blur: 12)
        self.CustomNaviBar.backgroundColor = .white
        self.CustomNaviBar.addSubview(ProfileImageView)
        self.CustomNaviBar.addSubview(PostCountLabel)
        self.CustomNaviBar.addSubview(PostCountNameLabel)
        self.CustomNaviBar.addSubview(FollwerCountLabel)
        self.CustomNaviBar.addSubview(FollwerNameLabel)
        self.CustomNaviBar.addSubview(FollwingCountLabel)
        self.CustomNaviBar.addSubview(FollwingNameLabel)
        self.CustomNaviBar.addSubview(ProfileName)
        self.CustomNaviBar.addSubview(FollwingButton)
        FollwingButton.addTarget(self, action: #selector(self.FollwingRequest(_:)), for: .touchUpInside)
        UserPostTableView.register(UINib(nibName: "UserTableViewCell", bundle: nil), forCellReuseIdentifier: "UserCell")
        UserPostTableView.separatorInset.left = 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let UserCell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as? UserTableViewCell
        
        return UserCell!
    }
    
//    @objc public func WebviewProfile(){
//            ProfileWebView.uiDelegate = self
//        ProfileWebView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
//            ProfileWebView.navigationDelegate = self
//            for Profile in self.UserConfigureDB.WIPICK_PROFILEIMG {
//                guard let ProfileUrl = Profile else { return }
//                let WebviewURL : URL = URL(string: ProfileUrl)!
//                let WebViewRequest : URLRequest = URLRequest(url: WebviewURL)
//                ProfileWebView.load(WebViewRequest)
//        }
//        self.view.addSubview(ProfileWebView)
//
//    }
    
    
    /*
     요기 수정 for문을 사용해서 Server DB사용자들 모두 Following되버림
     if문으로 예외처리 
     */
    @objc public func FollwingRequest(_: UIButton){
        let followingParamter : Parameters = ["WIPICK_ID" : "\(self.UserConfigureDB.WIPICK_NICKNAME)"]
        for UserName in self.UserConfigureDB.WIPICK_NICKNAME {
            if let OptinalName = UserName {
                self.WIPICK_APP_POST_Follwing(WIPICK_ID: OptinalName, method: .post)
            }
        }
        
    }
    
    
    private func WIPICK_APP_POST_Follwing(WIPICK_ID : String, method : HTTPMethod){
        let FollwingURL : String = "http://172.30.1.10:8002/"+WIPICK_ID+"/follow"
        Alamofire.request(FollwingURL, method: .post, encoding: URLEncoding.default)
            .responseJSON { (response) in
                print(response.result.error)
                print(response.result.isSuccess)
        }
        
        
    }
    
    
    private func WIPICK_APP_CHECK_GET(url : String, method : HTTPMethod ,header : HTTPHeaders){
        Alamofire.request(url, method: method, encoding: JSONEncoding.prettyPrinted, headers: header).responseJSON{ (response) in
            if let data = response.result.value {
                let json = JSON(data)
                for (key,subJson):(String,JSON) in json["content"] {
                    debugPrint(key)
                    debugPrint(subJson)
                    self.UserConfigureDB.WIPICK_NICKNAME.append(subJson["WIPICK_ID"].stringValue)
                    self.UserConfigureDB.WIPICK_PROFILEIMG.append(subJson["profile"].stringValue)
                    print("테스트 ProfileImg입니다\(subJson["WIPICK_ID"])")
                    print("테스트 WIPICK_ID입니다\(subJson["profile"])")
                }
                //바로 되버렸져 ㅎㅎ
                //for문 만능이에여 
                DispatchQueue.main.async {
                    for Name in self.UserConfigureDB.WIPICK_NICKNAME {
                        print("kakaoNickName\(String(describing: Name))")
                        if Name == UserDefaults.standard.string(forKey: "NickName") {
                            self.ProfileName.text = Name
                        }
                    }
                    for Profile in self.UserConfigureDB.WIPICK_PROFILEIMG {
                        print("KakaoProfile\(String(describing: Profile))")
                        //흠 옵셔널 바인딩을 if문 안에 하니 좋지않네,,
                        //우선 RxSwift하기전엔 이렇게 하구
                        //Source Review : 김도현  Kakao Profile은 http로 넘어옴 그러니 Url로 받고 image는 당연히 data로 처리 ㅎㅎ 그리고 imageview에 담거버리면 끝
                        //추후 webview에 넣어서 클릭시 크게 볼수있게 처리할거
                        if Profile == UserDefaults.standard.string(forKey: "Profile") {
                            if let OpthinalUrl = Profile {
                                let BinderUrl : URL = URL(string: OpthinalUrl)!
                                let ProfileData : Data = try! Data(contentsOf: BinderUrl)
                                self.ProfileImageView.image = UIImage(data: ProfileData)
                                //체크 네이버 로그인 프로필 이미지 가져오는거 체크
                            }else if Profile == UserDefaults.standard.string(forKey: "NaverProfile"){
                                if let NaverOpthinalUrl = Profile {
                                let BinderUrl : URL = URL(string: NaverOpthinalUrl)!
                                let ProfileData : Data = try! Data(contentsOf: BinderUrl)
                                self.ProfileImageView.image = UIImage(data: ProfileData)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    
}

private func fetchModel<T: Decodable>(completion: @escaping (T?) -> Void) {
    let url = URL(string: "...")!
    URLSession.shared.dataTask(with: url) { data, response, error in
        guard let data = data else {
            return completion(nil)
        }
        
        guard let model = try? JSONDecoder().decode(T.self, from: data) else {
            return completion(nil)
        }
        
        completion(model)
    }.resume()
}



extension UINavigationBar {
    static func clearShadow() {
            UINavigationBar.appearance().shadowImage = UIImage()
            UINavigationBar.appearance().backgroundColor = UIColor.white
        }
}

