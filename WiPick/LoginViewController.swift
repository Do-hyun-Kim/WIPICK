//
//  LoginViewController.swift
//  WiPick
//
//  Created by 김도현 on 05/12/2019.
//  Copyright © 2019 김도현. All rights reserved.
//

import UIKit
import Security
import KakaoOpenSDK
import NaverThirdPartyLogin
import Alamofire
import SnapKit

struct KakaoUserInfo {
    var UserProfile : String? = ""
    var UserName : String? = ""
    var UserId : String?
    var UserToken : String? = ""
}

struct NaverUserInfo {
    var NaverUserProfile : String? = ""
    var NaverUserName : String? = ""
    var NaverUserId : String?
}




//키체인 시큐리티 코딩
let KeychainToken = TokenUtils()
let AppBundle = Bundle.main.bundleIdentifier
class LoginViewController: UIViewController,NaverThirdPartyLoginConnectionDelegate{
    let uuid = NSUUID().uuidString.lowercased()
    public var headers: HTTPHeaders = ["Accept" : "application/json"]
    public var MuliteHeaders : HTTPHeaders = ["Content-type": "multipart/form-data",
                                              "Accept" : "application/json"]
    public var kakaoUserInfo = KakaoUserInfo()
    public var naverUserInfo = NaverUserInfo()
    let NaverloginInstance = NaverThirdPartyLoginConnection.getSharedInstance()
    @IBOutlet weak var NaverButton: UIButton!
    @IBOutlet weak var kakaobutton : KOLoginButton?
    @IBAction func KakaoLogin(_ sender: AnyObject) {
        kakaoLogin(sender)
    }
    
    @IBAction func NaverLogin(_ sender: AnyObject) {
        NaverloginInstance?.delegate = self
        NaverloginInstance?.requestThirdPartyLogin()
        self.NaverInfo()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tokenRefreshMillis(token: KeychainToken.load(AppBundle, account: "Kakao Token")!)
        print("token 정보 입니다\(KeychainToken.load(AppBundle, account: "Kakao Token"))")
        self.LoginViewButtonFrame()
        
    }
    
    func LoginViewButtonFrame(){
        
        NaverButton.snp.makeConstraints { (make) in
            make.left.equalTo(self.view).offset(46)
            make.right.equalTo(self.view).offset(-46)
            make.width.equalTo(320)
            make.height.equalTo(40)
            make.bottom.equalTo(kakaobutton!.snp.top).offset(-35)
        }
        kakaobutton!.snp.makeConstraints { (make) in
            make.left.equalTo(self.view).offset(46)
            make.right.equalTo(self.view).offset(-46)
            make.width.equalTo(320)
            make.height.equalTo(40)
            make.bottom.equalTo(self.view).offset(-70)
        }
    }
    
    //NaverLogin
    func NaverInfo(){
        
        guard let isValidAccessToken = NaverloginInstance?.isValidAccessTokenExpireTimeNow() else { return }
        
        if !isValidAccessToken {
          return
        }
        
        
        guard let tokenType = NaverloginInstance?.tokenType else { return }
        guard let accessToken = NaverloginInstance?.accessToken else { return }
        let urlStr = "https://openapi.naver.com/v1/nid/me"
        let url = URL(string: urlStr)!
        KeychainToken.save(AppBundle, account: "Naver Token", value:accessToken)
        let authorization = "\(tokenType) \(accessToken)"
        let req = Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization": authorization])
        req.responseJSON { (response) in
            guard let result = response.value as? [String : Any] else  {return}
            guard let object = result["response"] as? [String: Any] else { return }
            guard let name = object["name"] as? String else { return }
            guard let email = object["email"] as? String else { return }
            guard let nickname = object["nickname"] as? String else { return }
            guard let Profile = object["profile_image"] as? String else {return}
            print("Naver Login response 값 입니다 (NaverInfo func): \(object)")
            self.naverUserInfo.NaverUserName = name // Naver 사용자 이름
            self.naverUserInfo.NaverUserProfile = Profile //Naver 사용자 Profile
            self.naverUserInfo.NaverUserId = email // Naver 사용자 email
            UserDefaults.standard.set(self.naverUserInfo.NaverUserName, forKey: "NickName")
            UserDefaults.standard.set(self.naverUserInfo.NaverUserProfile, forKey: "NaverProfile")
        }
        print("네이버 네임\(self.naverUserInfo.NaverUserName)")
        print("네이버 프로필\(self.naverUserInfo.NaverUserProfile)")
        print("네이버 이메일\(self.naverUserInfo.NaverUserId)")
        
    }
    
