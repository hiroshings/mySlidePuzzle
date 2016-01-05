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
    var baseImage = UIImageView()
    
    var pieceImage = UIImageView()
    var id: Int = 0
    var ids:Array<Int> = []
    
    // タッチした座標
    var touchLocation_x: CGFloat = 0.0
    var touchLocation_y: CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "My Slide Puzzle"
        gameStageView.backgroundColor = AppConst.bgColor
        
        // デリゲート
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        baseImage = appDelegate.baseImage
        
        
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
                    emptyPiece.tag = AppConst.maxPieces
                    pieceImage.addSubview(emptyPiece)
                }
                
                pieceImage.addSubview(pieceId)
                gameStageView.addSubview(pieceImage)
            }
        }
        
        let swapedIds: Array<Int> = swapPieces(ids)
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
                
                // 最終マスは固定のため -2する
                from = Int(arc4random_uniform(UInt32(AppConst.maxPieces - 2))) + 1
                to = Int(arc4random_uniform(UInt32(AppConst.maxPieces - 2))) + 1
                
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
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if let touch = touches.first {
            for touch in touches {
                
                // カラピースのある座標
                let emptyPiece = gameStageView.viewWithTag(AppConst.maxPieces) as! UIImageView
                let emptyLocation_x = CGRectGetMidX(emptyPiece.frame)
                let emptyLocation_y = CGRectGetMidY(emptyPiece.frame)
                
                print(emptyLocation_x)
                print(emptyLocation_y)
                
                // タッチした座標を取得
                touchLocation_x = touch.locationInView(self.gameStageView).x
                touchLocation_y = touch.locationInView(self.gameStageView).y

                print(touchLocation_x)
                print(touchLocation_y)
                
                var flags = getEnableMoveFlag(emptyLocation_x, emptyLocation_y: emptyLocation_y, touchLocation_x: touchLocation_x, touchLocation_y: touchLocation_y)
                
                print(flags.enable_x)
                print(flags.enable_y)
            }
        }
        
        super.touchesBegan(touches, withEvent: event)
    }
    
    func getEnableMoveFlag(emptyLocation_x: CGFloat, emptyLocation_y: CGFloat, touchLocation_x: CGFloat, touchLocation_y: CGFloat) -> (enable_x: Int, enable_y: Int) {
        
        var enable_x: Int = 0
        var enable_y: Int = 0
        
        enable_x = Int((touchLocation_x / emptyLocation_x))
        enable_y = Int((touchLocation_y / emptyLocation_y))
        
        return (enable_x, enable_y)
    }

}