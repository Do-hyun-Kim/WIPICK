//
//  ViewController.swift
//  WiPick
//
//  Created by 김도현 on 04/12/2019.
//  Copyright © 2019 김도현. All rights reserved.
//

//if #available(iOS 13.0,*){
//           let window = UIApplication.shared.keyWindow
//           let iPhoneXSafeArea = window?.safeAreaInsets.top
//           if iPhoneXSafeArea != 0 {
//               let DeviceWidth = UIScreen.main.bounds.width
//               let DeviceHeight = UIScreen.main.bounds.height
//               self.MainCollectionView.frame = CGRect(x: 0, y: iPhoneXSafeArea!, width: DeviceWidth, height: DeviceHeight)
//           }
//       }


//CustomFontName : SangSangFlowerRoad
import UIKit
import KakaoOpenSDK



@IBDesignable class WIPCIKSearchBar: UITextField {
    @IBInspectable var borderWidth : CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
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
    @IBInspectable var cornerRadius : CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    @IBInspectable var ShadowOffset : CGSize {
        get {
            return layer.shadowOffset
        }
        set{
            layer.shadowOffset = newValue
        }
    }
    @IBInspectable var shadowPath : CGPath {
        get {
            return layer.shadowPath!
        }
        set{
            layer.shadowPath = newValue
        }
    }
    @IBInspectable var shadowColor : CGColor {
        get {
            return layer.shadowColor!
        }
        set{
            layer.shadowColor = newValue
        }
    }
    
    
}




enum MainCategory : Int {
    case KotilnCategory = 0
    case SwiftCategory = 1
    case C_PlusCategory = 2
    case JavaCategory = 3
    case JavaScriptCategory = 4
    case C_symbolsCategory = 5
    case IonicCategory = 6
    case PythonCategory = 7
}



class ViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITextFieldDelegate,UIScrollViewDelegate{
    
    @IBOutlet weak var WIPICKTITLE: UILabel!
    @IBOutlet weak var PostLabel: UILabel!
    @IBOutlet weak var MainCollectionView: UICollectionView!
    @IBOutlet weak var MainSubCollectionVIew: UICollectionView!
    @IBOutlet weak var GIFIndicator: UIImageView!
    @IBOutlet weak var DeleteBtn: UIButton!
    @IBOutlet weak var MainSearchBar: WIPCIKSearchBar!
    @IBOutlet weak var MainScrollView: UIScrollView!
    public let deivicewidth = UIScreen.main.bounds.width
    public let CategoryImageName : [String] = ["kotlin","swift","c++png","java","js","c#","ionic","python"]
    public let CategoryLabelName : [String] = ["Kotlin","Swift","C++","JAVA","JS","C#","Ionic","Python"]
    private let AppBundle = Bundle.main.bundleIdentifier
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.SetUpMainCollection()
        self.setUpMainSubCollection()
        self.setupLayoutNeed()
        self.MainSerchBarDelegate()
        let accesToken = KeychainToken.load(AppBundle, account: "Kakao Token")
        print("accessToken KeyCahin Test = \(accesToken)")
//        CategorySearchBar.inputView = UIView()
//        CategorySearchBar.tintColor = UIColor.clear
//        CategorySearchBar.addTarget(self, action: #selector(self.PresnetSearch), for: .allTouchEvents)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.navigationItem.title = "WIPICK"
        let RightProfileButton = UIBarButtonItem(customView: ProfileImageButton)
        self.tabBarController?.navigationItem.rightBarButtonItem = RightProfileButton
        
        
    }
    
    //LeftNotificationLeft Button
    
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
           
           
           
           return ProfileLigthButton
       }()
    
    
    
    //전역으로 생성해야함
