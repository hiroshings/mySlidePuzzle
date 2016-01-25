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
    
    // タイマーカウント
    var count = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "My Slide Puzzle"
        
        toggleUserInteractionEnabled(false)
        
        currentPiecesOffset = getCurrentPiecesOffset()
        
        gameView.startBtn.addTarget(self, action: "onTapStartBtn:", forControlEvents: .TouchUpInside)
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
                movePiece(enablePositons.enable_x, enable_y: enablePositons.enable_y)
                
                // ピースの現在位置を取得
                currentPiecesOffset = []
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
     
     - returns: none
     */
    private func movePiece(enable_x: Int, enable_y: Int) {
        
        emptyPiece = gameView.gameStageView.viewWithTag(gameView.maxPieces) as! UIImageView
        
        switch (enable_x, enable_y) {

            // ピースを右に移動
            case (let x, let y) where x < 0 && y == 0:
            
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
            case (let x, let y) where x > 0 && y == 0:
            
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
        
        switch (enable_x, enable_y) {
            
            // ピースを上に移動
            case (let x, let y) where x == 0 && y < 0:
                
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
            case (let x, let y) where x == 0 && y > 0:
                
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
    private func checkComplete() -> Bool {
        
        for i in 0..<gameView.maxPieces {
            
            // デフォルトのoffsetと現在のoffsetが一致していなければクリアflagがバッキバキ
            if gameView.defaultPieceOffset[i] != currentPiecesOffset[i] {
                completeFlag = false
                break
            } else {
                completeFlag = true
            }
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
        
        for i in 0..<gameView.maxPieces {
            
            var offset: [CGFloat] = []
            let piece = gameView.gameStageView.viewWithTag(i + 1) as! UIImageView
            let x = piece.frame.origin.x
            let y = piece.frame.origin.y
            offset = [x, y]
            currentPiecesOffset.append(offset)
        }
        
        return currentPiecesOffset
    }
    
    func countUpTimer() {
        
        count++
        
        let ms = count % 100
        let s = (count - ms) / 100 % 60
        let m = (count - s - ms) / 6000 % 3600
        
        gameView.timer.text = String(format: "%02d:%02d:%02d", arguments: [m, s, ms])
    }
    
    func stopTimer() {
        
    }
    
    func onTapStartBtn(sender: AnyObject) {
        
        // パズルの操作を可能にする
        toggleUserInteractionEnabled(true)
        
        // タイマーカウントを発火させる
        NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: "countUpTimer", userInfo: nil, repeats: true)
    }
}