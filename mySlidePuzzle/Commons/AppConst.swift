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
    static let screenBounds = UIScreen.mainScreen().bounds
    static let screenSize = UIScreen.mainScreen().bounds.size
    static let screenScale = UIScreen.mainScreen().scale
    
    /*-----------------------
    // MARK: - headerMenuSize -
    ----------------------*/
    static let statusBar_height: CGFloat = 20.0
    static let navbar_height:CGFloat = 44.0
    static let header_height:CGFloat = 64.0 // 20+44
    
    /*-----------------------
    // MARK: - puzzle -
    ----------------------*/
    // bg
    static let bgColor: UIColor = UIColor.rgb(42, g: 55, b: 79)
    
    // frame
    static let boardWidth: CGFloat = 300.0 //パズルの横幅
    static let boardHeight: CGFloat = 300.0 //パズルの縦幅
    
    // piece
    static let pieceSize: CGFloat = 0.0 //1ピースのサイズ
    static let maxPieces: Int = 0 //ピースの最大数
    static let pieceColumn: Int = 0 //ピースの1列
    
    /*-----------------------
    // MARK: - myPuzzle -
    ----------------------*/
    static let myPuzzleViewWidth: CGFloat = 300.0
    static let myPuzzleViewHeight: CGFloat = 400.0
    
    /*-----------------------
    // MARK: - level -
    ----------------------*/
    // パズルのレベル
    static let piece8 = "8Piece"
    static let piece15 = "15Piece"
    
    
    /**
    レベルに応じたパズルのステータスを設定する
    
    - parameters:
     - level: パズルのレベル
    
    - returns: レベルに応じたパズルの設定
     - maxPieces: パズルの最大ピース
     - pieceColumn: パズルの列数
     - pieceSize: ピースの大きさ
     
    */
    static func initPieceStatus(level: String) -> (maxPieces: Int, pieceColumn: Int, pieceSize: CGFloat) {
        
        let piece8 = "8Piece"
        let piece15 = "15Piece"
        
        switch level {
        case piece8:
            return (9, 3, 100.0)
        case piece15:
            return (16, 4, 75.0)
        default:
            return (9, 3, 100.0)
        }
    }

}
