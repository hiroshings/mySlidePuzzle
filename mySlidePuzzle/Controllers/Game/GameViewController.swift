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
    
    // パズル名
    var puzzleImageName = ""
    
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
    
    // タイマー
    var timer = NSTimer()
    var clearTime: Int = 0
    
    let defaults = NSUserDefaults.standardUserDefaults()
    let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "My Slide Puzzle"
        
        // ハイスコアの初期化
        puzzleImageName = appDelegate.puzzleImageName
        
        if let highScore = defaults.objectForKey(puzzleImageName) {
            
            print("highScore")
            print(highScore as! Int)
            let formatedTime = Util.formatTime(highScore as! Int)
            gameView.highScore.text = formatedTime
        }
        
        // パズルの操作を可能にする
        toggleUserInteractionEnabled(true)
        
        // タイマーカウントを発火させる
        timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: "countUpTimer:", userInfo: nil, repeats: true)
        
        // ゲーム開始時のピースの初期位置を取得
        currentPiecesOffset = getCurrentPiecesOffset()
    }
    
    
    /// ピースタッチ時の処理
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if let _ = touches.first {
            for touch in touches {
                
                // カラピースのある座標
                emptyPiece = gameView.gameStageView.viewWithTag(gameView.maxPieces) as! UIImageView
                let emptyPiece_x = emptyPiece.frame.origin.x
                let emptyPiece_y = emptyPiece.frame.origin.y
                
                let touchViewId = touch.view?.tag
                
                if touchViewId == 0 {
                    return
                }
                
                // タッチしたピース
                touchPiece = gameView.gameStageView.viewWithTag(touchViewId!) as! UIImageView
                
                // タッチしたピースの座標
                let touchPiece_x = touchPiece.frame.origin.x
                let touchPiece_y = touchPiece.frame.origin.y
                
                // ピースを動かせる範囲を判定
                let enablePositons = getEnableMovePositions(emptyPiece_x, e_y: emptyPiece_y, t_x: touchPiece_x, t_y: touchPiece_y)
                
                // ピースの移動
                movePiece(enablePositons.enable_x, enable_y: enablePositons.enable_y)
                
                // ピースの現在位置を取得
                currentPiecesOffset = getCurrentPiecesOffset()
                
                // クリア判定
                completeFlag = checkComplete()
                
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

            // タッチしたピースを右に移動
            case (let x, let y) where x < 0 && y == 0:
                print("move right")
                
                for _ in x..<0 {
                    
                    let emptyPiece_x = emptyPiece.frame.origin.x
                    let emptyPiece_y = emptyPiece.frame.origin.y
                    
                    for (index, currentOffset) in currentPiecesOffset.enumerate() {
                        
                        let currentPiece_x = currentOffset[0]
                        let currentPiece_y = currentOffset[1]
                        
                        if emptyPiece_x - gameView.pieceSize == currentPiece_x && emptyPiece_y == currentPiece_y {
                            
                            let movePiece = gameView.gameStageView.viewWithTag(index + 1) as! UIImageView
                            
                            let fromValue = movePiece.center.x
                            let toValue = fromValue + gameView.pieceSize
                            
                            addAnimation(movePiece, fromValue: fromValue, toValue: toValue, pos: "X")
                            break
                        }
                    }
                    
                    emptyPiece.frame.origin.x -= gameView.pieceSize
                }

            // タッチしたピースを左に移動
            case (let x, let y) where x > 0 && y == 0:
                print("move left")

                for _ in 0..<x {
                    
                    let emptyPiece_x = emptyPiece.frame.origin.x
                    let emptyPiece_y = emptyPiece.frame.origin.y
                    
                    for (index, currentOffset) in currentPiecesOffset.enumerate() {
                        
                        let currentPiece_x = currentOffset[0]
                        let currentPiece_y = currentOffset[1]
                        
                        if emptyPiece_x + gameView.pieceSize == currentPiece_x && emptyPiece_y == currentPiece_y {
                            
                            let movePiece = gameView.gameStageView.viewWithTag(index + 1) as! UIImageView
                            
                            let fromValue = movePiece.center.x
                            let toValue = fromValue - gameView.pieceSize
                            
                            addAnimation(movePiece, fromValue: fromValue, toValue: toValue, pos: "X")
                            break
                        }
                    }
                    
                    emptyPiece.frame.origin.x += gameView.pieceSize
                }
            
            default:
                break
        }
        
        switch (enable_x, enable_y) {
            
            // タッチしたピースを上に移動
            case (let x, let y) where x == 0 && y < 0:
                print("move top")
                
                for _ in y..<0 {
                    
                    let emptyPiece_x = emptyPiece.frame.origin.x
                    let emptyPiece_y = emptyPiece.frame.origin.y
                    
                    for (index, currentOffset) in currentPiecesOffset.enumerate() {
                        
                        let currentPiece_x = currentOffset[0]
                        let currentPiece_y = currentOffset[1]
                        
                        if emptyPiece_x == currentPiece_x && emptyPiece_y - gameView.pieceSize == currentPiece_y {
                            
                            let movePiece = gameView.gameStageView.viewWithTag(index + 1) as! UIImageView
                            
                            let fromValue = movePiece.center.y
                            let toValue = fromValue + gameView.pieceSize
                            
                            addAnimation(movePiece, fromValue: fromValue, toValue: toValue, pos: "Y")
                            break
                        }
                    }
                    
                    emptyPiece.frame.origin.y -= gameView.pieceSize
                }
            
            // タッチしたピースを下に移動
            case (let x, let y) where x == 0 && y > 0:
                print("move bottom")
                
                for _ in 0..<y {
                    
                    let emptyPiece_x = emptyPiece.frame.origin.x
                    let emptyPiece_y = emptyPiece.frame.origin.y
                    
                    for (index, currentOffset) in currentPiecesOffset.enumerate() {
                        
                        let currentPiece_x = currentOffset[0]
                        let currentPiece_y = currentOffset[1]
                        
                        if emptyPiece_x == currentPiece_x && emptyPiece_y + gameView.pieceSize == currentPiece_y {
                            
                            let movePiece = gameView.gameStageView.viewWithTag(index + 1) as! UIImageView
                            
                            let fromValue = movePiece.center.y
                            let toValue = fromValue - gameView.pieceSize
                            
                            addAnimation(movePiece, fromValue: fromValue, toValue: toValue, pos: "Y")
                            break
                        }
                    }
                    
                    emptyPiece.frame.origin.y += gameView.pieceSize
                }
            
            default:
                break
        }
    }
    
    /**
     ピースの移動アニメーション用ヘルパーメソッド
     
     - parameters:
        - targetView: アニメさせる対象のview
        - fromValue: アニメの開始位置
        - toValue: アニメの目標位置
     
     - returns: none
     */
    private func addAnimation(targetView: UIView, fromValue: CGFloat, toValue: CGFloat, pos: String) {
        
        let anim = POPSpringAnimation()
        anim.property = POPAnimatableProperty.propertyWithName(kPOPLayerPosition + pos) as! POPAnimatableProperty
        anim.springSpeed = 20
        
        anim.fromValue = fromValue
        anim.toValue = toValue
        
        targetView.layer.pop_addAnimation(anim, forKey: "slide")
        anim.completionBlock = {(anim, finished) in
            
            self.updatePieces()
        }
    }
    
    /**
     ピース移動アニメ終了後、ピースの状態をアップデートする
     
     - parameters:
        - none
     
     - returns: none
     */
    private func updatePieces() {
        
        // ピースの現在位置を取得
        currentPiecesOffset = self.getCurrentPiecesOffset()
        
        // クリア判定
        completeFlag = self.checkComplete()
        
        // クリア判定trueの場合、クリア演出に移行
        if completeFlag == true {
            showCompleteProduction()
        }
    }
    
    /**
     現在のピースのx座標, y座標を取得
     
     - parameters:
        - none
     
     - returns: ピースごとの現在座標を格納した配列
     */
    private func getCurrentPiecesOffset() -> [[CGFloat]] {
        
        currentPiecesOffset = []
        
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
        
        // タイマー停止
        timer.invalidate()
        
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
        
        // タイムの更新
        puzzleImageName = appDelegate.puzzleImageName
        updateClearTime(puzzleImageName)
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
    
    /**
     タイマーのカウントアップ
     
     - parameters:
        - none
     
     - returns: none
     */
    func countUpTimer(timerCount: NSTimer) {
        
        clearTime++
        let formatedTime = Util.formatTime(clearTime)
        
        gameView.timer.text = formatedTime
    }
    
    /**
     最高記録が出たら、NSUserDefaultsに格納されたハイスコアをアップデートする
     
     - parameters:
        - none
     
     - returns: none
     */
    private func updateClearTime(puzzleImageName: String) {
        
        print("puzzle名は..")
        print(puzzleImageName)
        
        if let highScore = defaults.objectForKey(puzzleImageName) {
            
            if clearTime < highScore as! Int {
                defaults.setInteger(clearTime, forKey: puzzleImageName)
                let formatedTime = Util.formatTime(clearTime)
                gameView.highScore.text = formatedTime
            }
        } else {
            // highScoreがnilの場合、初回なのでそのままclearTimeをhighScoreにする
            defaults.setInteger(clearTime, forKey: puzzleImageName)
            
            let formatedTime = Util.formatTime(clearTime)
            print(formatedTime)
            gameView.highScore.text = formatedTime
        }
        
    }
}