//
//  DialogItem2.swift
//  Venex
//
//  Created by 中道忠和 on 2017/09/22.
//  Copyright © 2017年 tadakazu nakamichi. All rights reserved.
//

import UIKit

class DialogItem2 {
    //UI
    var parent: ViewController!
    var win: UIWindow!
    var text1: UITextView!
    var item: String = ""
    var num: String = ""
    var id: String = ""
    var btnClose: UIButton!
    var btnOK: UIButton!
    
    //コンストラクタ
    init(parentView: ViewController, _item: String, _num: String, _id: String){
        parent = parentView
        win = UIWindow()
        text1 = UITextView()
        item = _item
        num = _num
        id = _id
        btnClose = UIButton()
        btnOK = UIButton()
    }
    
    //デコンストラクタ
    deinit {
        parent = nil
        win = nil
        text1 = nil
        item = ""
        num = ""
        id = ""
        btnClose = nil
        btnOK = nil
    }
    
    //いくつアイテムを使いますか？表示
    func showItemUsing(){
        //下のViewを暗く
        parent.view.alpha = 0.5
        //win
        win.backgroundColor = UIColor.white
        win.frame = CGRect(x:80, y:180, width:parent.view.frame.width-20, height:120)
        win.layer.position = CGPoint(x:parent.view.frame.width/2, y:parent.view.frame.height/2)
        win.alpha = 1.0
        win.layer.cornerRadius = 10
        win.makeKey()
        self.win.makeKeyAndVisible()
        
        //TextView
        text1.frame = CGRect(x: 10,y: 10, width: self.win.frame.width - 20, height: self.win.frame.height-60)
        text1.backgroundColor = UIColor.clear
        text1.font = UIFont.systemFont(ofSize: CGFloat(18))
        text1.textColor = UIColor.black
        text1.textAlignment = NSTextAlignment.left
        text1.isEditable = false
        text1.isScrollEnabled = true
        text1.dataDetectorTypes = .link
        text1.text = item + "を使用してよろしいですか？" + num
        self.win.addSubview(text1)
        
        //閉じるボタン生成
        btnClose.frame = CGRect(x: 0,y: 0,width: 80,height: 30)
        btnClose.backgroundColor = UIColor.orange
        btnClose.setTitle("やめる", for: UIControlState())
        btnClose.setTitleColor(UIColor.white, for: UIControlState())
        btnClose.layer.masksToBounds = true
        btnClose.layer.cornerRadius = 10.0
        btnClose.layer.position = CGPoint(x: self.win.frame.width/2-80, y: self.win.frame.height-20)
        btnClose.addTarget(self, action: #selector(self.touchClose(_:)), for: .touchUpInside)
        self.win.addSubview(btnClose)
        
        //OKボタン生成
        btnOK.frame = CGRect(x: 0,y: 0,width: 80,height: 30)
        btnOK.backgroundColor = UIColor.red
        btnOK.setTitle("OK", for: UIControlState())
        btnOK.setTitleColor(UIColor.white, for: UIControlState())
        btnOK.layer.masksToBounds = true
        btnOK.layer.cornerRadius = 10.0
        btnOK.layer.position = CGPoint(x: self.win.frame.width/2+80, y: self.win.frame.height-20)
        btnOK.addTarget(self, action: #selector(self.touchOK(_:)), for: .touchUpInside)
        self.win.addSubview(btnOK)
    }
    
    //閉じる
    @objc func touchClose(_ sender: UIButton){
        win.isHidden = true      //win隠す
        text1.text = ""         //使い回しするのでテキスト内容クリア
        parent.view.alpha = 1.0 //元の画面明るく
    }
    
    //OK
    @objc func touchOK(_ sender: UIButton){
        text1.text = item + "を使用しました。"
        //DBにアクセスしてアイテムを減らす処理
        var itemNum : Int = Int(num)!
        if ( itemNum < 2 ){
            print("アイテム最後をつこうてしまうで")
            //最後の1個やからDBから該当itemをDeleteせんならんよ
            parent.mDBHelper.delete(id)
            text1.text = item + "は無くなりました。"
        } else {
            //DBにアクセスして該当itemのnumを１個減らしてupdate
            itemNum = itemNum - 1
            parent.mDBHelper.update(item, num: itemNum, _id: id)
        }
        //OKボタンは見えなくする
        btnOK.isHidden = true
        //やめるボタンは閉じるボタンに変化
        btnClose.setTitle("閉じる", for: UIControlState())
        btnClose.layer.position = CGPoint(x: self.win.frame.width/2, y: self.win.frame.height-20)
    }
}
