//
//  CustomTabbarViewController.swift
//  WiPick
//
//  Created by 김도현 on 19/12/2019.
//  Copyright © 2019 김도현. All rights reserved.
//

import UIKit


class CustomTabbarViewController: UITabBarController {
    
    
    
    
//    @objc func NavigationAction(sender : UIButton){
//        let PostDetailViewController = UIStoryboard(name: "Main", bundle: nil)
//        let PostVC = PostDetailViewController.instantiateViewController(identifier: "PostDetailSB")
//        PostVC.modalPresentationStyle = .fullScreen
//        self.present(PostVC, animated: true, completion: nil)
//
//    }
    
    
    //화면 재시작시 profile이미지 안바뀜 LifeCycle때문인듯 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
       

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTabbarLayout()
        
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