//    public lazy var CategorySearchBar : UITextField = {
//        let SearchView = UITextField()
//        SearchView.frame = CGRect(x: 10, y: 280, width: 350, height: 44)
//        SearchView.delegate = self
//        SearchView.layer.borderWidth = 1.0
//        SearchView.layer.borderColor = UIColor.lightGray.cgColor
//        SearchView.layer.cornerRadius = 5.0
//        let centeredParagraphStyle = NSMutableParagraphStyle()
//        centeredParagraphStyle.alignment = .center
//        let attributes = [
//            NSAttributedString.Key.foregroundColor: UIColor.lightGray,
//            NSAttributedString.Key.font : UIFont(name: "SangSangFlowerRoad", size: 16)!, // Note the !
//            NSAttributedString.Key.paragraphStyle : centeredParagraphStyle
//        ]
//        SearchView.attributedPlaceholder = NSAttributedString(string: "검색 키워드를 입력하세요", attributes:attributes)
//        let SearchViewIcon = UIImageView(frame: CGRect(x: 10, y: 5, width: 20, height: 20))
//        let SearchImage = UIImage(named: "Search.png")
//        SearchViewIcon.image = SearchImage
//        let SearchIconContainer : UIView = UIView(frame: CGRect(x: 20, y: 0, width: 30, height: 30))
//        SearchIconContainer.addSubview(SearchViewIcon)
//        SearchView.leftView = SearchIconContainer
//        SearchView.leftViewMode = .always
//        SearchView.tintColor = .lightGray
//
//        return SearchView
//    }()
//
//    @objc func PresnetSearch(textfield: UITextField){
//        let SearchViewController = self.storyboard?.instantiateViewController(identifier: "SearchView")
//        self.present(SearchViewController!, animated: true, completion: nil)
//    }
    
    
    
    
    func SetUpMainCollection(){
          let flowlayout = UICollectionViewFlowLayout()
          flowlayout.minimumLineSpacing = 0
          flowlayout.minimumInteritemSpacing = 0
//          MainCollectionView.addSubview(CategorySearchBar)
          MainCollectionView.delegate = self
          MainCollectionView.dataSource = self
          MainCollectionView.isPagingEnabled = false
          MainCollectionView.isScrollEnabled = false
          MainCollectionView.register(UINib(nibName: "MainCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MainCell")
//          MainCollectionView.layer.borderColor = UIColor.lightGray.cgColor
//          MainCollectionView.layer.borderWidth = 0.5
          MainCollectionView.layer.cornerRadius = 4.0
          MainCollectionView.setCollectionViewLayout(flowlayout, animated: true)

      }
    func setUpMainSubCollection(){
        let SubflowLayout = UICollectionViewFlowLayout()
//        SubflowLayout.minimumInteritemSpacing = 0
//        SubflowLayout.minimumLineSpacing = 0
        SubflowLayout.scrollDirection = .horizontal
        
        MainSubCollectionVIew.delegate = self
        MainSubCollectionVIew.dataSource = self
        MainSubCollectionVIew.isPagingEnabled = false
        MainSubCollectionVIew.isScrollEnabled = true
        MainSubCollectionVIew.register(UINib(nibName: "MainSubCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MainSUB")
        MainSubCollectionVIew.backgroundColor = .white
        MainSubCollectionVIew.setCollectionViewLayout(SubflowLayout, animated: true)
        
        MainSubCollectionVIew.frame = CGRect(x: self.MainSubCollectionVIew.frame.origin.x, y: MainSubCollectionVIew.frame.origin.y, width: deivicewidth, height: MainSubCollectionVIew.frame.size.height)
        
        
        
    }
    private func MainSerchBarDelegate(){
        let padding: CGFloat = 8
        let MainSearchbarouterView = UIView(frame: CGRect(x: 0, y: 0, width: padding * 2 + 23, height: 23))
        let MainSearchbarIcon = UIImageView()
        MainSearchbarIcon.frame = CGRect(x: padding, y: 0, width: 20, height: 20)
        MainSearchbarIcon.image = UIImage(named: "Search.png")?.resizeImage(size: CGSize(width: 15, height: 15)).withRenderingMode(.alwaysOriginal)
        MainSearchbarouterView.addSubview(MainSearchbarIcon)
        self.MainSearchBar.leftViewMode = .always
        self.MainSearchBar.leftView = MainSearchbarouterView
        self.MainSearchBar.backgroundColor = UIColor.white
        self.MainSearchBar.layer.borderColor = UIColor.clear.cgColor
        self.MainSearchBar.textAlignment = .center
        self.MainSearchBar.attributedPlaceholder = NSAttributedString(string: "검색어를 입력하세요",
                                                                      attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        self.MainSearchBar.cornerRadius = 10
        self.MainSearchBar.shadowColor = UIColor.black.cgColor
        self.MainSearchBar.ShadowOffset = CGSize(width: 0, height: 8)
        self.MainSearchBar.layer.shadowRadius = 5
        self.MainSearchBar.layer.shadowOpacity = 0.1
        self.MainSearchBar.layer.masksToBounds = false

    }
    
    
    
    func setupLayoutNeed(){
        let RightProfileButton = UIBarButtonItem(customView: ProfileImageButton)
        self.tabBarController?.navigationItem.rightBarButtonItem = RightProfileButton
        self.MainScrollView.delegate = self
        let DeivceWidth = UIScreen.main.bounds.size.width
        self.MainScrollView.contentSize = CGSize(width: DeivceWidth, height: 1000)
        self.PostLabel.text = "이달의 HOT게시물"
        self.PostLabel.font = UIFont.systemFont(ofSize: 17)
        let PostAttributeString = NSMutableAttributedString(string: self.PostLabel.text!)
        PostAttributeString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black, range: (self.PostLabel.text as! NSString).range(of: "HOT"))
        self.PostLabel.attributedText = PostAttributeString
        self.tabBarController?.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "CookieRunOTF-Bold", size: 18)!]
        self.tabBarController?.navigationItem.title = "WIPICK"
        self.tabBarController?.tabBar.tintColor = .black
        self.WIPICKTITLE.text = "WIPICK과 함께 개발언어의 \n새로운 소식을 접해보세요!"
        self.WIPICKTITLE.font = UIFont.systemFont(ofSize: 24)
        self.WIPICKTITLE.numberOfLines = 2
        self.WIPICKTITLE.textAlignment = .left
        self.WIPICKTITLE.frame = CGRect(x: self.WIPICKTITLE.frame.origin.x, y: self.WIPICKTITLE.frame.origin.y, width: 300, height: 150)
        
        let titleAttribute = NSMutableAttributedString(string: self.WIPICKTITLE.text!)
        titleAttribute.addAttribute(NSAttributedString.Key.font, value: UIFont.init(name: "CookieRunOTF-Bold", size: 24), range: (self.WIPICKTITLE.text as! NSString).range(of: "WIPICK"))
        titleAttribute.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(red: 255/255, green: 101/255, blue: 83/255, alpha: 1.0), range: (self.WIPICKTITLE.text as! NSString).range(of: "WIPICK"))
               
        
        
        
        self.WIPICKTITLE.attributedText = titleAttribute
        
        //navigationcotroller background claer
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == MainCollectionView {
            return CategoryImageName.count
        }else {
            return 8
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == MainCollectionView {
            let Maincell = MainCollectionView.dequeueReusableCell(withReuseIdentifier: "MainCell", for: indexPath) as? MainCollectionViewCell
            Maincell?.Category_Img.image = UIImage(named: CategoryImageName[indexPath.row])
            Maincell?.Category_Label.text = CategoryLabelName[indexPath.row]
            Maincell?.Category_Label.textColor = .black
            Maincell?.Category_Label.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
            Maincell?.Category_Label.textAlignment = .center
            Maincell?.layer.borderColor = UIColor.clear.cgColor
           
          
            return Maincell!
        }else{
            let MainSubCell = MainSubCollectionVIew.dequeueReusableCell(withReuseIdentifier: "MainSUB", for: indexPath) as? MainSubCollectionViewCell
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
            //Cell ContentBackView Layer
            MainSubCell?.ContentBackView.frame = CGRect(x: MainSubCell!.frame.origin.x, y: MainSubCell!.frame.origin.y, width: MainSubCell!.frame.size.width, height: MainSubCell!.frame.size.height)

            //Cell Layer Shadow
//            MainSubCell?.layer.shadowOpacity = 0.18
//            MainSubCell?.layer.shadowOffset = CGSize(width: 0, height: 2)
//            MainSubCell?.layer.shadowRadius = 2
//            MainSubCell?.layer.shadowColor = UIColor.black.cgColor
//            MainSubCell?.layer.masksToBounds = false
            return MainSubCell!
        }
    
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == MainCollectionView {
            return CGSize(width: MainCollectionView.frame.size.width/4, height: 100)
        }else{
            return CGSize(width: 300, height: 230)
        }
        
       
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == MainCollectionView {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }else{
            return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        }
        
    }
      func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == MainCollectionView {
            return 0
        }else {
            return 0
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        if let MainCell = collectionView.cellForItem(at: indexPath) as? MainCollectionViewCell {
            switch indexPath.row {
            case MainCategory.KotilnCategory.rawValue:
                self.performSegue(withIdentifier: "CategorySegue", sender: "Kotlin")
            case MainCategory.SwiftCategory.rawValue:
                self.performSegue(withIdentifier: "CategorySegue", sender: "Swift")
            case MainCategory.C_PlusCategory.rawValue:
                self.performSegue(withIdentifier: "CategorySegue", sender: "C++")
            case MainCategory.JavaCategory.rawValue:
                self.performSegue(withIdentifier: "CategorySegue", sender: "Java")
            case MainCategory.JavaScriptCategory.rawValue:
                self.performSegue(withIdentifier: "CategorySegue", sender: "JS")
            case MainCategory.C_symbolsCategory.rawValue :
                self.performSegue(withIdentifier: "CategorySegue", sender: "C#")
            case MainCategory.IonicCategory.rawValue :
                self.performSegue(withIdentifier: "CategorySegue", sender: "Ionic")
            case MainCategory.PythonCategory.rawValue :
                self.performSegue(withIdentifier: "CategorySegue", sender: "Python")
            default:
                break
            }
        }else if let MainSubCell = collectionView.cellForItem(at: indexPath) as? MainSubCollectionViewCell{
            
        }
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination
        guard let CategoryVC = destination as? CategoryViewController else { return  }
        
        CategoryVC.navigationItem.title = sender as! String
    }
    func WIPCIK_MAIN_CATEGORY(){
        //CategorySegue :  PostViewController Data전달 세그
        
        
    }
    
    
    
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        if textField ==  CategorySearchBar{
//            let SearchViewController = self.storyboard?.instantiateViewController(identifier: "SearchView")
//            let navigaitionView = UINavigationController(rootViewController: SearchViewController!)
//            navigaitionView.modalPresentationStyle = .fullScreen
//            self.present(navigaitionView, animated: true, completion: nil)
//        }
//    }
    
   
}


