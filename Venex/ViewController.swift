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
    //Map
    let image0: UIImage = UIImage(named: "greenfield.png")!
    let image1: UIImage = UIImage(named: "tree.png")!
    let image2: UIImage = UIImage(named: "brick.png")!
    let image3: UIImage = UIImage(named: "seria.png")!
    let image4: UIImage = UIImage(named: "field4.png")!
    let image5: UIImage = UIImage(named: "field5.png")!
    let skelton: UIImage = UIImage(named: "skelton01.png")!
    var imageMap: Array<UIImage> = []
    var sMap: Array<UIImageView> = [] //あとでfor文の中で100の配列初期化
    var currentMap: Int = 0 //画面に表示中のマップIndex
    var mMap: Array<Map> = []
    var fieldFlag: Bool = true //セリアがマップid="3"であり、衝突判定で地上にいるか判定フラグ
    var exitFlag: Bool = true //鍾乳洞の入口/出口の当たり判定でぶつかった際に切り替えるべきか判定フラグ
    //MyChara
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
    var mMyChara: MyChara!
    //アイテム
    let imageItem01: UIImage = UIImage(named: "lily16")!
    var imageItemArray: Array<UIImage> = []
    var sItem: Array<UIImageView> = [] //あとでfor文の中で20個の配列初期化
    var mItem: Array<Item> = []
    //ボタン類
    let btnUp    = UIButton(frame: CGRect.zero)
    let btnRight = UIButton(frame: CGRect.zero)
    let btnDown  = UIButton(frame: CGRect.zero)
    let btnLeft  = UIButton(frame: CGRect.zero)
    let btnItem  = UIButton(frame: CGRect.zero)
    let btnStatus = UIButton(frame: CGRect.zero)
    var longPressFlag: Bool = false //ロングプレス判定用
    //クラス
    var mDBHelper: DBHelper!
    var mDialogItem: DialogItem!
    //タイマー
    var timer: Timer!
    //UserDefaults
    let userDefaults = UserDefaults.standard
    
    //子ViewController設定
    private lazy var mStatusViewController: StatusViewController = {
        var viewController = StatusViewController()
        add(asChildViewController: viewController)
        return viewController
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //DB生成
        mDBHelper = DBHelper()
        mDBHelper.createTable()
        
        //初回起動判定
        if userDefaults.bool(forKey:"firstLaunch"){
            //アイテム初期化
            mDBHelper.insert("ユリ", num:10)
            mDBHelper.insert("鉄鉱石", num:3)
            mDBHelper.insert("木ノ実", num:20)
            
            //2回目以降ではfalse
            userDefaults.set(false, forKey:"firstLaunch")
        }
        
        //背景色
        self.view.backgroundColor = UIColor(red:0.3, green:0.3, blue:0.6, alpha:1.0)
        //端末の画面サイズを取得して画像の拡大率を決定
        initScreen()
        //ボタン初期化
        initButtons()
        
        //クラス生成
        mMyChara = MyChara(parent: self)
        initMap()
        
        //画像配列追加
        initImage()
        //親ViewにImageViewを追加
        initImageView()
        
        //アイテム初期化
        initItem()
        
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
    func Constraint(_ item: AnyObject, _ attr: NSLayoutAttribute, to: AnyObject?, _ attrTo: NSLayoutAttribute, constant: CGFloat = 0.0, multiplier: CGFloat = 1.0, relate: NSLayoutRelation = .equal, priority: UILayoutPriority = UILayoutPriority.required) -> NSLayoutConstraint {
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
        //Upボタン
        self.view.addConstraints([
            Constraint(btnUp, .top, to:self.view, .centerY, constant:104),
            Constraint(btnUp, .leading, to:self.view, .leading, constant:64*scale),
            Constraint(btnUp, .width, to:self.view, .width, constant:0, multiplier:0.15),
            Constraint(btnUp, .height, to:self.view, .height, constant:0, multiplier:0.08)
        ])
        //Rightボタン
        self.view.addConstraints([
            Constraint(btnRight, .top, to:btnUp, .bottom, constant:8*scale),
            Constraint(btnRight, .leading, to:btnUp, .trailing, constant:0),
            Constraint(btnRight, .width, to:self.view, .width, constant:0, multiplier:0.15),
            Constraint(btnRight, .height, to:btnUp, .height, constant:0)
        ])
        //Downボタン
        self.view.addConstraints([
            Constraint(btnDown, .top, to:btnRight, .bottom, constant:8*scale),
            Constraint(btnDown, .leading, to:btnUp, .leading, constant:0),
            Constraint(btnDown, .width, to:self.view, .width, constant:0, multiplier:0.15),
            Constraint(btnDown, .height, to:btnUp, .height, constant:0)
        ])
        //Leftボタン
        self.view.addConstraints([
            Constraint(btnLeft, .top, to:btnUp, .bottom, constant:8*scale),
            Constraint(btnLeft, .trailing, to:btnUp, .leading, constant:0),
            Constraint(btnLeft, .width, to:self.view, .width, constant:0, multiplier:0.15),
            Constraint(btnLeft, .height, to:btnUp, .height, constant:0)
        ])
        //Itemボタン
        self.view.addConstraints([
            Constraint(btnItem, .top, to:self.view, .centerY, constant:104),
            Constraint(btnItem, .trailing, to:self.view, .trailing, constant:-16),
            Constraint(btnItem, .width, to:self.view, .width, constant:0, multiplier:0.3),
            Constraint(btnItem, .height, to:self.view, .height, constant:0, multiplier:0.08)
        ])
        //Statusボタン
        self.view.addConstraints([
            Constraint(btnStatus, .top, to:btnItem, .bottom, constant:8),
            Constraint(btnStatus, .trailing, to:self.view, .trailing, constant:-16),
            Constraint(btnStatus, .width, to:self.view, .width, constant:0, multiplier:0.3),
            Constraint(btnStatus, .height, to:self.view, .height, constant:0, multiplier:0.08)
        ])
    }
    
    //ボタン初期化
    func initButtons(){
        //ロングプレス定義
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.longPress(_:)))
        longPressGesture.minimumPressDuration = 1.0 //２秒以上でロングプレス
        
        //Up
        btnUp.backgroundColor = UIColor(red:0.85, green:0.85, blue:0.85, alpha:1.0)
        btnUp.layer.masksToBounds = true
        let imageUp = UIImage(named: "key_up.png")
        btnUp.setBackgroundImage(imageUp, for: .normal)
        btnUp.layer.cornerRadius = 4.0
        btnUp.setTitleColor(UIColor.black, for: UIControlState())
        btnUp.setTitleColor(UIColor.red, for: UIControlState.highlighted)
        btnUp.translatesAutoresizingMaskIntoConstraints = false
        btnUp.addTarget(self, action: #selector(self.touchUp(_:)), for: .touchDown)
        btnUp.addTarget(self, action: #selector(self.touchUpRepeat(_:)), for: .touchDownRepeat)
        btnUp.addGestureRecognizer(longPressGesture)
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
        btnRight.addTarget(self, action: #selector(self.touchRight(_:)), for: .touchDown)
        btnRight.addTarget(self, action: #selector(self.touchRightRepeat(_:)), for: .touchDownRepeat)
        btnRight.addGestureRecognizer(longPressGesture)
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
        btnDown.addTarget(self, action: #selector(self.touchDown(_:)), for: .touchDown)
        btnDown.addTarget(self, action: #selector(self.touchDownRepeat(_:)), for: .touchDownRepeat)
        btnDown.addGestureRecognizer(longPressGesture)
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
        btnLeft.addTarget(self, action: #selector(self.touchLeft(_:)), for: .touchDown)
        btnLeft.addTarget(self, action: #selector(self.touchLeftRepeat(_:)), for: .touchDownRepeat)
        btnLeft.addGestureRecognizer(longPressGesture)
        self.view.addSubview(btnLeft)
        
        //アイテム
        btnItem.backgroundColor = UIColor(red:0.85, green:0.85, blue:0.85, alpha:1.0)
        btnItem.layer.masksToBounds = true
        btnItem.setTitle("アイテム", for: UIControlState())
        btnItem.setTitleColor(UIColor.black, for: UIControlState())
        btnItem.setTitleColor(UIColor.red, for: UIControlState.highlighted)
        btnItem.layer.cornerRadius = 8.0
        btnItem.addTarget(self, action: #selector(self.touchBtnItem(_:)), for: .touchUpInside)
        btnItem.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(btnItem)
        
        //Status
        btnStatus.backgroundColor = UIColor(red:0.85, green:0.85, blue:0.85, alpha:1.0)
        btnStatus.layer.masksToBounds = true
        btnStatus.setTitle("ステータス", for: UIControlState())
        btnStatus.setTitleColor(UIColor.black, for: UIControlState())
        btnStatus.setTitleColor(UIColor.red, for: UIControlState.highlighted)
        btnStatus.layer.cornerRadius = 8.0
        btnStatus.addTarget(self, action: #selector(self.onClickbtnStatus(_:)), for: .touchUpInside)
        btnStatus.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(btnStatus)
    }
    
    //ロングプレス
    @objc func longPress(_ sender: UILongPressGestureRecognizer){
        longPressFlag = true
        print("長押し")
        //指が離れた検知
        if (sender.state == UIGestureRecognizerState.ended){
            longPressFlag = false
            print("長押し終了")
        }
    }
    
    //ボタン押下
    @objc func touchUp(_ sender: UIButton){
        mMyChara.up(speed: 1.0)
    }
    @objc func touchRight(_ sender: UIButton){
        mMyChara.right(speed: 1.0)
    }
    @objc func touchDown(_ sender: UIButton){
        mMyChara.down(speed: 1.0)
    }
    @objc func touchLeft(_ sender: UIButton){
        mMyChara.left(speed: 1.0)
    }
    
    //ボタン押しっぱなし
    @objc func touchUpRepeat(_ sender: UIButton){
        mMyChara.up(speed: 3.0)
    }
    @objc func touchRightRepeat(_ sender: UIButton){
        mMyChara.right(speed: 3.0)
    }
    @objc func touchDownRepeat(_ sender: UIButton){
        mMyChara.down(speed: 3.0)
    }
    @objc func touchLeftRepeat(_ sender: UIButton){
        mMyChara.left(speed: 3.0)
    }
    
    //Itemボタン推された
    @objc func touchBtnItem(_ sender: UIButton){
        mDBHelper.selectAll2()
        mDialogItem = DialogItem(parentView: self, resultFrom: mDBHelper.resultArray)
        mDialogItem.showItems()
    }
    
    //Statusボタン推された
    @objc func onClickbtnStatus(_ sender: UIButton){
        print("Statusボタン押された")
        add(asChildViewController: mStatusViewController)
    }
    
    //子ViewController 追加、削除
    private func add(asChildViewController viewController: UIViewController){
        addChildViewController(viewController)
        self.view.addSubview(viewController.view)
        //viewController.view.frame = self.view.bounds
        viewController.view.frame = CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.height)
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        //子ViewControllerへ通知
        viewController.didMove(toParentViewController: self)
    }
    
    private func remove(asChildViewController viewController: UIViewController){
        //子ViewControllerへ通知
        viewController.willMove(toParentViewController: nil)
        //子ViewをSuperviewから削除
        viewController.view.removeFromSuperview()
        //子ViewControllerへ通知
        viewController.removeFromParentViewController()
    }
    
    //*******************************************************************************************************************************
    // ゲームループ
    //*******************************************************************************************************************************
    //タイマー更新
    @objc func update(tm: Timer){
        //移動処理
        mMyChara.move()
        //描画処理
        drawMyChara()
        drawItem()
    }
    
    //*******************************************************************************************************************************
    // 初期化関係
    //*******************************************************************************************************************************
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
        imageMap.append(image2)
        imageMap.append(image3)
        imageMap.append(image4)
        imageMap.append(image5)
        imageMap.append(skelton)
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
        let fileName: [String] = ["map0","map1","map2","map3","map4","map5","map6","fieldMap7","fieldMap8","map0","map0"]
        for i in 0..<11 {
            //Mapクラスを生成してmMap配列に追加
            let tempMap: Map = Map(_index: i)
            mMap.append(tempMap)
            //ファイル名を生成してcsvファイル読み込み
            mMap[i].loadCSV(_filename: fileName[i])
        }
        //次に表示するマップデータ読み込み
        mMap[0].setNext(up: 7,right: 0,down: 1,left: 0)
        mMap[1].setNext(up: 0,right: 2,down: 0,left: 0)
        mMap[2].setNext(up: 0,right: 3,down: 0,left: 1)
        mMap[3].setNext(up: 0,right: 4,down: 0,left: 2)
        mMap[4].setNext(up: 0,right: 0,down: 5,left: 3)
        mMap[5].setNext(up: 4,right: 0,down: 6,left: 0)
        mMap[6].setNext(up: 5,right: 0,down: 0,left: 0)
        mMap[7].setNext(up: 8,right: 0,down: 0,left: 0)
        mMap[8].setNext(up: 0,right: 0,down: 7,left: 0)
        mMap[9].setNext(up: 0,right: 0,down: 0,left: 0)
        mMap[10].setNext(up: 0,right: 0,down: 0,left: 0)
    }
    
    //鍾乳洞マップ読み込み
    func loadSyonyudoMap(){
        //アイテム消去（今の所は）
        clearItem()
        //地上フラグOFF
        fieldFlag = false
        //一旦配列クリア
        imageMap.removeAll()
        //マップ画像差し替え
        let syonyudo0: UIImage = UIImage(named: "syonyudo0.png")!
        let syonyudo1: UIImage = UIImage(named: "syonyudo1.png")!
        let syonyudo2: UIImage = UIImage(named: "syonyudo2.png")!
        let syonyudo3: UIImage = UIImage(named: "syonyudo3.png")!
        let syonyudo4: UIImage = UIImage(named: "syonyudo4.png")!
        let syonyudo5: UIImage = UIImage(named: "syonyudo5.png")!
        //配列に追加しなおし
        imageMap.append(syonyudo0)
        imageMap.append(syonyudo1)
        imageMap.append(syonyudo2)
        imageMap.append(syonyudo3)
        imageMap.append(syonyudo4)
        imageMap.append(syonyudo5)
        //マップデータ差し替え
        for i in 0..<11 {
            let fileName = "syonyudoMap" + String(i)
            mMap[i].loadCSV(_filename: fileName)
        }
        mMap[0].setNext(up: 0,right: 0,down: 1,left: 0)
        mMap[1].setNext(up: 0,right: 4,down: 0,left: 2)
        mMap[2].setNext(up: 0,right: 1,down: 0,left: 3)
        mMap[3].setNext(up: 0,right: 2,down: 0,left: 0)
        mMap[4].setNext(up: 0,right: 5,down: 0,left: 1)
        mMap[5].setNext(up: 0,right: 0,down: 6,left: 4)
        mMap[6].setNext(up: 5,right: 0,down: 7,left: 0)
        mMap[7].setNext(up: 6,right: 8,down: 0,left: 0)
        mMap[8].setNext(up: 0,right: 9,down: 0,left: 7)
        mMap[9].setNext(up: 0,right: 10,down: 0,left: 8)
        mMap[10].setNext(up: 0,right: 0,down: 0,left: 9)
        //現在地を設定して...
        currentMap = 0
        //再描画
        drawMap()
    }
    
    //地上フィールドマップ再読み込み
    func loadFieldMap(){
        //アイテム再出現
        setItem()
        //地上フラグON
        fieldFlag = true
        //一旦配列クリア
        imageMap.removeAll()
        //マップ画像差し替え
        imageMap.append(image0)
        imageMap.append(image1)
        imageMap.append(image2)
        imageMap.append(image3)
        imageMap.append(image4)
        imageMap.append(image5)
        //マップデータ差し替え
        let fileName: [String] = ["map0","map1","map2","map3","map4","map5","map6","fieldMap7","fieldMap8","map0","map0"]
        for i in 0..<11 {
            //Mapクラスを生成してmMap配列に追加
            let tempMap: Map = Map(_index: i)
            mMap.append(tempMap)
            //ファイル名を生成してcsvファイル読み込み
            mMap[i].loadCSV(_filename: fileName[i])
        }
        //次に表示するマップデータ読み込み
        mMap[0].setNext(up: 7,right: 0,down: 1,left: 0)
        mMap[1].setNext(up: 0,right: 2,down: 0,left: 0)
        mMap[2].setNext(up: 0,right: 3,down: 0,left: 1)
        mMap[3].setNext(up: 0,right: 4,down: 0,left: 2)
        mMap[4].setNext(up: 0,right: 0,down: 5,left: 3)
        mMap[5].setNext(up: 4,right: 0,down: 6,left: 0)
        mMap[6].setNext(up: 5,right: 0,down: 0,left: 0)
        mMap[7].setNext(up: 8,right: 0,down: 0,left: 0)
        mMap[8].setNext(up: 0,right: 0,down: 7,left: 0)
        mMap[9].setNext(up: 0,right: 0,down: 0,left: 0)
        mMap[10].setNext(up: 0,right: 0,down: 0,left: 0)
        //現在地を設定して...
        currentMap = 8
        //再描画
        drawMap()
    }

    //ViewにImageViewを追加
    func initImageView(){
        //Map
        for y in 0..<10 {
            for x in 0..<10 {
                sMap.append(UIImageView())
                let mapId: Int = mMap[currentMap].data[y][x]
                let i: Int = y*10 + x
                sMap[i].image = imageMap[mapId]
                sMap[i].frame = CGRect(x: CGFloat(x)*32*scale, y: CGFloat(y)*32*scale+statusBarHeight, width: scaledSize, height: scaledSize)
                self.view.addSubview(sMap[i])
            }
        }
        //MyChara
        sMyChara.image = imageMyChara[mMyChara.base_index]
        sMyChara.frame = CGRect(x: mMyChara.x*scale, y: mMyChara.y*scale+statusBarHeight, width:scaledSize, height: scaledSize)
        self.view.addSubview(sMyChara)
    }
    
    //マップ描画
    func drawMap(){
        //画像を10ｘ10並べる
        for y in 0..<10 {
            for x in 0..<10 {
                let mapId: Int = mMap[currentMap].data[y][x]
                let i: Int = y*10 + x
                sMap[i].image = imageMap[mapId]
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
    
    //*******************************************************************************************************************************
    // アイテム
    //*******************************************************************************************************************************
    //アイテム初期化
    func initItem(){
        for i in 0..<20 {
            //まずはItemクラスを生成
            let tempItem: Item = Item(_parent: self)
            mItem.append(tempItem)
            mItem[i].setItem()
            //次に画像を生成
            sItem.append(UIImageView())
            sItem[i].image = imageItem01
            sItem[i].frame = CGRect(x: mItem[i].x*scale, y: mItem[i].y*scale+statusBarHeight, width:scaledSize/2, height: scaledSize/2)
            self.view.addSubview(sItem[i])
        }
    }
    
    //アイテム再セット
    func setItem(){
        for i in 0..<20 {
            mItem[i].setItem()
            sItem[i].frame = CGRect(x: mItem[i].x*scale, y: mItem[i].y*scale+statusBarHeight, width:scaledSize/2, height: scaledSize/2)
        }
    }
    
    //アイテム描画　見えているなら描画、取得したなら隠す
    func drawItem(){
        for i in 0..<20 {
            //描画処理
            if ( mItem[i].visible ){
                sItem[i].isHidden = false
                //当たり判定チェック
                mItem[i].checkCollision()
                sItem[i].frame = CGRect(x: mItem[i].x*scale, y: mItem[i].y*scale+statusBarHeight, width:scaledSize/2, height: scaledSize/2)
            } else {
                sItem[i].isHidden = true
            }
        }
    }
    
    func clearItem(){
        for i in 0..<20 {
            mItem[i].visible = false
        }
    }
    
    //Xcode自動生成コード
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
