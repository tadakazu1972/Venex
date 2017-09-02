//
//  MyChara.swift
//  Venex
//
//  Created by 中道忠和 on 2017/09/02.
//  Copyright © 2017年 tadakazu nakamichi. All rights reserved.
//

import UIKit

class MyChara {
    public var x: CGFloat!
    public var y: CGFloat!
    public var vx: CGFloat!
    public var vy: CGFloat!
    public var base_index: Int!
    public var index: Int!
    public var currentMap: Int!
    
    //コンストラクタ
    init(){
        x = 4 * 32.0
        y = 5 * 32.0
        vx = 0.0
        vy = 0.0
        base_index = 4
        index = 0
        currentMap = 0
    }
    
    //デコンストラクタ
    deinit {
        x = nil
        y = nil
        vx = nil
        vy = nil
        base_index = nil
        index = nil
        currentMap = nil
    }
    
    func move(){
        //座標更新
        x = x + vx
        y = y + vy
        //アニメーション
        index = index + 1
        if ( index > 19) { index = 0 }
    }
    
    func up(){
        vx =  0.0
        vy = -1.0
        base_index = 0
    }
    
    func right(){
        vx =  1.0
        vy =  0.0
        base_index = 2
    }
    
    func down(){
        vx =  0.0
        vy =  1.0
        base_index = 4
    }
    
    func left(){
        vx = -1.0
        vy =  0.0
        base_index = 6
    }
}
