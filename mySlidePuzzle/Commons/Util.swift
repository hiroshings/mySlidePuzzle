//
//  Util.swift
//  mySlidePuzzle
//
//  Created by hiroshings on 2016/01/03.
//  Copyright © 2016年 hiroshings. All rights reserved.
//

import Foundation
import UIKit

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

extension UIScrollView {
    
    override public func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        superview?.touchesBegan(touches, withEvent: event)
    }
}

public class CurrentTime {
    
    let now = NSDate()
    let dataFormatter = NSDateFormatter()
    
    /// 現在時刻を返す
    internal func getCurrentTime() -> String {
        
        dataFormatter.locale = NSLocale(localeIdentifier: "ja_JP")
        dataFormatter.dateFormat = "yyyyMMddHHmmss"
        return dataFormatter.stringFromDate(now)
    }
}

public class CurrentTimeFormatted: CurrentTime {
    
    override internal func getCurrentTime() -> String {
        
        dataFormatter.locale = NSLocale(localeIdentifier: "ja_JP")
        dataFormatter.dateFormat = "yyyy/MM/dd/HH:mm:ss"
        return dataFormatter.stringFromDate(now)
    }
}

/*-----------------------
// MARK: - directory -
----------------------*/

public class PuzzleDirectory {
    
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
        
        
        guard let dir = getSubDirectory("photo").path else {
            return nil
        }
        
        do {
            // ファイル名が格納された配列を返す
            let pngImages = try fileManager.contentsOfDirectoryAtPath(dir)
            print(pngImages)
            return pngImages
        }
        catch {
            // ファイル名がない場合、nilを返す
            return nil
        }
    }

}