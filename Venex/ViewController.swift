//
//  ViewController.swift
//  Venex
//
//  Created by 中道忠和 on 2017/08/31.
//  Copyright © 2017年 tadakazu nakamichi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //画面サイズ関係
    var screenWidth: CGFloat = 320.0
    var screenHeight: CGFloat = 320.0
    var statusBarHeight: CGFloat = 20.0
    var scale: CGFloat = 1.0
    var scaledSize: CGFloat = 1.0
    //Map画像
    let image0: UIImage = UIImage(named: "greenfield.png")!
    let image1: UIImage = UIImage(named: "tree.png")!
    var imageMap: Array<UIImage> = []
    var sMap: Array<UIImageView> = [] //あとでfor文の中で100の配列初期化
    //MyChara画像
    let arthur01: UIImage = UIImage(named: "arthur01.png")!
    let arthur02: UIImage = UIImage(named: "arthur02.png")!
    let arthur03: UIImage = UIImage(named: "arthur03.png")!
    let arthur04: UIImage = UIImage(named: "arthur04.png")!
    let arthur05: UIImage = UIImage(named: "arthur05.png")!
    let arthur06: UIImage = UIImage(named: "arthur06.png")!
    let arthur07: UIImage = UIImage(named: "arthur07.png")!
    let arthur08: UIImage = UIImage(named: "arthur08.png")!
    var imageMyChara: Array<UIImage> = []
    var sMyChara: UIImageView = UIImageView()
    //ボタン類
    let btnUp    = UIButton(frame: CGRect.zero)
    let btnRight = UIButton(frame: CGRect.zero)
    let btnDown  = UIButton(frame: CGRect.zero)
    let btnLeft  = UIButton(frame: CGRect.zero)
    
    //クラス
    internal var mMyChara: MyChara!
    internal var mMap: Array<Map> = []
    
    //タイマー
    var timer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //背景色
        self.view.backgroundColor = UIColor(red:0.3, green:0.3, blue:0.6, alpha:1.0)
        //端末の画面サイズを取得して画像の拡大率を決定
        initScreen()
        //ボタン初期化
        initButtons()
        
        //クラス生成
        mMyChara = MyChara()
        initMap()
        
        //画像配列追加
        initImage()
        //親ViewにImageViewを追加
        initImageView()
        
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(true)
        timer = Timer.scheduledTimer(timeInterval: 0.014, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
        timer.fire()
    }
    
    override func viewWillDisappear(_ animated: Bool){
        super.viewWillDisappear(true)
        timer.invalidate()
    }
    
    //制約ひな型
    func Constraint(_ item: AnyObject, _ attr: NSLayoutAttribute, to: AnyObject?, _ attrTo: NSLayoutAttribute, constant: CGFloat = 0.0, multiplier: CGFloat = 1.0, relate: NSLayoutRelation = .equal, priority: UILayoutPriority = UILayoutPriorityRequired) -> NSLayoutConstraint {
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
            //Upボタン
            Constraint(btnUp, .top, to:self.view, .centerY, constant:104),
            Constraint(btnUp, .leading, to:self.view, .leading, constant:64*scale),
            Constraint(btnUp, .width, to:self.view, .width, constant:0, multiplier:0.15),
            Constraint(btnUp, .height, to:self.view, .height, constant:0, multiplier:0.08)
        ])
        self.view.addConstraints([
            //Rightボタン
            Constraint(btnRight, .top, to:btnUp, .bottom, constant:8*scale),
            Constraint(btnRight, .leading, to:btnUp, .trailing, constant:0),
            Constraint(btnRight, .width, to:self.view, .width, constant:0, multiplier:0.15),
            Constraint(btnRight, .height, to:btnUp, .height, constant:0)
        ])
        self.view.addConstraints([
            //Downボタン
            Constraint(btnDown, .top, to:btnRight, .bottom, constant:8*scale),
            Constraint(btnDown, .leading, to:btnUp, .leading, constant:0),
            Constraint(btnDown, .width, to:self.view, .width, constant:0, multiplier:0.15),
            Constraint(btnDown, .height, to:btnUp, .height, constant:0)
        ])
        self.view.addConstraints([
            //Leftボタン
            Constraint(btnLeft, .top, to:btnUp, .bottom, constant:8*scale),
            Constraint(btnLeft, .trailing, to:btnUp, .leading, constant:0),
            Constraint(btnLeft, .width, to:self.view, .width, constant:0, multiplier:0.15),
            Constraint(btnLeft, .height, to:btnUp, .height, constant:0)
        ])
    }
    
    //ボタン初期化
    func initButtons(){
        //Up
        btnUp.backgroundColor = UIColor(red:0.85, green:0.85, blue:0.85, alpha:1.0)
        btnUp.layer.masksToBounds = true
        let imageUp = UIImage(named: "key_up.png")
        btnUp.setBackgroundImage(imageUp, for: .normal)
        btnUp.layer.cornerRadius = 4.0
        btnUp.setTitleColor(UIColor.black, for: UIControlState())
        btnUp.setTitleColor(UIColor.red, for: UIControlState.highlighted)
        btnUp.translatesAutoresizingMaskIntoConstraints = false
        btnUp.addTarget(self, action: #selector(self.touchUp(_:)), for: .touchUpInside)
        self.view.addSubview(btnUp)
        //Right
        btnRight.backgroundColor = UIColor(red:0.85, green:0.85, blue:0.85, alpha:1.0)
        btnRight.layer.masksToBounds = true
        let imageRight = UIImage(named: "key_right.png")
        btnRight.setBackgroundImage(imageRight, for: .normal)
        btnRight.layer.cornerRadius = 4.0
        btnRight.setTitleColor(UIColor.black, for: UIControlState())
        btnRight.setTitleColor(UIColor.red, for: UIControlState.highlighted)
        btnRight.translatesAutoresizingMaskIntoConstraints = false
        btnRight.addTarget(self, action: #selector(self.touchRight(_:)), for: .touchUpInside)
        self.view.addSubview(btnRight)
        //Down
        btnDown.backgroundColor = UIColor(red:0.85, green:0.85, blue:0.85, alpha:1.0)
        btnDown.layer.masksToBounds = true
        let imageDown = UIImage(named: "key_down.png")
        btnDown.setBackgroundImage(imageDown, for: .normal)
        btnDown.layer.cornerRadius = 4.0
        btnDown.setTitleColor(UIColor.black, for: UIControlState())
        btnDown.setTitleColor(UIColor.red, for: UIControlState.highlighted)
        btnDown.translatesAutoresizingMaskIntoConstraints = false
        btnDown.addTarget(self, action: #selector(self.touchDown(_:)), for: .touchUpInside)
        self.view.addSubview(btnDown)
        //Left
        btnLeft.backgroundColor = UIColor(red:0.85, green:0.85, blue:0.85, alpha:1.0)
        btnLeft.layer.masksToBounds = true
        let imageLeft = UIImage(named: "key_left.png")
        btnLeft.setBackgroundImage(imageLeft, for: .normal)
        btnLeft.layer.cornerRadius = 4.0
        btnLeft.setTitleColor(UIColor.black, for: UIControlState())
        btnLeft.setTitleColor(UIColor.red, for: UIControlState.highlighted)
        btnLeft.translatesAutoresizingMaskIntoConstraints = false
        btnLeft.addTarget(self, action: #selector(self.touchLeft(_:)), for: .touchUpInside)
        self.view.addSubview(btnLeft)
    }
    
    //ボタン押下
    func touchUp(_ sender: UIButton){
        mMyChara.up()
    }
    func touchRight(_ sender: UIButton){
        mMyChara.right()
    }
    func touchDown(_ sender: UIButton){
        mMyChara.down()
    }
    func touchLeft(_ sender: UIButton){
        mMyChara.left()
    }
    
    //画面初期化
    func initScreen(){
        screenWidth = self.view.frame.size.width
        screenHeight = self.view.frame.size.height
        //ステータスバー高さ取得
        statusBarHeight = UIApplication.shared.statusBarFrame.size.height
        //32pixelの画像を10*10並べるため、画面サイズ横幅を320.0で割り算して拡大率を求める
        scale = screenWidth / 320.0
        //32x32の画像の幅と高さは固定なのであらかじめ計算しておく。for文の中で計算するとコストがかかるため。
        scaledSize = 32 * scale
    }
    
    //画像セット
    func initImage(){
        //Map
        imageMap.append(image0)
        imageMap.append(image1)
        //MyChara
        imageMyChara.append(arthur07)
        imageMyChara.append(arthur08)
        imageMyChara.append(arthur03)
        imageMyChara.append(arthur04)
        imageMyChara.append(arthur01)
        imageMyChara.append(arthur02)
        imageMyChara.append(arthur05)
        imageMyChara.append(arthur06)
    }
    
    //マップデータ初期化、読み込み
    func initMap(){
        let tempMap: Map = Map(_index: 0)
        mMap.append(tempMap)
        mMap[0].loadCSV(_filename: "map1")
    }

    //ViewにImageViewを追加
    func initImageView(){
        //Map
        for y in 0..<10 {
            for x in 0..<10 {
                sMap.append(UIImageView())
                let index: Int = mMap[0].data[y][x]
                let i: Int = y*10 + x
                sMap[i].image = imageMap[index]
                sMap[i].frame = CGRect(x: CGFloat(x)*32*scale, y: CGFloat(y)*32*scale+statusBarHeight, width: scaledSize, height: scaledSize)
                self.view.addSubview(sMap[i])
            }
        }
        //MyChara
        sMyChara.image = imageMyChara[mMyChara.base_index]
        sMyChara.frame = CGRect(x: mMyChara.x*scale, y: mMyChara.y*scale+statusBarHeight, width:scaledSize, height: scaledSize)
        self.view.addSubview(sMyChara)
    }
    
    //タイマー更新
    func update(tm: Timer){
        //移動処理
        mMyChara.move()
        //描画処理
        drawMyChara()
    }
    
    //マップ描画
    func drawMap(){
        //画像を10ｘ10並べる
        for y in 0..<10 {
            for x in 0..<10 {
                let i = y*10 + x
                sMap[i].image = imageMap[1]
                sMap[i].frame = CGRect(x: CGFloat(x)*32*scale, y: CGFloat(y)*32*scale+statusBarHeight, width: scaledSize, height: scaledSize)
            }
        }
    }
    
    //MyChara描画
    func drawMyChara(){
        var i = mMyChara.base_index + mMyChara.index / 10
        if ( i > 7 ) { i = 0 }
        sMyChara.image = imageMyChara[i]
        sMyChara.frame = CGRect(x: mMyChara.x*scale, y: mMyChara.y*scale+statusBarHeight, width:scaledSize, height: scaledSize)
    }
    
    //Xcode自動生成コード
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

