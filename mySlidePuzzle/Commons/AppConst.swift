//
//  AppConst.swift
//  mySlidePuzzle
//
//  Created by hiroshings on 2016/01/03.
//  Copyright © 2016年 hiroshings. All rights reserved.
//

import Foundation
import UIKit

class AppConst: UIView {
    
    /*-----------------------
    // MARK: - level -
    ----------------------*/
    // TODO: 15ピースと9ピースのレベルを選択できるようにする
    
    /*-----------------------
    // MARK: - puzzle -
    ----------------------*/
    // bg
    static let bgColor:UIColor = UIColor.rgb(42, g: 55, b: 79)
    
    // frame
    static let xFrame:CGFloat = 300.0 //パズルの横幅
    static let yFrame:CGFloat = 300.0 //パズルの縦幅
    
    // piece
    static let pieceSize:CGFloat = 100.0 //1ピースのサイズ
    static let maxPieces:Int = 9 //ピースの最大数
}
