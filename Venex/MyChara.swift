//
//  MyChara.swift
//  Venex
//
//  Created by 中道忠和 on 2017/09/02.
//  Copyright © 2017年 tadakazu nakamichi. All rights reserved.
//

import UIKit

class MyChara {
    var x: CGFloat!
    var y: CGFloat!
    var vx: CGFloat!
    var vy: CGFloat!
    var base_index: Int!
    var index: Int!
    var viewController: ViewController! //ViewControllerのメンバー変数であるcurrentMapにアクセスするため保存
    //利用クラス
    var mDialogSeria1: DialogSeria1!
    
    //コンストラクタ
    init(parent: ViewController){
        x = 4 * 32.0
        y = 5 * 32.0
        vx = 0.0
        vy = 0.0
        base_index = 4
        index = 0
        viewController = parent
    }
    
    //デコンストラクタ
    deinit {
        x = nil
        y = nil
        vx = nil
        vy = nil
        base_index = nil
        index = nil
    }
    
    func move(){
        //当たり判定用座標算出
        var x1: Int = Int((x+4+vx))/32; if ( x1 < 0){ x1 = 0 }; if ( x1 > 9){ x1 = 9 }
        var y1: Int = Int((y+4+vy))/32; if ( y1 < 0){ y1 = 0 }; if ( y1 > 9){ y1 = 9 }
        var x2: Int = Int((x+28+vx))/32; if ( x2 < 0){ x2 = 0 }; if ( x2 > 9 ){ x2 = 9 }
        var y2: Int = Int((y+28+vy))/32; if ( y2 < 0){ y2 = 0 }; if ( y2 > 9 ){ y2 = 9 }
        //カベ判定
        let i: Int = viewController.currentMap
        if ( viewController.mMap[i].data[y1][x1] > 0 || viewController.mMap[i].data[y1][x2] > 0 || viewController.mMap[i].data[y2][x1] > 0 || viewController.mMap[i].data[y2][x2] > 0){
            vx = 0.0
            vy = 0.0
            //セリア判定
            if ( viewController.mMap[i].data[y1][x1] == 3 || viewController.mMap[i].data[y1][x2] == 3 || viewController.mMap[i].data[y2][x1] == 3 || viewController.mMap[i].data[y2][x2] == 3){
                //ダイアログ呼び出し
                mDialogSeria1 = DialogSeria1(parentView: viewController)
                mDialogSeria1.showInfo()
            }
        }
        //画面端判定
        if ( x < -8.0 ){
            //左にあるマップのデータに切り替え
            viewController.currentMap = viewController.mMap[viewController.currentMap].next[3]
            viewController.drawMap()
            viewController.setItem()
            x = 288.0
        }
        if ( x > 296.0 ){
            //右にあるマップのデータに切り替え
            viewController.currentMap = viewController.mMap[viewController.currentMap].next[1]
            viewController.drawMap()
            viewController.setItem()
            x = 0.0
        }
        if ( y < -8.0 ){
            //上にあるマップのデータに切り替え
            viewController.currentMap = viewController.mMap[viewController.currentMap].next[0]
            viewController.drawMap()
            viewController.setItem()
            y = 288.0
        }
        if ( y > 296.0 ){
            //下にあるマップのデータに切り替え
            viewController.currentMap = viewController.mMap[viewController.currentMap].next[2]
            viewController.drawMap()
            viewController.setItem()
            y = 0.0
        }
        //座標更新
        x = x + vx
        y = y + vy
        //アニメーション
        index = index + 1
        if ( index > 19) { index = 0 }
    }
    
    func up(speed: CGFloat){
        vx =  0.0
        vy = -1.0 * speed
        base_index = 0
    }
    
    func right(speed: CGFloat){
        vx =  1.0 * speed
        vy =  0.0
        base_index = 2
    }
    
    func down(speed: CGFloat){
        vx =  0.0
        vy =  1.0 * speed
        base_index = 4
    }
    
    func left(speed: CGFloat){
        vx = -1.0 * speed
        vy =  0.0
        base_index = 6
    }
}
