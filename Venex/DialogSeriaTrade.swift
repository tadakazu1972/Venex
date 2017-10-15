//
//  DialogSeriaTrade.swift
//  Venex
//
//  Created by 中道 忠和 on 2017/10/14.
//  Copyright © 2017年 tadakazu nakamichi. All rights reserved.
//

import UIKit

class DialogSeriaTrade: NSObject, UITableViewDelegate, UITableViewDataSource {
    //ボタン押したら出るUIWindow
    var parent: ViewController!
    var win1: UIWindow!
    var win2: UIWindow!
    var text1: UITextView!
    var text2: UITextView!
    var table: UITableView!
    var items:[String] = ["","",""]
    var btnClose: UIButton!
    var btnClose2: UIButton!
    
    //コンストラクタ
    init(parentView: ViewController){
        parent = parentView
        win1 = UIWindow()
        win2 = UIWindow()
        text1 = UITextView()
        text2 = UITextView()
        table = UITableView()
        btnClose = UIButton()
        btnClose2 = UIButton()
        text1.text = "アイテム交換"
        text2.text = ""
        items = ["ユリ×５ ▶︎ 回復薬(小)×1","回復薬(小)×３ ▶︎ 回復薬(中)×１"]
    }
    
    //デコンストラクタ
    deinit{
        parent = nil
        win1 = nil
        win2 = nil
        text1 = nil
        text2 = nil
        table = nil
        items = ["","",""]
        btnClose = nil
        btnClose2 = nil
    }
    
    //表示
    func showInfo(){
        //元の画面を暗くしないほうがいいのでは
        //parent.view.alpha = 0.3
        //初期設定
        //Win1
        win1.backgroundColor = UIColor.white
        win1.frame = CGRect(x: 80,y: 200,width: parent.view.frame.width-40,height: 200)
        win1.layer.position = CGPoint(x: parent.view.frame.width/2, y: parent.view.frame.height/2)
        win1.alpha = 1.0
        win1.layer.cornerRadius = 10
        win1.layer.borderColor = UIColor(red: 0.3, green: 0.3, blue: 0.6, alpha: 1.0).cgColor
        win1.layer.borderWidth = 3.0
        //KeyWindowにする
        win1.makeKey()
        //表示
        self.win1.makeKeyAndVisible()
        
        //TextView生成
        text1.frame = CGRect(x: 10, y: 0, width: self.win1.frame.width-20, height: 40)
        text1.backgroundColor = UIColor.clear
        text1.font = UIFont.systemFont(ofSize: CGFloat(18))
        text1.textColor = UIColor.black
        text1.textAlignment = NSTextAlignment.left
        text1.isEditable = false
        self.win1.addSubview(text1)
        
        //TableView生成
        table.frame = CGRect(x: 10,y: 41, width: self.win1.frame.width-20, height: self.win1.frame.height-60)
        table.delegate = self
        table.dataSource = self
        table.estimatedRowHeight = 10 //下とあわせこの２行で複数行表示されるときの間がひらくようになる
        table.rowHeight = UITableViewAutomaticDimension //同上
        table.register(UITableViewCell.self, forCellReuseIdentifier:"cell")
        //table.separatorColor = UIColor.clear
        self.win1.addSubview(table)
        
        //閉じるボタン生成
        btnClose.frame = CGRect(x: 0,y: 0,width: 100,height: 30)
        btnClose.backgroundColor = UIColor.orange
        btnClose.setTitle("閉じる", for: UIControlState())
        btnClose.setTitleColor(UIColor.white, for: UIControlState())
        btnClose.layer.masksToBounds = true
        btnClose.layer.cornerRadius = 10.0
        btnClose.layer.position = CGPoint(x: self.win1.frame.width/2, y: self.win1.frame.height-20)
        btnClose.addTarget(self, action: #selector(self.onClickClose(_:)), for: .touchUpInside)
        self.win1.addSubview(btnClose)
    }
    
    //閉じる
    @objc func onClickClose(_ sender: UIButton){
        win1.isHidden = true      //win1隠す
        text1.text = ""         //使い回しするのでテキスト内容クリア
        parent.view.alpha = 1.0 //元の画面明るく
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection sction: Int)-> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = table.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        cell.textLabel?.numberOfLines = 0 //これをしないと複数行表示されない
        cell.textLabel?.text = self.items[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("セルを選択 #\(indexPath.row)!")
        
        switch indexPath.row {
        case 0:
            text2.text = parent.mDBHelper.trade("ユリ", input:5, name2:"回復薬(小)", output:1)
            self.showResult()
            break
        case 1:
            text2.text = parent.mDBHelper.trade("回復薬(小)", input:3, name2:"回復薬(中)", output:1)
            self.showResult()
            break
        default:
            break
        }
        
        //自らのダイアログを消去しておく
        //win1.isHidden = true      //win1隠す
        //text1.text = ""         //使い回しするのでテキスト内容クリア
        //items = ["","","",""]
    }
    
    //アイテム交換の結果コメント表示
    func showResult(){
        //下のwindowを少し暗くする
        win1.alpha = 0.5
        //初期設定
        //Win2
        win2.backgroundColor = UIColor.white
        win2.frame = CGRect(x: 80,y: 200,width: parent.view.frame.width-40,height: 200)
        win2.layer.position = CGPoint(x: parent.view.frame.width/2+10, y: parent.view.frame.height/2+10)
        win2.alpha = 1.0
        win2.layer.cornerRadius = 10
        win2.layer.borderColor = UIColor(red: 0.3, green: 0.3, blue: 0.6, alpha: 1.0).cgColor
        win2.layer.borderWidth = 3.0
        self.win2.makeKeyAndVisible()
        
        //TextView生成
        text2.frame = CGRect(x: 10, y: 0, width: self.win2.frame.width-20, height: self.win2.frame.height-20)
        text2.backgroundColor = UIColor.clear
        text2.font = UIFont.systemFont(ofSize: CGFloat(18))
        text2.textColor = UIColor.black
        text2.textAlignment = NSTextAlignment.left
        text2.isEditable = false
        self.win2.addSubview(text2)
        
        //閉じるボタン生成
        btnClose2.frame = CGRect(x: 0,y: 0,width: 100,height: 30)
        btnClose2.backgroundColor = UIColor.orange
        btnClose2.setTitle("閉じる", for: UIControlState())
        btnClose2.setTitleColor(UIColor.white, for: UIControlState())
        btnClose2.layer.masksToBounds = true
        btnClose2.layer.cornerRadius = 10.0
        btnClose2.layer.position = CGPoint(x: self.win1.frame.width/2, y: self.win1.frame.height-20)
        btnClose2.addTarget(self, action: #selector(self.onClickClose2(_:)), for: .touchUpInside)
        self.win2.addSubview(btnClose2)
    }
    
    //閉じる
    @objc func onClickClose2(_ sender: UIButton){
        win2.isHidden = true    //win2隠す
        text2.text = ""         //使い回しするのでテキスト内容クリア
        win1.alpha = 1.0        //下のwindow明るく
    }
}
