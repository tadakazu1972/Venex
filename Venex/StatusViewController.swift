//
//  StatusViewController.swift
//  Venex
//
//  Created by 中道忠和 on 2020/07/25.
//  Copyright © 2020 tadakazu nakamichi. All rights reserved.
//

import UIKit

class StatusViewController: UIViewController {
    //ボタン設定
    let btnBack = UIButton(frame: CGRect.zero)
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red:0.8, green:0.8, blue:0.7, alpha:1.0)
        
        //戻るボタン
        btnBack.backgroundColor = UIColor.gray
        btnBack.layer.masksToBounds = true
        btnBack.setTitle("戻る", for: UIControl.State())
        btnBack.setTitleColor(UIColor.white, for: UIControl.State())
        btnBack.setTitleColor(UIColor.black, for: UIControl.State.highlighted)
        btnBack.layer.cornerRadius = 8.0
        btnBack.addTarget(self, action: #selector(self.onClickbtnBack(_:)), for: .touchUpInside)
        btnBack.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(btnBack)
    }
    
    //制約ひな型
    func Constraint(_ item: AnyObject, _ attr: NSLayoutConstraint.Attribute, to: AnyObject?, _ attrTo: NSLayoutConstraint.Attribute, constant: CGFloat = 0.0, multiplier: CGFloat = 1.0, relate: NSLayoutConstraint.Relation = .equal, priority: UILayoutPriority = UILayoutPriority.required) -> NSLayoutConstraint {
        let ret = NSLayoutConstraint(
            item:       item,
            attribute:  attr,
            relatedBy:  relate,
            toItem:     to,
            attribute:  attrTo,
            multiplier: multiplier,
            constant:   constant
        )
        ret.priority = priority
        return ret
    }
    
    override func viewDidLayoutSubviews(){
        //制約
        self.view.addConstraints([
            //基礎データ入力ボタン
            Constraint(btnBack, .top, to:self.view, .centerY, constant:20),
            Constraint(btnBack, .leading, to:self.view, .leading, constant:8),
            Constraint(btnBack, .trailing, to:self.view, .trailingMargin, constant:8)
            ])
    }
    
    //戻るボタン押された
    @objc func onClickbtnBack(_ sender: UIButton){
        print("戻るボタン押された")
        //self.dismiss(animated: true, completion: nil)
        //子ViewControllerへ通知
        self.willMove(toParentViewController: nil)
        //子ViewをSuperviewから削除
        self.view.removeFromSuperview()
        //子ViewControllerへ通知
        self.removeFromParentViewController()
    }
        
}