    private func WIPICK_APP_CHECK_POST(url : String, method : HTTPMethod, paramter : Parameters ,headers : HTTPHeaders, uploadImage : String){
        
        Alamofire.upload( multipartFormData: { (multipartFormData) in
            let UploadData = UIImage(named: uploadImage)
            let data = UploadData?.jpegData(compressionQuality: 1.0)
            for (key, value) in paramter {
                multipartFormData.append((value as! String).data(using: String.Encoding.utf8)!, withName: key)
            }
            if let ImageData = data {
                multipartFormData.append(ImageData, withName: "image", fileName: "image.jpeg", mimeType: "image/jpeg")
            }
            
        }, usingThreshold: UInt64.init(), to: url, method: .post, headers: headers) { (result) in
            switch result{
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    print("Succesfully uploaded")
                    print(response.result.value)
                    if let err = response.error{
                        Error?(err)
                        print("error로그")
                        return
                    }
                }
            case .failure(let error):
                print("Error in upload 로그: \(error.localizedDescription)")
                
                Error?(error)
            }
        }
    }
    
    
    
    func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
        self.NaverInfo()
        var Parameter : Parameters = [
            "provider" : "\(uuid)",
            "WIPICK_ID" : self.naverUserInfo.NaverUserName,
            "profile" : self.naverUserInfo.NaverUserProfile,
            "WIPICK_Email" : self.naverUserInfo.NaverUserId
        ]
        
        //        self.WIPICK_APP_CHECK_POST(url: "http://172.30.1.29:8002/WIPICK_POST_APP_CHECK", method: .post, paramter: Parameter, headers: self.MuliteHeaders, uploadImage: self.naverUserInfo.NaverUserProfile!)
        let RootViewController = UIStoryboard(name: "Main", bundle: nil)
        let MainVC = RootViewController.instantiateViewController(identifier: "RootViewController")
        MainVC.modalPresentationStyle = .fullScreen
        self.present(MainVC, animated: true, completion: nil)
    }
    
    func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
        print("[Success] : Success Naver Login")
        self.NaverInfo()
        print("네이버 네임\(self.naverUserInfo.NaverUserName)")
        print("네이버 프로필\(self.naverUserInfo.NaverUserProfile)")
        print("네이버 이메일\(self.naverUserInfo.NaverUserId)")
        let RootViewController = UIStoryboard(name: "Main", bundle: nil)
        let MainVC = RootViewController.instantiateViewController(identifier: "RootViewController")
        MainVC.modalPresentationStyle = .fullScreen
        self.present(MainVC, animated: true, completion: nil)
        //        self.NaverButton.isHidden = true
        //요기는 토큰 재갱신 할때 사용할 코드 작성
        //다시 naver Info뷰 뜨게 하면됨 메모장 확인
        
        
    }
    
    func oauth20ConnectionDidFinishDeleteToken() {
        NaverloginInstance?.requestDeleteToken()
        
    }
    
    func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
        print("[Error] :", error.localizedDescription)
        print(error)
    }
    
    
    //카카오 토큰 유호시간 알아내는 함수 정의
    func tokenRefreshMillis(token : String){
        KOSessionTask.accessTokenInfoTask { (tokenInfo, error) in
            print("tokeninfo 정보 입니다\(tokenInfo)")
            
            if (token != "" || token != nil) {
                let PassViewController = UIStoryboard(name: "Main", bundle: nil)
                let  MainVC = PassViewController.instantiateViewController(identifier: "RootViewController")
                MainVC.modalPresentationStyle = .fullScreen
                self.present(MainVC, animated: true, completion: nil)
            }
            if let error = error as NSError? {
                switch (error.code) {
                case Int(KOErrorDeactivatedSession.rawValue):
                    print("\(tokenInfo) refreshtoken,accesstoken이 모두 만료되었습니다")
                    break
                default:
                    break
                }
                print("남은 토큰 유효시간 \(tokenInfo?.expiresInMillis)")
            }
        }
    }
    
    
    
    func kakaoLogin(_ sender: Any) {
        //이전 카카오톡 세션 열려있으면 닫기
        guard let session = KOSession.shared() else {
            return
        }
        if session.isOpen() {
            
            print("CookieStroage 쿠키 세션 저장 입니다 \(HTTPCookieStorage.restore())")
            session.close()
        }
        session.open(completionHandler: { (error) -> Void in
            if error == nil {
                if session.isOpen() {
                    //accessToken
                    
                    KOSessionTask.userMeTask { (error, user) in
                        if error != nil {
                            print("사용자 정보 가져오기 error 입니다 LoginViewController를확인하세요 \(String(describing: error?.localizedDescription))")
                        }
                        if let account = user?.account {
                            //키체인으로 사용자 토큰, 이메일을 저장합니다
                            KeychainToken.save(AppBundle, account: "Kakao Token", value:session.token!.accessToken)
                            print("카카오 로그인 사용자 계정입니다\(String(describing: user?.account?.email))")
                            print("카카오 로그인 사용자 토큰 입니다\(String(describing: session.token?.accessToken))")
                        }
                        // Profile Image URL 시큐어 코딩
                        if let Profile = user?.profileImageURL?.absoluteString {
                            //Kakako UserInfoProfile DB Setting
                            //KakaoUserInfoNickName DB Setting
                            //KakaoUserInfoEmail DB Setting
                            if let NickName = user?.nickname {
                                if let UserId = user?.account?.email {
                                    self.kakaoUserInfo.UserProfile = Profile
                                    self.kakaoUserInfo.UserName = NickName
                                    self.kakaoUserInfo.UserId = UserId
                                    self.kakaoUserInfo.UserToken = session.token?.accessToken
                                    //UserDefault로 간단하게 NickName저장 추후 서버 데이터와 비교
                                    UserDefaults.standard.set(self.kakaoUserInfo.UserName, forKey: "NickName")
                                    UserDefaults.standard.set(self.kakaoUserInfo.UserProfile, forKey: "Profile")
                                    
                                    let urlStr = "http://192.168.8.103:8002/v2/user/me"
                                    let url = URL(string: urlStr)!
                                    let authorization = session.token?.accessToken
                                    //요기부분 보기
                                    let req = Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization" : authorization!])
                                    req.responseJSON { (response) in
                                        print("Kakao Login response 값 입니다 (NaverInfo func): \(response.value)")
                                    }
                                    
                                    var Parameter : Parameters = [
                                        "provider" : "\(self.uuid)",
                                        "WIPICK_ID" : self.kakaoUserInfo.UserName,
                                        "profile" : self.kakaoUserInfo.UserProfile,
                                        "WIPICK_Email" : self.kakaoUserInfo.UserId
                                    ]
                                    
                                    self.WIPICK_APP_CHECK_POST(url: "http://172.30.1.55:8002/WIPICK_POST_APP_CHECK", method: .post, paramter: Parameter, headers: self.MuliteHeaders, uploadImage: self.kakaoUserInfo.UserProfile!)
                                    //self.kakaoUserInfo.UserProfile!
                                    
                                }
                            }
                        }
                    }
                    
                    
                    let RootViewController = UIStoryboard(name: "Main", bundle: nil)
                    let MainVC = RootViewController.instantiateViewController(identifier: "RootViewController")
                    MainVC.modalPresentationStyle = .fullScreen
                    self.present(MainVC, animated: true, completion: nil)
                    
                } else {
                    print("Login failed")
                }
            } else {
                print("Login error : \(String(describing: error))")
            }
            if !session.isOpen() {
                if let error = error as NSError? {
                    switch error.code {
                    case Int(KOErrorCancelled.rawValue):
                        break
                    default:
                        //간편 로그인 취소
                        print("error : \(error.description)")
                    }
                }
            }
        })
    }
}





