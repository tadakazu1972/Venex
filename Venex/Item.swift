//
//  Item.swift
//  Venex
//
//  Created by 中道忠和 on 2017/09/24.
//  Copyright © 2017年 tadakazu nakamichi. All rights reserved.
//

import UIKit

class Item {
    var parent: ViewController!
    var id: Int!
    var x: CGFloat!
    var y: CGFloat!
    var visible: Bool!
    
    //コンストラクタ
    init(_parent: ViewController){
        parent = _parent
        id = 0
        x = 0.0
        y = 0.0
        visible = true
    }
    
    //画面切り替え時の初期配置計算
    func setItem(){
        //もし消滅フラグが立っていたらもとにもどす
        visible = true
        //まず、マップの中で配置できる位置を決定
        let i: Int = parent.currentMap
        var rX: UInt32 = 0
        var rY: UInt32 = 0
        repeat {
            rX = arc4random_uniform(10)
            rY = arc4random_uniform(10)
        } while parent.mMap[i].data[Int(rY)][Int(rX)] > 0
        //次に、４隅のいずれかをランダムに決定
        let r: UInt32 = arc4random_uniform(4)
        switch ( r ){
        case 0:
            x = CGFloat(rX) * 32
            y = CGFloat(rY) * 32
            break
        case 1:
            x = CGFloat(rX) * 32 + 16.0
            y = CGFloat(rY) * 32
            break
        case 2:
            x = CGFloat(rX) * 32
            y = CGFloat(rY) * 32 + 16.0
            break
        case 3:
            x = CGFloat(rX) * 32 + 16.0
            y = CGFloat(rY) * 32 + 16.0
            break
        default:
            x = CGFloat(rX) * 32
            y = CGFloat(rY) * 32
        }
    }
    
    //主人公と当たり判定
    func checkCollision(){
        if ( parent.mMyChara.x < x+15 && x < parent.mMyChara.x+31 && parent.mMyChara.y < y+15 && y < parent.mMyChara.y+31 ){
            visible = false
        }
    }
}
