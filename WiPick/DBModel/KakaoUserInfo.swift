//
//  KakaoUserInfo.swift
//  WiPick
//
//  Created by 김도현 on 21/12/2019.
//  Copyright © 2019 김도현. All rights reserved.
//

import UIKit
import KakaoOpenSDK


//class KakaoUserInfo: Object {
//   @objc dynamic var UserProfile : String = ""
//   @objc dynamic var UserName : String = ""
//   @objc dynamic var UserId : String = ""
//
//
//    func KakaoUserInfoDb() {
//        KOSessionTask.userMeTask { (error, UserInfoProfile) in
//            if(error != nil){
//                print("error Kakao UserInfoDB 설정이 잘못되었습니다 LoginViewController 확인 하세요 \(error?.localizedDescription)")
//            }else{
//                if let Profile = UserInfoProfile?.profileImageURL?.absoluteString {
//                    //Kakako UserInfoProfile DB Setting
//                    self.UserProfile = Profile
//                    try? self.realm?.write {
//                        self.realm?.add(self)
//                        let documentsDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
//
//                        print(documentsDirectory)
//                    }
//                    //DB확인
//                }
//            }
//        }
//    }
//
//}
