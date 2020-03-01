//
//  Utils.swift
//  WiPick
//
//  Created by 김도현 on 08/12/2019.
//  Copyright © 2019 김도현. All rights reserved.
//

import UIKit
import KakaoOpenSDK
import Security




class TokenUtils {
    
    private let AppID = Bundle.main.object(forInfoDictionaryKey: "AppIdentifierPrefix")
    private let AppBundle = Bundle.main.bundleIdentifier
    
    //키체인에 값 저장하는 함수
    func save(_ servie : String?, account : String?, value : String) {
        let keychainQuery : NSDictionary = [
            //정리
            //service : 카카오 토큰값을 키체인
            //account : 사용자 이메일을 키체인
            kSecClass : kSecClassGenericPassword,
            kSecAttrService : servie,
            kSecAttrAccount : account,
            kSecValueData : value.data(using: .utf8, allowLossyConversion: false)!
        ]
        
        //현재 저장되어 있는 값 삭제
        SecItemDelete(keychainQuery)
        // 새로운 키 체인 아이템 등록
        let status : OSStatus = SecItemAdd(keychainQuery, nil)
        assert(status == noErr, "카카오 토큰값 저장에 실패 했습니다")
        print("status = \(status)")
    }
    //키체인에 저장된 값 읽어오는 함수
    func load(_ service : String?, account : String?) -> String? {
        //키체인 쿼리 정의
        //service : 카카오 토큰값을 키체인
        //account : 사용자 이메일을 키체인
        let keyChainQuery : NSDictionary = [
            kSecClass : kSecClassGenericPassword,
            kSecAttrService : service,
            kSecAttrAccount : account,
            kSecReturnData : kCFBooleanTrue,
            kSecMatchLimit : kSecMatchLimitOne
        ]
        var dataTypeRef : AnyObject?
        let status = SecItemCopyMatching(keyChainQuery, &dataTypeRef)
        //처리 결과 성공라면 읽어온 값을 Data 타입으로 반환하고 , 다시 string 타입으로 반환
        if(status == errSecSuccess){
            let retrievedData = dataTypeRef as! Data
            let value = String(data: retrievedData, encoding: String.Encoding.utf8)
            return value
        }else{
            print("keychain 실패 입니다 Util 부분 확인 하십시요\(status)")
            return nil
        }
    }
    
    //키체인에 있는 값 삭제하는 함수 
    func delete(_ service : String, account : String) {
        let keychainQuerey : NSDictionary = [
            kSecClass : kSecClassGenericPassword,
            kSecAttrService : service,
            kSecAttrAccount : account
        ]
        let status = SecItemDelete(keychainQuerey)
        assert(status == noErr, "토큰 값 삭제에 실패했습니다")
        print("토큰값 삭제에 실패 하였습니다 \(status)")
    }
}