/*
 카카오 세션 유지
 자동 로그인으로 앱이 종료 및 백그라운드에 같다 꺼지는 현상을 막을것인지
 세션을 유지해서 앱의 종료 및 백그라운드 및 꺼지는 현상을 막을 것인지
 자동 로그인은 UserDefaults 를 사용하여 id,email 저장
 세션 유지는 HttpCooikeStroage를 사용하여 세션 유지
 kakao login webview를 사용 해서 Cookie 및 별도 세션 유지 함수 처리 구문 추가
 */


extension HTTPCookieStorage {
    static func clear(){
        
        if let cookies = HTTPCookieStorage.shared.cookies {
            for cookie in cookies {
                HTTPCookieStorage.shared.deleteCookie(cookie)
            }
        }
    }
    static func save(){
        var cookies = [Any]()
        if let newCookies = HTTPCookieStorage.shared.cookies {
            for newCookie in newCookies {
                var cookie = [HTTPCookiePropertyKey : Any]()
                cookie[.name]  =  newCookie.name
                cookie[.value] = newCookie.value
                cookie[.domain] = newCookie.domain
                cookie[.path] = newCookie.path
                cookie[.version] = newCookie.version
                if let date = newCookie.expiresDate {
                    cookie[.expires] = date
                }
                cookies.append(cookie)
            }
            UserDefaults.standard.setValue(cookies, forKey: "cookies")
            UserDefaults.standard.synchronize()
        }
    }
    static func restore(){
        if let cookies = UserDefaults.standard.value(forKey: "cookies") as? [[HTTPCookiePropertyKey : Any]] {
            for cookie in cookies {
                if let oldCookie = HTTPCookie(properties: cookie) {
                    print("cookie loaded:\(oldCookie)")
                    HTTPCookieStorage.shared.setCookie(oldCookie)
                }
            }
        }
    }
}
