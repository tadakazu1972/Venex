//
//  DialogBattle.swift
//  Venex
//
//  Created by 中道忠和 on 2017/11/05.
//  Copyright © 2017年 tadakazu nakamichi. All rights reserved.
//

import UIKit

class DialogBattle: NSObject {
    //ボタン押したら出るUIWindow
    var parent: ViewController!
    var win1: UIWindow!
    var text1: UITextView!
    var btnClose: UIButton!
    var btnNext: UIButton!
    //モンスター画像とテキスト(名前、HP)
    var imageMonster1: UIImageView!
    var imageMonster2: UIImageView!
    var imageMonster3: UIImageView!
    var imageMonster4: UIImageView!
    var imageMonster5: UIImageView!
    var imageMonster6: UIImageView!
    var nameMonster1: UITextView!
    var nameMonster2: UITextView!
    var nameMonster3: UITextView!
    var nameMonster4: UITextView!
    var nameMonster5: UITextView!
    var nmaeMonster6: UITextView!
    var hpMonster1: UITextView!
    var hoMonster2: UITextView!
    var hpMonster3: UITextView!
    var hpMonster4: UITextView!
    var hpMonster5: UITextView!
    var hpMonster6: UITextView!
    //画像
    let imageSkelton: UIImage = UIImage(named: "skelton.png")!
    let imageGhouldragon: UIImage = UIImage(named: "ghouldragon.png")!
    
    //データ
    var data: [[String]]!
    var index: Int = 0
    let indexMax: Int = 16
    
    //コンストラクタ
    init(parentView: ViewController){
        super.init()
        
        parent = parentView
        win1 = UIWindow()
        text1 = UITextView()
        btnClose = UIButton()
        btnNext  = UIButton()
        text1.text = "【戦闘】"
        data = [[String]](repeating: [String](repeating:"a", count:1), count:indexMax+1)
        //データ読み込み
        loadCSV()
        
        //モンスター画像用初期化
        imageMonster1 = UIImageView()
        imageMonster2 = UIImageView()
        imageMonster3 = UIImageView()
        imageMonster4 = UIImageView()
        imageMonster5 = UIImageView()
        imageMonster6 = UIImageView()
        
    }
    
    //デコンストラクタ
    deinit{
        parent = nil
        win1 = nil
        text1 = nil
        btnClose = nil
        btnNext = nil
    }
    
    //表示
    func showInfo (){
        //元の画面を暗く
        parent.view.alpha = 0.3
        //初期設定
        //Win1
        win1.backgroundColor = UIColor.black
        win1.frame = CGRect(x: 10, y: 10, width: parent.view.frame.width-10, height: parent.view.frame.height-80)
        win1.layer.position = CGPoint(x: parent.view.frame.width/2, y: parent.view.frame.height/2)
        win1.alpha = 1.0
        win1.layer.cornerRadius = 10
        win1.layer.borderColor = UIColor(red: 0.6, green: 0.3, blue: 0.3, alpha: 1.0).cgColor
        win1.layer.borderWidth = 3.0
        //KeyWindowにする
        win1.makeKey()
        //表示
        self.win1.makeKeyAndVisible()
        
        //TextView生成
        text1.frame = CGRect(x: 10, y: 0, width: self.win1.frame.width-20, height: 200)
        text1.backgroundColor = UIColor.clear
        text1.font = UIFont.systemFont(ofSize: CGFloat(18))
        text1.textColor = UIColor.red
        text1.textAlignment = NSTextAlignment.left
        text1.isEditable = false
        text1.text = "【戦闘】\n" + data[0][0]
        self.win1.addSubview(text1)
        
        //閉じるボタン生成
        btnClose.frame = CGRect(x: 0,y: 0,width: 80,height: 30)
        btnClose.backgroundColor = UIColor.orange
        btnClose.setTitle("閉じる", for: UIControlState())
        btnClose.setTitleColor(UIColor.white, for: UIControlState())
        btnClose.layer.masksToBounds = true
        btnClose.layer.cornerRadius = 10.0
        btnClose.layer.position = CGPoint(x: self.win1.frame.width/2-80, y: self.win1.frame.height-20)
        btnClose.addTarget(self, action: #selector(self.onClickClose(_:)), for: .touchUpInside)
        self.win1.addSubview(btnClose)
        
        //次へボタン生成
        btnNext.isHidden = false  //２回目は消されてたボタンを表示
        btnNext.frame = CGRect(x: 0,y: 0,width: 80,height: 30)
        btnNext.backgroundColor = UIColor.blue
        btnNext.setTitle("次へ", for: UIControlState())
        btnNext.setTitleColor(UIColor.white, for: UIControlState())
        btnNext.layer.masksToBounds = true
        btnNext.layer.cornerRadius = 10.0
        btnNext.layer.position = CGPoint(x: self.win1.frame.width/2+80, y: self.win1.frame.height-20)
        btnNext.addTarget(self, action: #selector(self.onClickNext(_:)), for: .touchUpInside)
        self.win1.addSubview(btnNext)
        
        //モンスター画像ImageView生成
        // Monster1
        imageMonster1.image = imageSkelton
        imageMonster1.frame = CGRect(x: 0, y: 0, width: 96, height: 96)
        imageMonster1.layer.position = CGPoint(x: self.win1.frame.width/2, y: self.win1.frame.height/2)
        imageMonster1.backgroundColor = UIColor.clear
        imageMonster1.isUserInteractionEnabled = true
        imageMonster1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.onTapMonster1(_:))))
        self.win1.addSubview(imageMonster1)
        
