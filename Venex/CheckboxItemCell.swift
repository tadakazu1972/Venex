//
//  CheckboxItemCell.swift
//  Venex
//
//  Created by 中道忠和 on 2017/09/18.
//  Copyright © 2017年 tadakazu nakamichi. All rights reserved.
//

import UIKit

class CheckboxItemCell: UITableViewCell, UITextViewDelegate {
    var checkbox: UIButton?
    var name : UILabel?
    var num  : UITextView?
    
    required init(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)!
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        checkbox = UIButton(frame: CGRect(x: 0, y: 0, width: 28, height: 40))
        checkbox?.tintColor = UIColor.red
        checkbox?.setImage(UIImage(named: "ic_check_box.png"), for: UIControlState.selected)
        checkbox?.setImage(UIImage(named: "ic_check_box_outline_blank.png"), for: UIControlState())
        self.contentView.addSubview(checkbox!)
        
        name = UILabel(frame: CGRect(x: 32, y: 0, width: 240, height: 40))
        name?.text = "nil"
        name?.font = UIFont.systemFont(ofSize: 20)
        self.addSubview(name!)
        
        num = UITextView(frame: CGRect(x: 230, y: 0, width: 40, height: 40))
        num?.text = "nil"
        num?.font = UIFont.systemFont(ofSize: 18)
        num?.isUserInteractionEnabled = true
        num?.isScrollEnabled = false
        num?.isEditable = false
        num?.isSelectable = true
        num?.delegate = self
        self.contentView.addSubview(num!)
    }
}
