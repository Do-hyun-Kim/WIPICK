//
//  WIPICKAlert.swift
//  WiPick
//
//  Created by 김도현 on 13/02/2020.
//  Copyright © 2020 김도현. All rights reserved.
//

import UIKit


@IBDesignable class WIPCIKAlerView : UIView {
    @IBInspectable var cornerRadius : CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    @IBInspectable var shadowOffset : CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    @IBInspectable var shadowRadius : CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
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
        set {
            layer.shadowColor = newValue
        }
    }
    @IBInspectable var borderWidth : CGFloat {
        get {
            return layer.borderWidth
        }
        set{
            layer.borderWidth = newValue
        }
    }
    @IBInspectable var boderColor : CGColor {
        get {
            return layer.borderColor!
        }
        set {
            layer.borderColor = newValue
        }
    }
}






class WIPICKAlert: UIView {
    @IBOutlet weak var WIPICKAlertText: UILabel!
    @IBOutlet weak var ViewLine: UIView!
    @IBOutlet weak var AlertOKButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func AlertLayout(){
        self.WIPICKAlertText.text = "링크 추가"
        self.ViewLine.backgroundColor = UIColor.lightGray
        self.ViewLine.frame = CGRect(x: self.ViewLine.frame.origin.x, y: self.ViewLine.frame.origin.y, width: self.ViewLine.frame.size.width, height: self.ViewLine.frame.size.height)
    }
    
    
}
