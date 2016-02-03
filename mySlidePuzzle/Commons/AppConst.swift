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
    let screenBounds = UIScreen.mainScreen().bounds
    let screenSize = UIScreen.mainScreen().bounds.size
    let screenScale = UIScreen.mainScreen().scale
    
    /*-----------------------
    // MARK: - headerMenuSize -
    ----------------------*/
    let statusBar_height: CGFloat = 20.0
    let navbar_height:CGFloat = 44.0
    let header_height:CGFloat = 64.0 // 20+44
    
    /*-----------------------
    // MARK: - level -
    ----------------------*/
    // 15パズルと8パズルのレベルを選択できる
    let piece8 = "8Piece"
    let piece15 = "15Piece"

    
    /*-----------------------
    // MARK: - puzzle -
    ----------------------*/
    // bg
    let bgColor: UIColor = UIColor.rgb(42, g: 55, b: 79)
    
    // frame
    let boardWidth: CGFloat = 300.0 //パズルの横幅
    let boardHeight: CGFloat = 300.0 //パズルの縦幅
    
    // piece
    let pieceSize: CGFloat = 0.0 //1ピースのサイズ
    let maxPieces: Int = 0 //ピースの最大数
    let pieceColumn: Int = 0 //ピースの1列
    
    func initPieceStatus(level: String) -> (maxPieces: Int, pieceColumn: Int, pieceSize: CGFloat) {
        
        switch level {
        case piece8:
            return (9, 3, 100.0)
        case piece15:
            return (16, 4, 75.0)
        default:
            return (9, 3, 100.0)
        }
    }
    
    /*-----------------------
    // MARK: - myPuzzle -
    ----------------------*/
    let myPuzzleViewWidth: CGFloat = 300.0
    let myPuzzleViewHeight: CGFloat = 400.0

}
