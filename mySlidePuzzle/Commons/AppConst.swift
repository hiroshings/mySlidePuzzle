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
    // MARK: - screenSize -
    ----------------------*/
    static let screenBounds = UIScreen .mainScreen().bounds
    static let screenSize = screenBounds.size
    static let screenScale = UIScreen.mainScreen().scale
    
    /*-----------------------
    // MARK: - headerMenuSize -
    ----------------------*/
    static let statusBar_height: CGFloat = 20.0
    static let navbar_height:CGFloat = 44.0
    static let header_height:CGFloat = 64.0 // 20+44
    
    /*-----------------------
    // MARK: - level -
    ----------------------*/
    // TODO: 15ピースと9ピースのレベルを選択できるようにする
    
    /*-----------------------
    // MARK: - puzzle -
    ----------------------*/
    // bg
    static let bgColor: UIColor = UIColor.rgb(42, g: 55, b: 79)
    
    // frame
    static let boardWidth: CGFloat = 300.0 //パズルの横幅
    static let boardHeight: CGFloat = 300.0 //パズルの縦幅
    
    // piece
    static let pieceSize: CGFloat = 100.0 //1ピースのサイズ
    static let maxPieces: Int = 9 //ピースの最大数
    static let pieceColumn: Int = 3 //ピースの1列
}
