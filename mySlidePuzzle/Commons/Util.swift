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