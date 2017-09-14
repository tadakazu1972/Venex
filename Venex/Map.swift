//
//  Map.swift
//  Venex
//
//  Created by 中道忠和 on 2017/09/02.
//  Copyright © 2017年 tadakazu nakamichi. All rights reserved.
//

import UIKit

class Map {
    public var index: Int!
    public var data: [[Int]]!
    public var next: [Int]!
    
    //コンストラクタ
    init(_index: Int){
        index = _index
        data = [[Int]](repeating: [Int](repeating: 0, count: 10), count: 10)
        next = [Int](repeating: 0, count: 4)
    }
    
    //CSV読み込み
    func loadCSV(_filename: String){
        var result: [[String]] = []
        if let path = Bundle.main.path(forResource: _filename, ofType: "csv") {
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
                for x in 0..<10 {
                    data[y][x] = Int(result[y][x])!
                }
            }
        } else {
            //text1.text = "csvファイル読み込みエラー"
        }
    }
}
