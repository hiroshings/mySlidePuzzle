//
//  Util.swift
//  mySlidePuzzle
//
//  Created by hiroshings on 2016/01/03.
//  Copyright © 2016年 hiroshings. All rights reserved.
//

import Foundation
import UIKit

class Util {
    /*-----------------------
    // MARK: - time -
    ----------------------*/
    
    /// 現在時刻を返す
    func getCurrentTime() -> String {
        
        let now = NSDate()
        let dataFormatter = NSDateFormatter()
        
        dataFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        dataFormatter.dateFormat = "yyyyMMddhhmmss"
        return dataFormatter.stringFromDate(now)
    }
    
    /**
     タイマー表示を整形する
     
     - parameters:
     - originTime: 整形元のタイムカウント
     
     - returns: none
     */
    func formatTime(originTimeCount: Int) -> String {
        
        let ms = originTimeCount % 100
        let s = (originTimeCount - ms) / 100 % 60
        let m = (originTimeCount - s - ms) / 6000 % 3600
        
        let formatedTime = String(format: "%02d:%02d:%02d", arguments: [m, s, ms])
        return formatedTime
    }
    
    /*-----------------------
    // MARK: - directory -
    ----------------------*/

    let fileManager = NSFileManager.defaultManager()
    let defaults = NSUserDefaults.standardUserDefaults()
    
    
    /**
     ローカルストレージのRootディレクトリを取得
     
     - parameters:
     - none
     
     - returns: ディレクトリまでのパス
     */
    func getRootDirectory() -> NSURL {
        
        // NSURL型でルートディレクトリの取得
        let url = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
        return url
    }
    
    /**
     ローカルストレージのSubディレクトリを取得
     
     - parameters:
     - subDirName: 参照するディレクトリ名
     
     - returns: ディレクトリまでのパス
     */
    func getSubDirectory(subDirName: String) -> NSURL {
        
        // NSURL型でルートディレクトリの取得
        let url = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
        
        // ディレクトリを参照
        let dirUrl = url.URLByAppendingPathComponent(subDirName)
        
        return dirUrl
    }
    
    /**
     ローカルストレージからファイル名を取得
     
     - parameters:
     - none
     
     - returns: ローカルストレージのpngファイル名
     */
    func getImageDataNames() -> Array<String>? {
        
        
        guard let dir = getSubDirectory("image").path else {
            return nil
        }
        
        do {
            // ファイル名が格納された配列を返す
            let pngImages = try fileManager.contentsOfDirectoryAtPath(dir)
            print("pngImages" + String(pngImages))
            return pngImages
        }
        catch {
            // ファイル名がない場合、nilを返す
            return nil
        }
    }
}

/// RGB, RGBA値を返すようUIColorを拡張
extension UIColor {

    class func rgb(r:CGFloat, g:CGFloat, b:CGFloat) -> UIColor{
        return rgba(r, g: g, b: b, a: 1.0)
    }
    
    class func rgba(r:CGFloat, g:CGFloat, b:CGFloat, a:CGFloat) -> UIColor{
        
        let denominator:CGFloat = 255.0
        
        let red =  r/denominator
        let green = g/denominator
        let blue = b/denominator
        
        let color = UIColor(red: red, green: green, blue: blue, alpha: a)
        return color
    }
}