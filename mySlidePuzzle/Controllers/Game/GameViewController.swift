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
                ids.append(pieceImage.tag)
                
                // 最後のピースを黒く塗りつぶす
                if id == AppConst.maxPieces {
                    let blackPiece = UIView(frame: CGRectMake(0, 0, AppConst.pieceSize, AppConst.pieceSize))
                    blackPiece.backgroundColor = UIColor.blackColor()
                    pieceImage.addSubview(blackPiece)
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

}