//
//  DBHelper.swift
//  FireEmergency
//
//  Created by 中道忠和 on 2017/02/05.
//  Copyright © 2017年 tadakazu nakamichi. All rights reserved.
//

class DBHelper {
    var db : FMDatabase
    var resultArray: [[String]] //SELECTの結果格納用配列
    
    //コンストラクタ
    init(){
        db = FMDatabase.init()
        resultArray = []
        connectDB()
    }
    
    func connectDB(){
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let path = paths[0].stringByAppendingPathComponent("myrecord.db")
        db = FMDatabase(path: path)
    }
    
    func createTable(){
        db.open()
        let sql = "CREATE TABLE IF NOT EXISTS items(_id integer primary key autoincrement,name text,num integer);"
        do {
            try db.executeUpdate(sql, values: nil)
            print("テーブル作成　成功")
        } catch {
            print("テーブル作成　失敗しました!")
        }
        db.close()
    }
    
    func insert(_ name: String, num: Int){
        print("insert実行")
        let sql = "INSERT INTO items(name, num) VALUES(?, ?);"
        db.open()
        db.executeUpdate(sql, withArgumentsIn: [name, num])
        db.close()
    }
    
    func update(_ name: String, num: Int, _id: String){
        let sql = "UPDATE items SET name = ?, num = ? WHERE _id = ?;"
        db.open()
        db.executeUpdate(sql, withArgumentsIn: [name, num, _id])
        print("DBの _id =\(_id)をnum=\(num)にupdateしました")
        db.close()
    }
    
    func delete(_ _id: String){
        let sql = "DELETE FROM items WHERE _id = ?;"
        db.open()
        db.executeUpdate(sql, withArgumentsIn: [_id])
        db.close()        
    }
    
    func selectAll(){
        //前の検索結果が残っているので全削除
        resultArray.removeAll()
        let sql = "SELECT * FROM items ORDER BY _id;"
        db.open()
        do {
            let results = try db.executeQuery(sql, values: nil)
            print("doの中実行")
            while (results.next()){
                print("whileの中実行")
                let _name: String = results.string(forColumn: "name")!
                let _num: String = results.string(forColumn: "num")!
                resultArray.append([_name, _num])
            }
        } catch {
            
        }
        db.close()
    }
    
    // _idも取得するバージョン
    func selectAll2(){
        //前の検索結果が残っているので全削除
        resultArray.removeAll()
        let sql = "SELECT * FROM items ORDER BY _id;"
        db.open()
        do {
            let results = try db.executeQuery(sql, values: nil)
            while (results.next()){
                let _name: String = results.string(forColumn: "name")!
                let _num: String = results.string(forColumn: "num")!
                let _id: String = results.string(forColumn: "_id")!
                resultArray.append([_name, _num, _id])
            }
        } catch {
            
        }
        db.close()
    }
    
    //アイテムをゲットして、レコード生成または所有数を増加
    func add(_ name: String){
        var _num: String = ""
        var _id: String = ""
        //前の検索結果を消去
        resultArray.removeAll()
        //SQL生成
        //let sql: String = "SELECT num FROM items WHERE name = '" + name + "';"
        let sql: String = "SELECT num, _id FROM items WHERE name = '" + name + "';"
        print(sql)
        db.open()
        do {
            let results = try db.executeQuery(sql, values: nil)
            while (results.next()){
                //let _name: String = results.string(forColumn: "name")!
                _num = results.string(forColumn: "num")!
                _id = results.string(forColumn: "_id")!
                resultArray.append([_num, _id])
                print(_num)
            }
            print(results.columnCount) //resultsが何もなかったら0を返すのでこれでレコードがあるかないか判断するか...
            //_numが""であればレコードが存在しないので、insertを実行
            if ( _num == "" ){
                self.insert(name, num: Int(_num)!)
            } else {
                //そうでなければレコードがすでに存在するのでnumに+1してupdate
                let addedNum = Int(_num)! + 1
                print(addedNum)
                self.update(name, num: addedNum, _id: _id)
            }
        } catch {
            print("catchの部分実行している")
        }
        db.close()
    }
    
    /*func select(_ kubun: String, syozoku0: String, syozoku: String, kinmu: String){
        //前の検索結果が残っているので全削除
        resultArray.removeAll()

        //SQL文作成準備
        var kubunSQL : String = "IS NOT NULL"
        if kubun != "すべて" {
            kubunSQL = "='" + kubun + "'"
        }
        var syozoku0SQL : String = "IS NOT NULL"
        if syozoku0 != "すべて" {
            syozoku0SQL = "='" + syozoku0 + "'"
        }
        var syozokuSQL : String = "IS NOT NULL"
        if syozoku != "すべて" {
            syozokuSQL = "='" + syozoku + "'"
        }
        var kinmuSQL : String = "IS NOT NULL"
        if kinmu != "すべて" {
            kinmuSQL = "='" + kinmu + "'"
        }
        let sql = "SELECT * FROM records where kubun " + kubunSQL + " and syozoku0 " + syozoku0SQL + " and syozoku " + syozokuSQL + " and kinmu " + kinmuSQL + " ORDER BY _id;"
        db.open()
        let results = db.executeQuery(sql, withArgumentsIn: nil)
        while (results?.next())!{
            let _name: String = results!.string(forColumn: "name")
            let _tel: String = results!.string(forColumn: "tel")
            let _mail: String = results!.string(forColumn: "mail")
            let _kubun: String = results!.string(forColumn: "kubun")
            let _syozoku0: String = results!.string(forColumn: "syozoku0")
            let _syozoku: String = results!.string(forColumn: "syozoku")
            let _kinmu: String = results!.string(forColumn: "kinmu")
            resultArray.append([_name, _tel, _mail, _kubun, _syozoku0, _syozoku, _kinmu])
        }
        db.close()
    }*/
}
