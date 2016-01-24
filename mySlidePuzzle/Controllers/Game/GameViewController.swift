//
//  GameViewController.swift
//  mySlidePuzzle
//
//  Created by hiroshings on 2016/01/02.
//  Copyright © 2016年 hiroshings. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    /*-----------------------
    // MARK: - properties -
    ----------------------*/
    
    // ゲーム画面のViewClass
    @IBOutlet var gameView: GameView!
    
    // ゲーム中フラグ
    var gamingFlag = false
    
    // 操作するピース
    var emptyPiece = UIImageView()
    var touchPiece = UIImageView()

    // タッチした座標
    let touch = UITouch()
    var touchLocation_x: CGFloat = 0.0
    var touchLocation_y: CGFloat = 0.0
    
    // ピースの現在座標
    var currentPiecesOffset: [[CGFloat]] = []
    
    // クリアフラグ
    var completeFlag = false
    
    // スコア
    var score = "00:00:00"

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "My Slide Puzzle"
        
        currentPiecesOffset = getCurrentPiecesOffset()
    }
    
    
    /// ピースタッチ時の処理
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if let _ = touches.first {
            for touch in touches {
                
                // カラピースのある座標
                emptyPiece = gameView.gameStageView.viewWithTag(gameView.maxPieces) as! UIImageView
                let emptyLocation_x = emptyPiece.frame.origin.x
                let emptyLocation_y = emptyPiece.frame.origin.y
                
                let touchViewId = touch.view?.tag
                
                if touchViewId == 0 {
                    return
                }
                
                // タッチしたピースを取得
                touchPiece = gameView.gameStageView.viewWithTag(touchViewId!) as! UIImageView
                
                // タッチした座標を取得
                touchLocation_x = touch.locationInView(self.gameView.gameStageView).x
                touchLocation_y = touch.locationInView(self.gameView.gameStageView).y
                
                // ピースを動かせる範囲を判定
                let enablePositons = getEnableMovePositions(emptyLocation_x, e_y: emptyLocation_y, t_x: touchLocation_x, t_y: touchLocation_y)
                
                // ピースの移動
                movePiece(enablePositons.enable_x, enable_y: enablePositons.enable_y, piece: touchPiece)
                
                // ピースの現在位置を取得
                currentPiecesOffset = getCurrentPiecesOffset()
                
                // クリア判定
                completeFlag = checkComplete()
                print(completeFlag)
                
                // クリア判定trueの場合、クリア演出に移行
                if completeFlag == true {
                    showCompleteProduction()
                }
            }
        }
        
        super.touchesBegan(touches, withEvent: event)
    }
    
    
    /*-----------------------
    // MARK: - private -
    ----------------------*/
    
    /**
     ピースの移動できる範囲を取得
     
     - parameters:
        - e_x: カラピースのx座標
        - e_y: カラピースのy座標
        - t_x: タッチしたピースのx座標
        - t_y: タッチしたピースのy座標
     
     - returns:
        - enable_x: ｘ座標に移動できる範囲
        - enable_y: y座標に移動できる範囲
     */
    private func getEnableMovePositions(e_x: CGFloat, e_y: CGFloat, t_x: CGFloat, t_y: CGFloat) -> (enable_x: Int, enable_y: Int) {
        
        let enable_x = (Int(t_x) / Int(gameView.pieceSize)) - (Int(e_x) / Int(gameView.pieceSize))
        let enable_y = (Int(t_y) / Int(gameView.pieceSize)) - (Int(e_y) / Int(gameView.pieceSize))
        
        print("x座標の移動可能範囲" + String(enable_x))
        print("y座標の移動可能範囲" + String(enable_y))
        
        return (enable_x, enable_y)
    }
    
    /**
     ピースの移動
     
     - parameters:
        - enable_x: ｘ座標に移動できる範囲
        - enable_y: y座標に移動できる範囲
        - piece: ピース
     
     - returns: none
     */
    private func movePiece(enable_x: Int, enable_y: Int, piece: UIImageView) {
        
        emptyPiece = gameView.gameStageView.viewWithTag(gameView.maxPieces) as! UIImageView
        
        switch enable_x {

            // ピースを右に移動
            case let x where x < 0:
                
                for _ in x..<0 {
                    
                    emptyPiece.frame.origin.x -= gameView.pieceSize
                    let e_x = emptyPiece.frame.origin.x
                    let e_y = emptyPiece.frame.origin.y
                    
                    for (index, currentOffset) in currentPiecesOffset.enumerate() {
                        
                        let c_x = currentOffset[0]
                        let c_y = currentOffset[1]
                        
                        if e_x == c_x && e_y == c_y {
                            let movePiece = gameView.gameStageView.viewWithTag(index + 1) as! UIImageView
                            movePiece.frame.origin.x += gameView.pieceSize
                        }
                    }
                }
            // ピースを左に移動
            case let x where x > 0:
            
                for _ in 0..<x {
                    
                    emptyPiece.frame.origin.x += gameView.pieceSize
                    let e_x = emptyPiece.frame.origin.x
                    let e_y = emptyPiece.frame.origin.y
                    
                    for (index, currentOffset) in currentPiecesOffset.enumerate() {
                        
                        let c_x = currentOffset[0]
                        let c_y = currentOffset[1]
                        
                        if e_x == c_x && e_y == c_y {
                            let movePiece = gameView.gameStageView.viewWithTag(index + 1) as! UIImageView
                            movePiece.frame.origin.x -= gameView.pieceSize
                        }
                    }
                }
            default:
                break
        }
        
        switch enable_y {
            
            // ピースを上に移動
            case let y where y < 0:
                
                for _ in y..<0 {
                    
                    emptyPiece.frame.origin.y -= gameView.pieceSize
                    let e_x = emptyPiece.frame.origin.x
                    let e_y = emptyPiece.frame.origin.y
                    
                    for (index, currentOffset) in currentPiecesOffset.enumerate() {
                        
                        let c_x = currentOffset[0]
                        let c_y = currentOffset[1]
                        
                        if e_x == c_x && e_y == c_y {
                            let movePiece = gameView.gameStageView.viewWithTag(index + 1) as! UIImageView
                            movePiece.frame.origin.y += gameView.pieceSize
                        }
                    }
                }
            // ピースを下に移動
            case let y where y > 0:
                
                for _ in 0..<y {
                    
                    emptyPiece.frame.origin.y += gameView.pieceSize
                    let e_x = emptyPiece.frame.origin.x
                    let e_y = emptyPiece.frame.origin.y
                    
                    for (index, currentOffset) in currentPiecesOffset.enumerate() {
                        
                        let c_x = currentOffset[0]
                        let c_y = currentOffset[1]
                        
                        if e_x == c_x && e_y == c_y {
                            let movePiece = gameView.gameStageView.viewWithTag(index + 1) as! UIImageView
                            movePiece.frame.origin.y -= gameView.pieceSize
                        }
                    }
                }
            
            default:
                break
        }
    }
    
    /**
     クリア判定
     
     - parameters:
        - none
     
     - returns: クリア判定
     */
    
    // TODO: 冗長な処理。currentの座標とBoard生成時に作った正しい座標配列を比較して合ってないなら、Breakして途中で処理終了する
    private func checkComplete() -> Bool {
        
        var offset_x = CGFloat()
        var offset_y = CGFloat()
        var count: Int = 0
        var piece = UIImageView()
        
        var completeFlag_x = false
        var completeFlag_y = false
        var completeCount:Int = 0
        
        for (var i = 0; i < gameView.pieceColumn; i++) {
            offset_y = CGFloat(i) * gameView.pieceSize
            
            for (var j = 0; j < gameView.pieceColumn; j++) {
                
                offset_x = CGFloat(j) * gameView.pieceSize
                count++
                
                // ピースの現在位置を取得
                piece = gameView.gameStageView.viewWithTag(count) as! UIImageView
                
                let pieceOffset_x = piece.frame.origin.x
                let pieceOffset_y = piece.frame.origin.y
                
                // あるべき位置と実際の位置が合っていたらtrue, 合っていなければfalse
                completeFlag_x = offset_x == pieceOffset_x ? true : false
                completeFlag_y = offset_y == pieceOffset_y ? true : false
                
                print(completeFlag_x)
                print(completeFlag_y)
                
                // x座標, y座標ともに一致していればコンプカウントを追加
                if completeFlag_x == true && completeFlag_y == true {
                    completeCount++
                }
            }
        }
        
        // コンプカウントがMAXだった場合、クリアしたことになる
        if completeCount == gameView.maxPieces {
            completeFlag = true
        }
        
        return completeFlag
    }
    
    /**
     クリア演出
     
     - parameters: 
        - none
     
     - returns: none
     */
    private func showCompleteProduction() {
        
        // ピースの操作を無効にする
        toggleUserInteractionEnabled(false)
        
        // Complete!!メッセージをフェードイン        
        UIView.animateWithDuration(0.4, animations: {self.gameView.compMessage.alpha = 1})
        
        // ピースの番号・黒マスを排除
        for id in gameView.ids {
            let piece = gameView.gameStageView.viewWithTag(id) as! UIImageView
            let subViews = piece.subviews
            for subView in subViews {
                subView.removeFromSuperview()
            }
        }
    }
    
    /**
     ピースの操作の有効・無効を切り替える
     
     - parameters:
        - flag: 操作可能flag
     
     - returns: none
     */
    private func toggleUserInteractionEnabled(flag: Bool) {
        
        // ピースの操作の有効・無効を切り替える
        for id in gameView.ids {
            let piece = gameView.gameStageView.viewWithTag(id) as! UIImageView
            piece.userInteractionEnabled = flag
        }
    }
    
    private func isPossibleClear(var ids: [Int]) {
        
        var cnt = 0
        
        // バブルソート
        for (var i = 0; i < ids.count; i++) {
            
            // jよりiの方が数字が大きい場合、スワップする
            for (var j = i + 1; j < ids.count; j++) {
                
                if ids[j] < ids[i] {
                    let tmp: Int = ids[i]
                    ids[i] = ids[j]
                    ids[j] = tmp
                    
                    cnt++
                }
            }
        }
        
        print("count" + String(cnt))
        print("ids" + String(ids))
    }
    
    
    /**
     現在のピースのx座標, y座標を取得
     
     - parameters:
        - none
     
     - returns: ピースごとの現在座標を格納した配列
     */
    private func getCurrentPiecesOffset() -> [[CGFloat]] {
        var piecesOffset: [[CGFloat]] = []
        
        for i in 0..<gameView.maxPieces {
            
            var offset: [CGFloat] = []
            let piece = gameView.gameStageView.viewWithTag(i + 1) as! UIImageView
            let x = piece.frame.origin.x
            let y = piece.frame.origin.y
            offset = [x, y]
            piecesOffset.append(offset)
        }
        
        return piecesOffset
    }
}