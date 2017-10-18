//
//  DialogItem.swift
//  Venex
//
//  Created by 中道忠和 on 2017/09/18.
//  Copyright © 2017年 tadakazu nakamichi. All rights reserved.
//

import UIKit

class DialogItem: NSObject, UITableViewDelegate, UITableViewDataSource {
    var parent: ViewController!
    //window1
    var win1: UIWindow!
    var text1: UITextView!
    var table: UITableView!
    var result: [[String]] = []
    var btnClose: UIButton!
    var checkArray: [Bool] = []  //選択_id保存用配列
    //window2
    var win2: UIWindow!
    var text2: UITextView!
    var item: String!
    var num: String!
    var id: String!
    var btnClose2: UIButton!
    var btnOK: UIButton!
        
    //コンストラクタ
    init(parentView: ViewController, resultFrom: [[String]]){
        super.init()
        parent = parentView
        //window1
        win1 = UIWindow()
        text1 = UITextView()
        table = UITableView()
        btnClose = UIButton()
        result = resultFrom
        checkArray = Array(repeating: false, count: result.count) //抽出件数だけ初期化
        //window2
        win2 = UIWindow()
        text2 = UITextView()
        item = ""
        num = ""
        id = ""
        btnClose2 = UIButton()
        btnOK = UIButton()
    }
    
    //デコンストラクタ
    deinit {
        parent = nil
        //window1
        win1 = nil
        text1 = nil
        table = nil
        btnClose = nil
        checkArray.removeAll()
        //window2
        win2 = nil
        text2 = nil
        item = ""
        num = ""
        id = ""
        btnClose2 = nil
        btnOK = nil
    }
    