        // Monster2
        imageMonster2.image = imageSkelton
        imageMonster2.frame = CGRect(x: 0, y: 0, width: 96, height: 96)
        imageMonster2.layer.position = CGPoint(x: self.win1.frame.width/3-48, y: self.win1.frame.height/2)
        imageMonster2.backgroundColor = UIColor.clear
        imageMonster2.isUserInteractionEnabled = true
        imageMonster2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.onTapMonster2(_:))))
        self.win1.addSubview(imageMonster2)
        
        // Monster3
        imageMonster3.image = imageSkelton
        imageMonster3.frame = CGRect(x: 0, y: 0, width: 96, height: 96)
        imageMonster3.layer.position = CGPoint(x: self.win1.frame.width/3*2+48, y: self.win1.frame.height/2)
        imageMonster3.backgroundColor = UIColor.clear
        imageMonster3.isUserInteractionEnabled = true
        imageMonster3.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.onTapMonster3(_:))))
        self.win1.addSubview(imageMonster3)
        
        // Monster4
        imageMonster4.image = imageGhouldragon
        imageMonster4.frame = CGRect(x: 0, y: 0, width: 96, height: 96)
        imageMonster4.layer.position = CGPoint(x: self.win1.frame.width/2, y: self.win1.frame.height/2-116)
        imageMonster4.backgroundColor = UIColor.clear
        imageMonster4.isUserInteractionEnabled = true
        imageMonster4.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.onTapMonster1(_:))))
        self.win1.addSubview(imageMonster4)
        
        // Monster5
        imageMonster5.image = imageGhouldragon
        imageMonster5.frame = CGRect(x: 0, y: 0, width: 96, height: 96)
        imageMonster5.layer.position = CGPoint(x: self.win1.frame.width/3-48, y: self.win1.frame.height/2-116)
        imageMonster5.backgroundColor = UIColor.clear
        imageMonster5.isUserInteractionEnabled = true
        imageMonster5.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.onTapMonster2(_:))))
        self.win1.addSubview(imageMonster5)
        
        // Monster6
        imageMonster6.image = imageGhouldragon
        imageMonster6.frame = CGRect(x: 0, y: 0, width: 96, height: 96)
        imageMonster6.layer.position = CGPoint(x: self.win1.frame.width/3*2+48, y: self.win1.frame.height/2-116)
        imageMonster6.backgroundColor = UIColor.clear
        imageMonster6.isUserInteractionEnabled = true
        imageMonster6.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.onTapMonster3(_:))))
        self.win1.addSubview(imageMonster6)
    }
    
    @objc func onTapMonster1(_ sender: UITapGestureRecognizer){
        imageMonster1.backgroundColor = UIColor.yellow
    }
    
    @objc func onTapMonster2(_ sender: UITapGestureRecognizer){
        imageMonster2.backgroundColor = UIColor.yellow
    }
    
    @objc func onTapMonster3(_ sender: UITapGestureRecognizer){
        imageMonster3.backgroundColor = UIColor.yellow
    }
    
    //閉じる
    @objc func onClickClose(_ sender: UIButton){
        win1.isHidden = true      //win1隠す
        text1.text = ""         //使い回しするのでテキスト内容クリア
        parent.view.alpha = 1.0 //元の画面明るく
    }
    
    //会話を次へ進める
    @objc func onClickNext(_ sender: UIButton){
        index = index + 1
        if ( index > indexMax ){
            index = 0
        }
        text1.text = "【セリア】\n" + data[index][0]
    }
    
    //CSV読み込み
    func loadCSV(){
        var result: [[String]] = []
        if let path = Bundle.main.path(forResource: "talkSeria", ofType: "csv") {
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
            for y in 0..<indexMax+1 {
                data[y][0] = result[y][0]
            }
            print("csv読み込み完了")
        } else {
            text1.text = "csvファイル読み込みエラー"
        }
    }
}
