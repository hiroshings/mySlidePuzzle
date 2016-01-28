    //
//  GameView.swift
//  mySlidePuzzle
//
//  Created by 坂本 浩 on 2016/01/18.
//  Copyright © 2016年 hiroshings. All rights reserved.
//

import UIKit

@IBDesignable
class GameView: UIView {

    /*-----------------------
    // MARK: - properties -
    ----------------------*/
    
    @IBOutlet weak var gameStageView: UIView!
    @IBOutlet weak var gameStageBgView: UIView!
    @IBOutlet weak var compMessage: UILabel!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var timer: UILabel!
    @IBOutlet weak var startBtn: UIButton!
    
    var baseImage = UIImageView()
    var bgImage = UIImageView()
    
    // ピース
    var pieceImage = UIImageView()
    var id: Int = 0
    var ids: Array<Int> = []
    var emptyPiece = UIImageView()
    var touchPiece = UIImageView()
    var maxPieces: Int = 0
    var pieceColumn: Int = 0
    var pieceSize: CGFloat = 0
    
    // レベル
    var level = ""
    
    let defaults = NSUserDefaults()
    let const = AppConst()
    
    // ピースごとの座標を格納する配列
    var defaultPieceOffset: [[CGFloat]] = []
    
    // タイマー
    var count: Int = 0
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)

    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // xibからカスタムviewをロードする
        let nib = UINib(nibName: "GameView", bundle: nil)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        
        addSubview(view)
        
        // デリゲート
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        baseImage = appDelegate.baseImage
        bgImage = appDelegate.bgImage
    
        // complete!!文字を非表示にする
        compMessage.alpha = 0.0
        
        // ボードの枠線に影を付ける
        gameStageBgView.layer.shadowColor = UIColor.blackColor().CGColor
        gameStageBgView.layer.shadowOpacity = 0.4
        gameStageBgView.layer.shadowOffset = CGSizeMake(1.0, 1.0)
        gameStageBgView.layer.shadowRadius = 5.0
        
        // 背景画像を生成
        bgImage.frame = CGRectMake(0, 0, AppConst.screenBounds.width, AppConst.screenBounds.height)
        
        let blurEffect = UIBlurEffect(style: .ExtraLight)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.frame = bgImage.bounds
        visualEffectView.alpha = 0.8
        
        bgImage.addSubview(visualEffectView)
//        bgView.addSubview(bgImage)
        
        // レベルに応じて、ピースの最大数等を初期化
        if let level = defaults.objectForKey("level") {
            let pieceStatus = const.initPieceStatus(level as! String)
            maxPieces = pieceStatus.maxPieces
            pieceColumn = pieceStatus.pieceColumn
            pieceSize = pieceStatus.pieceSize
        }
        
        // パズルの生成
        var offset_x: CGFloat = pieceImage.bounds.origin.x
        var offset_y: CGFloat = pieceImage.bounds.origin.y
        
        for (var i = 0; i < pieceColumn; i++) {
            offset_y = CGFloat(i) * pieceSize
            
            for (var j = 0; j < pieceColumn; j++) {
                
                // ピース番号を生成
                id++
                let pieceId: UILabel = UILabel(frame: CGRectMake(0, 0, pieceSize, pieceSize))
                pieceId.text = String(id)
                pieceId.textAlignment = NSTextAlignment.Center
                pieceId.textColor = UIColor.whiteColor()
                
                // ピースの生成
                offset_x = CGFloat(j) * pieceSize
                
                let cropedImage = cropImage(baseImage.image!, x: offset_x, y: offset_y, w: pieceSize, h: pieceSize)
                pieceImage = UIImageView(frame: CGRectMake(offset_x, offset_y, pieceSize, pieceSize))
                pieceImage.image = cropedImage
                pieceImage.tag = id
                pieceImage.userInteractionEnabled = true
                ids.append(pieceImage.tag)
                
                let x = pieceImage.frame.origin.x
                let y = pieceImage.frame.origin.y
                let offset = [x, y]
                defaultPieceOffset.append(offset)
                
                // 最後のピースを黒く塗りつぶす
                if id == maxPieces {
                    let emptyPiece = UIView(frame: CGRectMake(0, 0, pieceSize, pieceSize))
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
    
    - parameters:
    - image: 元画像
    - x: クロップ画像のx座標
    - y: クロップ画像のy座標
    - w: クロップ画像の幅
    - y: クロップ画像の高さ
    
    - returns: クロップした画像
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
     ピースをシャッフルする
     
     - parameters:
     - ids: ピースID配列
     
     - returns: シャッフルしたピースID配列
     */
    func swapPieces(var ids: Array<Int>) -> Array<Int> {
        
        var from = 0;
        var to = 0;
        
        for _ in 1...100 {
            // 1~8ピースを偶数置換させることで、解けるパズルにする（奇数置換だと解けない）
            
            // from == toの場合のみ、繰り返し乱数を生成
            from = Int(arc4random_uniform(UInt32(maxPieces - 1)))
            
            repeat {
                to = Int(arc4random_uniform(UInt32(maxPieces - 1)))
            } while from == to
            
            // ピースID同士をスワップ
            swap(&ids[from], &ids[to])
        }
        
        return ids
    }
    
    /**
     シャッフルしたピースの再配置
     
     - parameters:
     - ids: シャッフル済ピースID配列
     - gameStageView: ゲーム画面のView
     
     - returns: none
     */
    func showPieces(ids: Array<Int>, gameStageView: UIView) {
        
        var piece = UIImageView()
        var offset_x: CGFloat = pieceImage.bounds.origin.x
        var offset_y: CGFloat = pieceImage.bounds.origin.y
        var count: Int = 0
        var tag: Int = 0
        
        for (var i = 0; i < pieceColumn; i++) {
            offset_y = CGFloat(i) * pieceSize
            
            for (var j = 0; j < pieceColumn; j++) {
                offset_x = CGFloat(j) * pieceSize
                count++
                
                // gameStageViewのpieceをtagIdを参照し取得
                tag = ids[count - 1]
                piece = gameStageView.viewWithTag(tag) as! UIImageView
                
                // gameStageViewにピースを再配置
                piece.frame = CGRectMake(offset_x, offset_y, pieceSize, pieceSize)
                gameStageView.addSubview(piece)
            }
        }
    }
    


}