    // window1 *************************************************************************************
    func showItems(){
        //下のViewを暗く
        parent.view.alpha = 0.5
        //win1
        win1.backgroundColor = UIColor.white
        win1.frame = CGRect(x:80, y:180, width:parent.view.frame.width-20, height:parent.view.frame.height-150)
        win1.layer.position = CGPoint(x:parent.view.frame.width/2, y:parent.view.frame.height/2)
        win1.alpha = 1.0
        win1.layer.cornerRadius = 10
        win1.layer.borderColor = UIColor(red: 0.3, green: 0.3, blue: 0.6, alpha: 1.0).cgColor
        win1.layer.borderWidth = 3.0
        win1.makeKey()
        self.win1.makeKeyAndVisible()
        
        //TextView
        text1.frame = CGRect(x: 10,y: 10, width: self.win1.frame.width - 20, height: self.win1.frame.height-60)
        text1.backgroundColor = UIColor.clear
        text1.font = UIFont.systemFont(ofSize: CGFloat(18))
        text1.textColor = UIColor.black
        text1.textAlignment = NSTextAlignment.left
        text1.isEditable = false
        text1.isScrollEnabled = true
        text1.dataDetectorTypes = .link
        text1.text="どのアイテムを使用しますか？"
        self.win1.addSubview(text1)
        
        //TableView生成
        table.frame = CGRect(x: 10, y: 41, width: self.win1.frame.width-20, height: self.win1.frame.height-60)
        table.delegate = self
        table.dataSource = self
        table.estimatedRowHeight = 60 //下とあわせこの２行で複数表示されるときの間がひらくように
        table.rowHeight = UITableViewAutomaticDimension
        table.register(CheckboxItemCell.self, forCellReuseIdentifier:"CheckboxItemCell")
        //table.separatorColor = UIColor.clear //線を消す
        table.allowsMultipleSelection = true
        self.win1.addSubview(table)
        
        func tableView(_ tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: IndexPath) -> CGFloat { return UITableViewAutomaticDimension }
        
        //閉じるボタン生成
        btnClose.frame = CGRect(x: 0,y: 0,width: 80,height: 30)
        btnClose.backgroundColor = UIColor.orange
        btnClose.setTitle("閉じる", for: UIControlState())
        btnClose.setTitleColor(UIColor.white, for: UIControlState())
        btnClose.layer.masksToBounds = true
        btnClose.layer.cornerRadius = 10.0
        btnClose.layer.position = CGPoint(x: self.win1.frame.width/2, y: self.win1.frame.height-20)
        btnClose.addTarget(self, action: #selector(self.touchClose(_:)), for: .touchUpInside)
        self.win1.addSubview(btnClose)
    }
    
    //閉じる
    @objc func touchClose(_ sender: UIButton){
        win1.isHidden = true      //win隠す
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
        //アイテムを何個使うのかダイアログを表示
        item = self.result[indexPath.row][0]
        num  = self.result[indexPath.row][1]
        id   = self.result[indexPath.row][2]
        self.showItemUsing()
    }
    
    // window2 *************************************************************************************
    func showItemUsing(){
        //下のwindow1を暗く
        win1.alpha = 0.3
        //win
        win2.backgroundColor = UIColor.white
        win2.frame = CGRect(x:80, y:180, width:parent.view.frame.width-20, height:120)
        win2.layer.position = CGPoint(x:parent.view.frame.width/2, y:parent.view.frame.height/2)
        win2.alpha = 1.0
        win2.layer.cornerRadius = 10
        win2.layer.borderColor = UIColor(red: 0.3, green: 0.3, blue: 0.6, alpha: 1.0).cgColor
        win2.layer.borderWidth = 3.0
        win2.makeKey()
        self.win2.makeKeyAndVisible()
        
        //TextView
        text2.frame = CGRect(x: 10,y: 10, width: self.win2.frame.width - 20, height: self.win2.frame.height-40)
        text2.backgroundColor = UIColor.clear
        text2.font = UIFont.systemFont(ofSize: CGFloat(18))
        text2.textColor = UIColor.black
        text2.textAlignment = NSTextAlignment.left
        text2.isEditable = false
        text2.isScrollEnabled = true
        text2.dataDetectorTypes = .link
        text2.text = item + "を使用してよろしいですか？\n残り:" + num
        self.win2.addSubview(text2)
        
        //閉じるボタン生成
        btnClose2.frame = CGRect(x: 0,y: 0,width: 80,height: 30)
        btnClose2.backgroundColor = UIColor.orange
        btnClose2.setTitle("やめる", for: UIControlState())
        btnClose2.setTitleColor(UIColor.white, for: UIControlState())
        btnClose2.layer.masksToBounds = true
        btnClose2.layer.cornerRadius = 10.0
        btnClose2.layer.position = CGPoint(x: self.win2.frame.width/2-80, y: self.win2.frame.height-20)
        btnClose2.addTarget(self, action: #selector(self.touchClose2(_:)), for: .touchUpInside)
        self.win2.addSubview(btnClose2)
        
        //OKボタン生成
        btnOK.isHidden = false  //２回目は消されてたボタンを表示
        btnOK.frame = CGRect(x: 0,y: 0,width: 80,height: 30)
        btnOK.backgroundColor = UIColor.red
        btnOK.setTitle("OK", for: UIControlState())
        btnOK.setTitleColor(UIColor.white, for: UIControlState())
        btnOK.layer.masksToBounds = true
        btnOK.layer.cornerRadius = 10.0
        btnOK.layer.position = CGPoint(x: self.win2.frame.width/2+80, y: self.win2.frame.height-20)
        btnOK.addTarget(self, action: #selector(self.touchOK(_:)), for: .touchUpInside)
        self.win2.addSubview(btnOK)
    }
    
    //閉じる
    @objc func touchClose2(_ sender: UIButton){
        win2.isHidden = true    //win隠す
        text2.text = ""         //使い回しするのでテキスト内容クリア
        win1.alpha = 1.0        //下のwindow1を明るく
    }
    
    //OK
    @objc func touchOK(_ sender: UIButton){
        text2.text = item + "を使用しました。"
        //DBにアクセスしてアイテムを減らす処理
        var itemNum : Int = Int(num)!
        if ( itemNum < 2 ){
            print("アイテム最後をつこうてしまうで")
            //最後の1個やからDBから該当itemをDeleteせんならんよ
            parent.mDBHelper.delete(id)
            text2.text = item + "は無くなりました。"
        } else {
            //DBにアクセスして該当itemのnumを１個減らしてupdate
            itemNum = itemNum - 1
            parent.mDBHelper.update(item, num: itemNum, _id: id)
        }
        //下のwindow1のtableを新たなDBに書き換え処理
        parent.mDBHelper.selectAll2()
        result = parent.mDBHelper.resultArray
        table.reloadData()
        //OKボタンは見えなくする
        btnOK.isHidden = true
        //やめるボタンは閉じるボタンに変化
        btnClose2.setTitle("閉じる", for: UIControlState())
        btnClose2.layer.position = CGPoint(x: self.win2.frame.width/2, y: self.win2.frame.height-20)
    }
}
