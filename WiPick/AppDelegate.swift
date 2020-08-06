//
//  AppDelegate.swift
//  WiPick
//
//  Created by 김도현 on 04/12/2019.
//  Copyright © 2019 김도현. All rights reserved.
//

import UIKit
import KakaoOpenSDK
import NaverThirdPartyLogin

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, open url : URL, sourceApplication : String?, annotation : Any) -> Bool{
        
        
        
        
        guard let scheme = url.scheme else {
            return true
        }
        if KOSession.handleOpen(url.absoluteURL) {
            return KOSession.handleOpen(url)
        }
        
        return true
    }
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        guard let scheme = url.scheme else {
            return true
        }
        
        if KOSession.handleOpen(url.absoluteURL) {
            return KOSession.handleOpen(url)
        }
        NaverThirdPartyLoginConnection.getSharedInstance()?.application(app, open: url, options: options)
        
          return true
    }
//    @objc func dismissSplashViewController(){
//        let mainVC = UIStoryboard.init(name: "Main", bundle: nil)
//        let rootVC = mainVC.instantiateViewController(identifier: "LoginViewController")
//        self.window?.rootViewController = rootVC
//        self.window?.makeKeyAndVisible()
//    }
//    private func splashScreen(){
//        window = UIWindow(frame: UIScreen.main.bounds)
//        let lanuchScreenVC = UIStoryboard.init(name: "LaunchScreen", bundle: nil)
//        let RootVC = lanuchScreenVC.instantiateViewController(identifier: "SplashViewController")
//        self.window?.rootViewController = RootVC
//        self.window?.makeKeyAndVisible()
//
//        Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(dismissSplashViewController), userInfo: nil, repeats: false)
//    }

    //Kakao Token 주기적 갱신
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //NaverLogin
    
        
        let instance = NaverThirdPartyLoginConnection.getSharedInstance()
        
        instance?.isNaverAppOauthEnable = true
        instance?.isInAppOauthEnable = true
        instance?.isOnlyPortraitSupportedInIphone()
        instance?.serviceUrlScheme = kServiceAppUrlScheme
        instance?.consumerKey = kConsumerKey
        instance?.consumerSecret = kConsumerSecret
        instance?.appName = kServiceAppName
        
        
        KOSession.shared()?.isAutomaticPeriodicRefresh = true
        
//        self.splashScreen()
        return true
    }
    func applicationDidEnterBackground(_ application: UIApplication) {
        KOSession.handleDidEnterBackground()
    }
    

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    func applicationDidBecomeActive(_ application: UIApplication) {
        KOSession.handleDidBecomeActive()
    }


}

