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
import SwiftyJSON

struct Mainconfigure {
    var WiPICK_TITLE : [String?] = []
    var WIPICK_CONTENT : [String?] = []
    var WIPICK_IMG : [String?] = []
    var WIPICK_PROFILEIMG : [String?] = []
    var WIPICK_NICKNAME : [String?] = []
    var WIPICK_PROVIDER : String? = ""
}

struct MainCommentconfigure {
    var WiPICK_CONTENT : [String] = []
    var WiPICK_POSTID : [String] = []
    var WiPICK_WRITER : [String] = []
    var WiPICK_WRITERProfile : [String] = []
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







class PostMainViewController: UIViewController,UITextViewDelegate,UITableViewDelegate,UITableViewDataSource{
    
    
    @IBOutlet weak var Main_ScrollView: UIScrollView!
    @IBOutlet weak var Main_Category : UILabel?
    @IBOutlet weak var Main_ContentText: UITextView?
    @IBOutlet weak var Main_ContentTitle: UILabel?
    @IBOutlet weak var Main_ContentIMG: UIImageView!
    @IBOutlet weak var Main_ViewLine: UIView!
    @IBOutlet weak var MAIN_Nickname: UILabel?
    @IBOutlet weak var MAIN_Profile: UIImageView!
    @IBOutlet weak var Main_LineView: UIView!
    @IBOutlet weak var Main_CommentView: UITableView!
    
    var PostMainName : String?
    var PostMainProfile : UIImage?
    var PostMainContent : String?
    var PostMainContentImage : UIImage?
    var PostMainTitle : String?
    var PostMainCategory : String?
    var PostMainID : Int?
    var Postheaders: HTTPHeaders = ["Content-Type": "application/x-www-form-urlencoded"]
    var GetHeaders : HTTPHeaders = ["Accept" : "application/json;charset:utf-8"]
    private var CommentCofigure = MainCommentconfigure()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setLayout()
        self.MAIN_Nickname?.text = self.PostMainName
        self.MAIN_Profile.image = self.PostMainProfile
        self.Main_ContentIMG.image = self.PostMainContentImage
        self.Main_Category?.text = self.PostMainCategory
        self.Main_CommentView.register(UINib(nibName: "CommentTableViewCell", bundle: nil), forCellReuseIdentifier: "CommentCell")
        self.Main_CommentView.estimatedRowHeight = 350
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
        
        //MainCommentView
        self.Main_CommentView.separatorStyle = .none
        self.Main_CommentView.delegate = self
        self.Main_CommentView.dataSource = self

        
        
        guard let CommentID = self.PostMainID else { return }
        guard let CommentNickName = self.PostMainName else { return }
        guard let CommentProfile = UserDefaults.standard.string(forKey: "Profile") else { return  }
        let parameters : Parameters = [
            "postID" : "\(CommentID)",
            "writer" : CommentNickName,
            "content" : "어디서 산거애요",
            "writerProfile" : "\(CommentProfile)", //UserDefault Profile로 Post하고 Get
        ]
        
        
//        self.WIPICK_COMMENT_POST(url: "http://172.30.1.5:8002/WIPICK_COMMENT_POST/\(CommentID)" , method: .post, paramter: parameters, headers: Postheaders)

        
        self.WIPICK_COMMENT_GET(url: "http://172.30.1.55:8002/WIPICK_COMMENT_GET/\(CommentID)", method: .get, headers: GetHeaders)
    }
    
    
    private func WIPICK_COMMENT_GET(url : String, method : HTTPMethod, headers : HTTPHeaders){
        Alamofire.request(url, method: method, encoding: JSONEncoding.prettyPrinted, headers: headers).responseJSON { (response) in
            switch (response.result) {
            case .success:
                if let data = response.result.value {
                    let json = JSON(data)
                    for (key,subjson):(String,JSON) in json["content"] {
                        self.CommentCofigure.WiPICK_CONTENT.append(subjson["content"].stringValue)
                        self.CommentCofigure.WiPICK_POSTID.append(subjson["postId"].stringValue)
                        self.CommentCofigure.WiPICK_WRITER.append(subjson["writer"].stringValue)
                        self.CommentCofigure.WiPICK_WRITERProfile.append(subjson["writerProfile"].stringValue)
                    }
                }
                DispatchQueue.main.async {
                    self.Main_CommentView.reloadData()
                }
                print("WIPICK Comment GET 성공\(response.result.value)")
                break
            case .failure(let error):
                print("WIPICK Comment GET 실패\(error.localizedDescription)")
                break
            }
        }
    }
    
    
    
     func WIPICK_COMMENT_POST(url : String, method : HTTPMethod, paramter : Parameters ,headers : HTTPHeaders){
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForResource = 10
        manager.session.configuration.timeoutIntervalForRequest = 5
        manager.request(url, method: .post, parameters: paramter, headers: headers).responseJSON { response in
            
            
            switch (response.result) {
            case .success:
                print("WIPICK Comment POST 성공")
                break
            case .failure(let error):
                print("WIPICK Comment POST 실패 \(error.localizedDescription)")
                break
            }
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.CommentCofigure.WiPICK_WRITER.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let CommentCell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as? CommentTableViewCell
        CommentCell?.Comment_Writer.text = self.CommentCofigure.WiPICK_WRITER[indexPath.row]
        
        CommentCell?.Comment_Content.text = self.CommentCofigure.WiPICK_CONTENT[indexPath.row]
        
        if self.CommentCofigure.WiPICK_WRITERProfile[indexPath.row] == "" {
            CommentCell?.Comment_Profile.image = UIImage(named: "profile.png")
        }else if self.CommentCofigure.WiPICK_WRITERProfile[indexPath.row].isValidURL() == true{
            let CommentProfileUrl : URL? = URL(string: self.CommentCofigure.WiPICK_WRITERProfile[indexPath.row])
            if let CommentBinding = CommentProfileUrl {
                let CommentData : Data = try! Data(contentsOf: CommentBinding)
                CommentCell?.Comment_Profile.image = UIImage(data: CommentData)
                CommentCell?.Comment_Profile.contentMode = .scaleToFill
            }
            
        }
        
        
        return CommentCell!
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
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
