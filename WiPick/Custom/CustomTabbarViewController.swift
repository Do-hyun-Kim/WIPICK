//
//  CustomTabbarViewController.swift
//  WiPick
//
//  Created by 김도현 on 19/12/2019.
//  Copyright © 2019 김도현. All rights reserved.
//

import UIKit


class CustomTabbarViewController: UITabBarController {
    
    
    
    lazy var ProfileImageButton : UIButton = {
        let ProfileLigthButton = UIButton(type: .custom)
            let Profile = UserDefaults.standard.string(forKey: "Profile")
            if let ProfileURL = Profile {
                let BinderUrl : URL = URL(string: ProfileURL)!
                let ProfileData : Data = try! Data(contentsOf: BinderUrl)
                ProfileLigthButton.setImage(UIImage(data: ProfileData)?.resizeImage(size: CGSize(width: 40, height: 40)).withRenderingMode(.alwaysOriginal), for: .normal)
            }
        ProfileLigthButton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        ProfileLigthButton.layer.masksToBounds = false
        ProfileLigthButton.clipsToBounds = true
        ProfileLigthButton.layer.cornerRadius = ProfileLigthButton.frame.size.height / 2
        ProfileLigthButton.layer.borderWidth = 0.1
        ProfileLigthButton.layer.borderColor = UIColor.lightGray.cgColor
        ProfileLigthButton.addTarget(self, action: #selector(NavigationAction(sender:)), for: .touchUpInside)
        
        
        
        return ProfileLigthButton
    }()
    
    @objc func NavigationAction(sender : UIButton){
        let PostDetailViewController = UIStoryboard(name: "Main", bundle: nil)
        let PostVC = PostDetailViewController.instantiateViewController(identifier: "PostDetailSB")
        PostVC.modalPresentationStyle = .fullScreen
        self.present(PostVC, animated: true, completion: nil)
        
    }
    
    
    //화면 재시작시 profile이미지 안바뀜 LifeCycle때문인듯 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let RightProfileButton = UIBarButtonItem(customView: ProfileImageButton)
        self.navigationItem.rightBarButtonItem = RightProfileButton
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTabbarLayout()
        let RightProfileButton = UIBarButtonItem(customView: ProfileImageButton)
        self.navigationItem.rightBarButtonItem = RightProfileButton
    }
    func setUpTabbarLayout(){
        UITabBar.clearShadow()
        tabBar.layer.applyShadow(color: .gray, alpha: 0.3, x: 0, y: 0, blur: 12)
    }
}

extension CALayer {
    func applyShadow(
            color: UIColor = .black,
            alpha: Float = 0.5,
            x: CGFloat = 0,
            y: CGFloat = 2,
            blur: CGFloat = 4
        ) {
            shadowColor = color.cgColor
            shadowOpacity = alpha
            shadowOffset = CGSize(width: x, height: y)
            shadowRadius = blur / 2.0
        }
}

extension UITabBar {
    static func clearShadow() {
            UITabBar.appearance().shadowImage = UIImage()
            UITabBar.appearance().backgroundImage = UIImage()
            UITabBar.appearance().backgroundColor = UIColor.white
        }
}

extension UIImage {
  func resizeImage(size: CGSize) -> UIImage {
    let originalSize = self.size
    let ratio: CGFloat = {
        return originalSize.width > originalSize.height ? 1 / (size.width / originalSize.width) :
                                                          1 / (size.height / originalSize.height)
    }()

    return UIImage(cgImage: self.cgImage!, scale: self.scale * ratio, orientation: self.imageOrientation)
  }
}
