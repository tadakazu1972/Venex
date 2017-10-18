//
//  DialogSeriaTalk.swift
//  Venex
//
//  Created by 中道 忠和 on 2017/10/18.
//  Copyright © 2017年 tadakazu nakamichi. All rights reserved.
//

import UIKit

class DialogSeriaTalk: NSObject {
    //ボタン押したら出るUIWindow
    var parent: ViewController!
    var win1: UIWindow!
    var text1: UITextView!
    var btnClose: UIButton!
    //データ
    var data: [[String]]!
    
    //コンストラクタ
    init(parentView: ViewController){
        super.init()
        
        parent = parentView
        win1 = UIWindow()
        text1 = UITextView()
        btnClose = UIButton()
        text1.text = "【セリア】こんにちわ。"
        data = [[String]](repeating: [String](repeating:"a", count:10), count:10)
        //データ読み込み
        loadCSV()
    }
    
    //デコンストラクタ
    deinit{
        parent = nil
        win1 = nil
        text1 = nil
        btnClose = nil
    }
    
    //表示
    func showInfo (){
        //元の画面を暗く
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
        text1.frame = CGRect(x: 10, y: 0, width: self.win1.frame.width-20, height: 200)
        text1.backgroundColor = UIColor.clear
        text1.font = UIFont.systemFont(ofSize: CGFloat(18))
        text1.textColor = UIColor.black
        text1.textAlignment = NSTextAlignment.left
        text1.isEditable = false
        text1.text = "【セリア】\n" + data[0][0]
        self.win1.addSubview(text1)
        
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
    
    //CSV読み込み
    func loadCSV(){
        var result: [[String]] = []
        if let path = Bundle.main.path(forResource: "map0", ofType: "csv") {
            var csvString = ""
            do {
                csvString = try String(contentsOfFile: path, encoding: String.Encoding.utf8)
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            csvString.enumerateLines { (line, stop) -> () in
                result.append(line.components(separatedBy: ",")) //これでresult[y][x]の呼び出しが可能となる
            }
            //メンバー変数に変換して代入
            for y in 0..<10 {
                data[y][0] = result[y][0]
            }
            print("csv読み込み完了")
        } else {
            text1.text = "csvファイル読み込みエラー"
        }
    }
}
