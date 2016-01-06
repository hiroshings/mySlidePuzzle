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
    
    @IBOutlet weak var gameStageView: UIView!
    @IBOutlet weak var compMessage: UILabel!
    
    // 元画像
    var baseImage = UIImageView()
    
    // ゲーム中フラグ
    var gamingFlag = false
    
    // ピース
    var pieceImage = UIImageView()
    var id: Int = 0
    var ids: Array<Int> = []
    var emptyPiece = UIImageView()
    var touchPiece = UIImageView()

    // タッチした座標
    let touch = UITouch()
    var touchLocation_x: CGFloat = 0.0
    var touchLocation_y: CGFloat = 0.0
    
    // クリアフラグ
    var completeFlag = false

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "My Slide Puzzle"
        
        // デリゲート
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        baseImage = appDelegate.baseImage
        
        // complete!!文字を非表示にする
        compMessage.alpha = 0.0
        
        
        // パズルの初期化
        var offset_x: CGFloat = pieceImage.bounds.origin.x
        var offset_y: CGFloat = pieceImage.bounds.origin.y
        
        for (var i = 0; i < AppConst.pieceColumn; i++) {
            offset_y = CGFloat(i) * AppConst.pieceSize
            
            for (var j = 0; j < AppConst.pieceColumn; j++) {
                
                // ピース番号を生成
                id++
                let pieceId: UILabel = UILabel(frame: CGRectMake(0, 0, AppConst.pieceSize, AppConst.pieceSize))
                pieceId.text = String(id)
                pieceId.textAlignment = NSTextAlignment.Center
                pieceId.textColor = UIColor.whiteColor()
                
                // ピースの生成
                offset_x = CGFloat(j) * AppConst.pieceSize

                let cropedImage = cropImage(baseImage.image!, x: offset_x, y: offset_y, w: AppConst.pieceSize, h: AppConst.pieceSize)
                pieceImage = UIImageView(frame: CGRectMake(offset_x, offset_y, AppConst.pieceSize, AppConst.pieceSize))
                pieceImage.image = cropedImage
                pieceImage.tag = id
                pieceImage.userInteractionEnabled = true
                ids.append(pieceImage.tag)
                
                // 最後のピースを黒く塗りつぶす
                if id == AppConst.maxPieces {
                    let emptyPiece = UIView(frame: CGRectMake(0, 0, AppConst.pieceSize, AppConst.pieceSize))
                    emptyPiece.backgroundColor = UIColor.blackColor()
                    pieceImage.addSubview(emptyPiece)
                }
                
                pieceImage.addSubview(pieceId)
                gameStageView.addSubview(pieceImage)
            }
        }
        
        // ピースをスワップする
        let swapedIds: Array<Int> = swapPieces(ids)
        // スワップしたピースの表示
        showPieces(swapedIds, gameStageView: gameStageView)
    }
    
    
    /*-----------------------
    // MARK: - private -
    ----------------------*/

    /**
    画像のクリッピング
    - Returns: クリッピングした画像
    */
    func cropImage(image :UIImage, x:CGFloat, y:CGFloat, w:CGFloat, h:CGFloat) ->UIImage {
        
        let size: CGSize = CGSize(width: AppConst.boardWidth, height: AppConst.boardHeight)
        UIGraphicsBeginImageContext(size)
        image.drawInRect(CGRectMake(0, 0, size.width, size.height))
        
        let resizeImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let cropRect  = CGRectMake(
            CGFloat(x),
            CGFloat(y),
            CGFloat(w),
            CGFloat(h)
        )
        let cropRef   = CGImageCreateWithImageInRect(resizeImage.CGImage, cropRect)
        let cropImage = UIImage(CGImage: cropRef!)
        
        return cropImage
    }
    
    /**
     ピースのスワップ処理
     -
     */
    func swapPieces(var ids: Array<Int>) -> Array<Int> {
        
        var from = 0;
        var to = 0;

        for (var i = 0; i < 100; i++) {
            for (var i = 0; i < 2; i++) {
                
                // TODO: 解法がない場合がある
                from = Int(arc4random_uniform(UInt32(AppConst.maxPieces)))
                to = Int(arc4random_uniform(UInt32(AppConst.maxPieces)))
                
                print(from)
                print(to)
                
                if from != to {
                    swap(&ids[from], &ids[to])
                }
            }
        }
        
        return ids
    }
    
    /**
     シャッフルしたピースの再配置
     - 
     */
    func showPieces(ids: Array<Int>, gameStageView: UIView) {
        
        var piece = UIImageView()
        var offset_x: CGFloat = pieceImage.bounds.origin.x
        var offset_y: CGFloat = pieceImage.bounds.origin.y
        var count: Int = 0
        var tag: Int = 0
        
        for (var i = 0; i < AppConst.pieceColumn; i++) {
            offset_y = CGFloat(i) * AppConst.pieceSize
            
            for (var j = 0; j < AppConst.pieceColumn; j++) {
                offset_x = CGFloat(j) * AppConst.pieceSize
                count++
                
                tag = ids[count - 1]
                piece = gameStageView.viewWithTag(tag) as! UIImageView
                
                piece.frame = CGRectMake(offset_x, offset_y, AppConst.pieceSize, AppConst.pieceSize)
                gameStageView.addSubview(piece)
            }
        }
    }
    
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if let _ = touches.first {
            for touch in touches {
                
                // カラピースのある座標
                emptyPiece = gameStageView.viewWithTag(AppConst.maxPieces) as! UIImageView
                let emptyLocation_x = emptyPiece.frame.origin.x
                let emptyLocation_y = emptyPiece.frame.origin.y
                
                print("emptyLocation_x" + String(emptyLocation_x))
                print("emptyLocation_y" + String(emptyLocation_y))

                
                // タッチした座標を取得
                let touchViewId = touch.view?.tag
                
                if touchViewId == 0 {
                    return
                }
                
                touchPiece = gameStageView.viewWithTag(touchViewId!) as! UIImageView

                touchLocation_x = touch.locationInView(self.gameStageView).x
                touchLocation_y = touch.locationInView(self.gameStageView).y
                
                print("touchLocation_x" + String(touchLocation_x))
                print("touchLocation_y" + String(touchLocation_y))
                
                let enablePositons = getEnableMovePiece(emptyLocation_x, e_y: emptyLocation_y, t_x: touchLocation_x, t_y: touchLocation_y)
                
                // ピースの移動
                movePiece(enablePositons.enable_x, enable_y: enablePositons.enable_y, piece: touchPiece)
                
                // クリア判定
                completeFlag = checkComplete()
                print(completeFlag)
                
                // クリア判定trueの場合、クリア演出に移行
                if completeFlag == true {
                    showCompleteProduction()
                }
            }
        }
        
        super.touchesEnded(touches, withEvent: event)
    }
    
    
    func getEnableMovePiece(e_x: CGFloat, e_y: CGFloat, t_x: CGFloat, t_y: CGFloat) -> (enable_x: Int, enable_y: Int) {
        
        let enable_x = (Int(t_x) / Int(AppConst.pieceSize)) - (Int(e_x) / Int(AppConst.pieceSize))
        let enable_y = (Int(t_y) / Int(AppConst.pieceSize)) - (Int(e_y) / Int(AppConst.pieceSize))
        
        print("x座標の移動可能範囲" + String(enable_x))
        print("y座標の移動可能範囲" + String(enable_y))
        
        return (enable_x, enable_y)
    }
    
    
    func movePiece(enable_x: Int, enable_y: Int, piece: UIImageView) {
        
        let enablePositons = (enable_x, enable_y) // x座標に動かせる距離, y座標に動かせる距離
        
        switch enablePositons {
            // ピースを下に移動
            case (0, -1):
                emptyPiece.frame.origin.y -= AppConst.pieceSize
                piece.frame.origin.y += AppConst.pieceSize
                break
            // ピースを上に移動
            case (0, 1):
                emptyPiece.frame.origin.y += AppConst.pieceSize
                piece.frame.origin.y -= AppConst.pieceSize
                break
            // ピースを左に移動
            case (-1, 0):
                emptyPiece.frame.origin.x -= AppConst.pieceSize
                piece.frame.origin.x += AppConst.pieceSize
                break
            // ピースを右に移動
            case (1, 0):
                emptyPiece.frame.origin.x += AppConst.pieceSize
                piece.frame.origin.x -= AppConst.pieceSize
            default:
                break
        }
    }
    
    
    
    func checkComplete() -> Bool {
        
        var offset_x = CGFloat()
        var offset_y = CGFloat()
        var count: Int = 0
        var piece = UIImageView()
        
        var completeFlag_x = false
        var completeFlag_y = false
        var completeCount:Int = 0
        
        for (var i = 0; i < AppConst.pieceColumn; i++) {
            offset_y = CGFloat(i) * AppConst.pieceSize
            
            for (var j = 0; j < AppConst.pieceColumn; j++) {
                
                offset_x = CGFloat(j) * AppConst.pieceSize
                
                count++
                piece = gameStageView.viewWithTag(count) as! UIImageView
                
                let pieceOffset_x = piece.frame.origin.x
                let pieceOffset_y = piece.frame.origin.y
                
                print("offset_x" + String(offset_x))
                print("offset_y" + String(offset_y))
                
                print("pieceOffset_x" + String(pieceOffset_x))
                print("pieceOffset_y" + String(pieceOffset_y))
                
                completeFlag_x = offset_x == pieceOffset_x ? true : false
                completeFlag_y = offset_y == pieceOffset_y ? true : false
                
                print(completeFlag_x)
                print(completeFlag_y)
                
                if completeFlag_x == true && completeFlag_y == true {
                    completeCount++
                }
            }
        }
        
        if completeCount == AppConst.maxPieces {
            completeFlag = true
        }
        
        return completeFlag
    }
    
    
    func showCompleteProduction() {
        
        // ピースの操作を無効にする
        toggleUserInteractionEnabled(false)
        
        // Complete!!メッセージをフェードイン        
        UIView.animateWithDuration(0.4, animations: {self.compMessage.alpha = 1})
        
        // ピースの番号・黒マスを排除
        for id in ids {
            let piece = gameStageView.viewWithTag(id) as! UIImageView
            let subViews = piece.subviews
            for subView in subViews {
                subView.removeFromSuperview()
            }
        }
    }
    
    
    func toggleUserInteractionEnabled(flag: Bool) {
        
        // ピースの操作の有効・無効を切り替える
        for id in ids {
            let piece = gameStageView.viewWithTag(id) as! UIImageView
            piece.userInteractionEnabled = flag
        }
    }

}