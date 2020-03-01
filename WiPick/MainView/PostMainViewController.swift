//
//  PostMainViewController.swift
//  WiPick
//
//  Created by 김도현 on 05/02/2020.
//  Copyright © 2020 김도현. All rights reserved.
//

import UIKit
import Alamofire
import SnapKit

struct Mainconfigure {
    var WiPICK_TITLE : [String?] = []
    var WIPICK_CONTENT : [String?] = []
    var WIPICK_IMG : [String?] = []
    var WIPICK_PROFILEIMG : [String?] = []
    var WIPICK_NICKNAME : [String?] = []
    var WIPICK_PROVIDER : String? = ""
}



//Custom Main_NickName With Main_Profile

class WIPICKImageView : UIImageView {
    @IBInspectable var borderWidth : CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    @IBInspectable var cornerLadius : CGFloat {
        get {
            return layer.cornerRadius
        }
        set{
            layer.cornerRadius = newValue
        }
    }
    @IBInspectable var borderColor : CGColor {
        get {
            return layer.borderColor!
        }
        set {
            layer.borderColor = newValue
        }
    }
    
}


class WIPCIKLabel : UILabel {
    @IBInspectable var borderWidth : CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
}







class PostMainViewController: UIViewController,UITextViewDelegate{
    
    @IBOutlet weak var Main_ScrollView: UIScrollView!
    @IBOutlet weak var Main_Category : UILabel?
    @IBOutlet weak var Main_ContentText: UITextView?
    @IBOutlet weak var Main_ContentTitle: UILabel?
    @IBOutlet weak var Main_ContentIMG: UIImageView!
    @IBOutlet weak var Main_ViewLine: UIView!
    @IBOutlet weak var MAIN_Nickname: UILabel?
    @IBOutlet weak var MAIN_Profile: UIImageView!
    @IBOutlet weak var Main_LineView: UIView!
    
    var PostMainName : String?
    var PostMainProfile : UIImage?
    var PostMainContent : String?
    var PostMainContentImage : UIImage?
    var PostMainTitle : String?
    var PostMainCategory : String?
    var PostMainID : Int?
    var headers: HTTPHeaders = ["Content-Type": "application/x-www-form-urlencoded"]
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setLayout()
        self.MAIN_Nickname?.text = self.PostMainName
        self.MAIN_Profile.image = self.PostMainProfile
        self.Main_ContentIMG.image = self.PostMainContentImage
        self.Main_Category?.text = self.PostMainCategory
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = UIImage(named: "NaviBackbutton.png")
//        self.HyperLinkUpdate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.MAIN_Nickname?.text = self.PostMainName
        self.MAIN_Profile.image = self.PostMainProfile
        self.Main_ContentIMG.image = self.PostMainContentImage
        self.Main_ContentTitle?.text = self.PostMainTitle
        self.Main_ContentText?.text = self.PostMainContent
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = UIImage(named: "NaviBackbutton.png")
    }
   

    
    
    private func setLayout(){
        var deviceSizeWidth = UIScreen.main.bounds.width
        self.Main_LineView.backgroundColor = UIColor.lightGray
        self.Main_LineView.frame = CGRect(x: self.Main_LineView.frame.origin.x, y: self.Main_LineView.frame.origin.y, width: deviceSizeWidth, height: 1)
//        NinameDegine
        self.MAIN_Nickname!.textColor = UIColor.black
        self.MAIN_Nickname?.font = UIFont.boldSystemFont(ofSize: 15)
        
        //ProfileDegine
        self.MAIN_Profile.layer.borderColor = UIColor.lightGray.cgColor
        self.MAIN_Profile.layer.cornerRadius = self.MAIN_Profile.frame.size.height / 2
        self.MAIN_Profile.layer.borderWidth = 0.5
        
        //CategoryDegine
        self.Main_Category?.textColor = UIColor.lightGray
        self.Main_Category?.font = UIFont.systemFont(ofSize: 13)
        
        //MainTitleDegine
        self.Main_ContentTitle?.font = UIFont.boldSystemFont(ofSize: 20)
        self.Main_ContentTitle?.textColor = UIColor.black
        
        //MainTextView
        self.Main_ContentText?.isEditable = false
        self.Main_ContentText?.delegate = self
        self.Main_ContentText?.isSelectable = true
        self.Main_ContentText?.dataDetectorTypes = .link
        
        guard let CommentID = self.PostMainID else { return }
        guard let CommentNickName = self.PostMainName else { return }
        guard let CommentProfile = self.PostMainProfile else { return }
        let parameters : Parameters = [
        "postID" : "\(CommentID)",
        "writer" : CommentNickName,
        "content" : "어디서 산거애요",
        "writerProfile" : "\(CommentProfile)",
        ]
        WIPICK_COMMENT_POST(url: "http://172.30.1.10:8002/WIPICK_COMMENT_POST/\(CommentID)" , method: .post, paramter: parameters, headers: headers)
        
    }
    
//    func HyperLinkUpdate(){
//        let path = "https://www.naver.com"
//        let text = self.Main_ContentText?.text ?? ""
//        let attributeString = NSAttributedString.HyperLinkeText(for: path, in: text, as: "https://www.naver.com")
//        self.Main_ContentText?.attributedText = attributeString
//
//    }
    
    
    
    
    
     func WIPICK_COMMENT_POST(url : String, method : HTTPMethod, paramter : Parameters ,headers : HTTPHeaders){
        Alamofire.request(url, method: method, encoding: URLEncoding(), headers: headers).responseJSON { (response) in
            
                print(response.result.value)
            }
        }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        let urlstring = URL.absoluteURL
        
        return true
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    
}


extension NSAttributedString {
    
    static func HyperLinkeText(for path : String, in string : String, as substring : String) -> NSAttributedString {
        let attributeString = NSString(string: string)
        let substringRange = attributeString.range(of: substring)
        let HyperLinkString = NSMutableAttributedString(string: string)
        HyperLinkString.addAttribute(.link, value: path, range: substringRange)
        return HyperLinkString
    }
}
