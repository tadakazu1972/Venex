//
//  DialogItem.swift
//  Venex
//
//  Created by 中道忠和 on 2017/09/18.
//  Copyright © 2017年 tadakazu nakamichi. All rights reserved.
//

import UIKit

class DialogItem: NSObject, UITableViewDelegate, UITableViewDataSource {
    //UI
    var parent: UIViewController!
    var win: UIWindow!
    var text1: UITextView!
    var table: UITableView!
    var result: [[String]] = []
    var btnClose: UIButton!
    //選択_id保存用配列
    var checkArray: [Bool] = []
    
    //コンストラクタ
    init(parentView: UIViewController, resultFrom: [[String]]){
        super.init()
        parent = parentView
        win = UIWindow()
        text1 = UITextView()
        table = UITableView()
        btnClose = UIButton()
        result = resultFrom
        checkArray = Array(repeating: false, count: result.count) //抽出件数だけ初期化
    }
    
    //デコンストラクタ
    deinit {
        parent = nil
        win = nil
        text1 = nil
        table = nil
        btnClose = nil
        checkArray.removeAll()
    }
    
    //表示
    func showItems(){
        //下のViewを暗く
        parent.view.alpha = 0.5
        //win
        win.backgroundColor = UIColor.white
        win.frame = CGRect(x:80, y:180, width:parent.view.frame.width-20, height:parent.view.frame.height-150)
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
        text1.text="どのアイテムを使用しますか？"
        self.win.addSubview(text1)
        
        //TableView生成
        table.frame = CGRect(x: 10, y: 41, width: self.win.frame.width-20, height: self.win.frame.height-60)
        table.delegate = self
        table.dataSource = self
        table.estimatedRowHeight = 60 //下とあわせこの２行で複数表示されるときの間がひらくように
        table.rowHeight = UITableViewAutomaticDimension
        table.register(CheckboxItemCell.self, forCellReuseIdentifier:"CheckboxItemCell")
        table.separatorColor = UIColor.clear
        table.allowsMultipleSelection = true
        self.win.addSubview(table)
        
        func tableView(_ tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: IndexPath) -> CGFloat { return UITableViewAutomaticDimension }
        
        //閉じるボタン生成
        btnClose.frame = CGRect(x: 0,y: 0,width: 80,height: 30)
        btnClose.backgroundColor = UIColor.orange
        btnClose.setTitle("閉じる", for: UIControlState())
        btnClose.setTitleColor(UIColor.white, for: UIControlState())
        btnClose.layer.masksToBounds = true
        btnClose.layer.cornerRadius = 10.0
        btnClose.layer.position = CGPoint(x: self.win.frame.width/2, y: self.win.frame.height-20)
        btnClose.addTarget(self, action: #selector(self.touchClose(_:)), for: .touchUpInside)
        self.win.addSubview(btnClose)
    }
    
    //閉じるボタンタッチ
    func touchClose(_ sender: UIButton){
        win.isHidden = true      //win隠す
        text1.text = ""         //使い回しするのでテキスト内容クリア
        parent.view.alpha = 1.0 //元の画面明るく
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection sction:Int)-> Int {
        return self.result.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40 // セルの高さ
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)-> UITableViewCell {
        let cell:CheckboxItemCell = table.dequeueReusableCell(withIdentifier: "CheckboxItemCell")! as! CheckboxItemCell
        cell.textLabel?.numberOfLines = 0 //これをしないと複数表示されない
        cell.checkbox!.isSelected = self.checkArray[indexPath.row]
        cell.name!.text = self.result[indexPath.row][0]
        cell.num!.text  = self.result[indexPath.row][1]
        return cell
    }
    
    //セルを選択
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("セルを選択 #\(indexPath.row)")
        //チェックを反転
        self.checkArray[indexPath.row] = !self.checkArray[indexPath.row]
        //状態を即刻反映するためリロードして再描画
        table.reloadData()
    }
}
